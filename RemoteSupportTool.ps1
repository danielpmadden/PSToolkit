# PowerShell Remote Desktop Support Script (Simplified & Enhanced)

$logPath = "$PSScriptRoot\SupportLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

function Log-Action {
    param ([string]$message)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $message" | Out-File -FilePath $logPath -Append
}

function Check-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "This script is not running as Administrator. Some actions may fail."
        Log-Action "Warning: Script not running as Administrator."
    }
}

function Show-NetworkDiagnostics {
    while ($true) {
        Write-Host "`nNetwork Diagnostics:"
        Write-Host "1. IP Configuration"
        Write-Host "2. Ping Test"
        Write-Host "3. Internet Connectivity"
        Write-Host "4. Flush DNS Cache"
        Write-Host "5. Back to Main Menu"
        $choice = Read-Host "Select an option (1-5)"
        try {
            switch ($choice) {
                "1" { ipconfig /all | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed IP configuration." }
                "2" { $target = Read-Host "Enter IP or hostname"; Test-Connection $target -Count 4 | Tee-Object -FilePath $logPath -Append; Log-Action "Pinged $target." }
                "3" { Test-Connection -ComputerName 8.8.8.8 -Count 4 | Tee-Object -FilePath $logPath -Append; Log-Action "Checked internet connectivity." }
                "4" { Clear-DnsClientCache; Log-Action "Flushed DNS cache." }
                "5" { break }
                default { Write-Warning "Invalid selection." }
            }
        } catch {
            Write-Warning "Error: $_"
            Log-Action "Error in Network Diagnostics: $_"
        }
    }
}

function Show-SystemDiagnostics {
    while ($true) {
        Write-Host "`nSystem Diagnostics:"
        Write-Host "1. System Information"
        Write-Host "2. Recent System Errors"
        Write-Host "3. Pending Reboot Check"
        Write-Host "4. Back to Main Menu"
        $choice = Read-Host "Select an option (1-4)"
        try {
            switch ($choice) {
                "1" { systeminfo | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed system information." }
                "2" { Get-EventLog -LogName System -EntryType Error -Newest 10 | Format-Table | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed recent system errors." }
                "3" { if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) { Write-Host "Reboot required."; Log-Action "Reboot required." } else { Write-Host "No reboot required."; Log-Action "No reboot required." } }
                "4" { break }
                default { Write-Warning "Invalid selection." }
            }
        } catch {
            Write-Warning "Error: $_"
            Log-Action "Error in System Diagnostics: $_"
        }
    }
}

function Show-PerformanceMonitoring {
    while ($true) {
        Write-Host "`nPerformance Monitoring:"
        Write-Host "1. Top Running Processes"
        Write-Host "2. Disk Space Usage"
        Write-Host "3. CPU and Memory Usage"
        Write-Host "4. Back to Main Menu"
        $choice = Read-Host "Select an option (1-4)"
        try {
            switch ($choice) {
                "1" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 Name, CPU, Id | Format-Table | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed running processes." }
                "2" { Get-PSDrive -PSProvider FileSystem | Format-Table | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed disk space usage." }
                "3" { Get-Counter '\Processor(_Total)\% Processor Time','\Memory\Available MBytes' | Select-Object -ExpandProperty CounterSamples | Tee-Object -FilePath $logPath -Append; Log-Action "Displayed CPU and memory usage." }
                "4" { break }
                default { Write-Warning "Invalid selection." }
            }
        } catch {
            Write-Warning "Error: $_"
            Log-Action "Error in Performance Monitoring: $_"
        }
    }
}

function Show-MaintenanceTools {
    while ($true) {
        Write-Host "`nMaintenance Tools:"
        Write-Host "1. Restart Spooler Service"
        Write-Host "2. Clear Temporary Files"
        Write-Host "3. Retrieve Windows Update Log"
        Write-Host "4. Run Disk Cleanup"
        Write-Host "5. Defragment Drive"
        Write-Host "6. Back to Main Menu"
        $choice = Read-Host "Select an option (1-6)"
        try {
            switch ($choice) {
                "1" { Restart-Service -Name spooler -Force; Log-Action "Restarted spooler service." }
                "2" { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Log-Action "Cleared temporary files." }
                "3" { Get-WindowsUpdateLog | Tee-Object -FilePath $logPath -Append; Log-Action "Retrieved Windows Update log." }
                "4" { Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait; Log-Action "Executed Disk Cleanup." }
                "5" { $drive = Read-Host "Enter drive letter (e.g., C:)"; defrag $drive -f | Tee-Object -FilePath $logPath -Append; Log-Action "Defragmented $drive." }
                "6" { break }
                default { Write-Warning "Invalid selection." }
            }
        } catch {
            Write-Warning "Error: $_"
            Log-Action "Error in Maintenance Tools: $_"
        }
    }
}

# Start
Check-Admin

while ($true) {
    Write-Host "`nSelect a support option:"
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
