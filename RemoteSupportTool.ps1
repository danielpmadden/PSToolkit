# PowerShell Remote Desktop Support Script
# Author: Daniel Madden

$logPath = "$PSScriptRoot\SupportLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

function Log-Action {
    param ([string]$message)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $message" | Out-File -FilePath $logPath -Append
}

function Show-NetworkDiagnostics {
    Write-Host "\nNetwork Diagnostics:" 
    Write-Host "1. IP Configuration"
    Write-Host "2. Ping Test"
    Write-Host "3. Internet Connectivity"
    Write-Host "4. Flush DNS Cache"
    $choice = Read-Host "Select an option (1-4)"
    switch ($choice) {
        "1" { ipconfig /all | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed IP configuration." }
        "2" { $target = Read-Host "Enter IP or hostname to ping"; Test-Connection $target -Count 4 | Tee-Object -FilePath $logPath -Append; Log-Action "Pinged $target." }
        "3" { Test-Connection -ComputerName 8.8.8.8 -Count 4 | Tee-Object -FilePath $logPath -Append; Log-Action "Checked internet connectivity." }
        "4" { Clear-DnsClientCache; Log-Action "Flushed DNS cache." }
    }
}

function Show-SystemDiagnostics {
    Write-Host "\nSystem Diagnostics:" 
    Write-Host "1. System Information"
    Write-Host "2. Recent System Errors"
    Write-Host "3. Pending Reboot Check"
    $choice = Read-Host "Select an option (1-3)"
    switch ($choice) {
        "1" { systeminfo | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed system information." }
        "2" { Get-EventLog -LogName System -EntryType Error -Newest 10 | Format-Table | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed recent system errors." }
        "3" { if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) { Log-Action "Reboot required." } else { Log-Action "No reboot required." } }
    }
}

function Show-PerformanceMonitoring {
    Write-Host "\nPerformance Monitoring:" 
    Write-Host "1. Running Processes"
    Write-Host "2. Disk Space Usage"
    Write-Host "3. CPU and Memory Usage"
    $choice = Read-Host "Select an option (1-3)"
    switch ($choice) {
        "1" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 | Format-Table | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed running processes." }
        "2" { Get-PSDrive -PSProvider FileSystem | Format-Table | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed disk space usage." }
        "3" { Get-CimInstance Win32_Processor, Win32_OperatingSystem | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed CPU and memory usage." }
    }
}

function Show-MaintenanceTools {
    Write-Host "\nMaintenance Tools:" 
    Write-Host "1. Restart Spooler Service"
    Write-Host "2. Clear Temporary Files"
    Write-Host "3. Check Windows Updates"
    Write-Host "4. Run Disk Cleanup"
    Write-Host "5. Defragment Drive"
    $choice = Read-Host "Select an option (1-5)"
    switch ($choice) {
        "1" { Restart-Service -Name spooler -Force; Log-Action "Restarted spooler service." }
        "2" { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Log-Action "Cleared temporary files." }
        "3" { Get-WindowsUpdate -Install -AcceptAll -AutoReboot -FilePath $logPath -Append; Log-Action "Retrieved Windows Update." }
        "4" { Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait; Log-Action "Executed Disk Cleanup." }
        "5" { $drive = Read-Host "Enter drive letter (e.g., C:)"; defrag $drive -f | Tee-Object -FilePath $logPath -Append; Log-Action "Defragmented $drive." }
    }
}

while ($true) {
    Write-Host "\nSelect a support option:"
    Write-Host "1. Network Diagnostics"
    Write-Host "2. System Diagnostics"
    Write-Host "3. Performance Monitoring"
    Write-Host "4. Maintenance Tools"
    Write-Host "5. Exit"

    $mainChoice = Read-Host "Enter your choice (1-5)"
    Log-Action "Main menu selection: $mainChoice"

    switch ($mainChoice) {
        "1" { Show-NetworkDiagnostics }
        "2" { Show-SystemDiagnostics }
        "3" { Show-PerformanceMonitoring }
        "4" { Show-MaintenanceTools }
        "5" { Log-Action "Script exited."; break }
        default { Write-Warning "Invalid selection." }
    }
}
