# PowerShell Remote Desktop Support Script (Enhanced & Ordered)

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

function Run-Menu {
    param (
        [string]$title,
        [hashtable]$options
    )
    while ($true) {
        Write-Host "`n$title"
        $options.Keys | ForEach-Object { Write-Host "$_. $($options[$_].Description)" }
        Write-Host "0. Back to Main Menu"
        $choice = Read-Host "Select an option"
        if ($choice -eq "0") { break }
        if ($options.ContainsKey($choice)) {
            try {
                & $options[$choice].Action
                Log-Action "Executed: $($options[$choice].Description)"
            } catch {
                Write-Warning "Error: $_"
                Log-Action "Error during '$($options[$choice].Description)': $_"
            }
        } else {
            Write-Warning "Invalid selection."
        }
    }
}

function Show-NetworkDiagnostics {
    $options = [ordered]@{
        "1" = @{ Description = "IP Configuration"; Action = { ipconfig /all | Tee-Object -FilePath $logPath -Append } }
        "2" = @{ Description = "Ping Test"; Action = { $target = Read-Host "Enter IP or hostname"; Test-Connection $target -Count 4 | Tee-Object -FilePath $logPath -Append } }
        "3" = @{ Description = "Internet Connectivity"; Action = { Test-Connection -ComputerName 8.8.8.8 -Count 4 | Tee-Object -FilePath $logPath -Append } }
        "4" = @{ Description = "Flush DNS Cache"; Action = { Clear-DnsClientCache } }
    }
    Run-Menu -title "Network Diagnostics:" -options $options
}

function Show-SystemDiagnostics {
    $options = [ordered]@{
        "1" = @{ Description = "System Information"; Action = { systeminfo | Tee-Object -FilePath $logPath -Append } }
        "2" = @{ Description = "Recent System Errors"; Action = { Get-EventLog -LogName System -EntryType Error -Newest 10 | Format-Table | Tee-Object -FilePath $logPath -Append } }
        "3" = @{ Description = "Pending Reboot Check"; Action = { if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) { Write-Host "Reboot required." } else { Write-Host "No reboot required." } } }
    }
    Run-Menu -title "System Diagnostics:" -options $options
}

function Show-PerformanceMonitoring {
    $options = [ordered]@{
        "1" = @{ Description = "Top Running Processes"; Action = { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 Name, CPU, Id | Format-Table | Tee-Object -FilePath $logPath -Append } }
        "2" = @{ Description = "Disk Space Usage"; Action = { Get-PSDrive -PSProvider FileSystem | Format-Table | Tee-Object -FilePath $logPath -Append } }
        "3" = @{ Description = "CPU and Memory Usage"; Action = { Get-Counter '\Processor(_Total)\% Processor Time','\Memory\Available MBytes' | Select-Object -ExpandProperty CounterSamples | Tee-Object -FilePath $logPath -Append } }
    }
    Run-Menu -title "Performance Monitoring:" -options $options
}

function Show-MaintenanceTools {
    $options = [ordered]@{
        "1" = @{ Description = "Restart Spooler Service"; Action = { Restart-Service -Name spooler -Force } }
        "2" = @{ Description = "Clear Temporary Files"; Action = { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue } }
        "3" = @{ Description = "Retrieve Windows Update Log"; Action = { Get-WindowsUpdateLog | Tee-Object -FilePath $logPath -Append } }
        "4" = @{ Description = "Run Disk Cleanup"; Action = { Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait } }
        "5" = @{ Description = "Defragment Drive"; Action = { $drive = Read-Host "Enter drive letter (e.g., C:)"; defrag $drive -f | Tee-Object -FilePath $logPath -Append } }
    }
    Run-Menu -title "Maintenance Tools:" -options $options
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
