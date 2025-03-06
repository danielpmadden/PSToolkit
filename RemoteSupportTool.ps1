# PowerShell Remote Desktop Support Script
# Author: Daniel Madden

# Script designed for IT Technicians providing remote desktop support.

$logPath = "$PSScriptRoot\SupportLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

function Log-Action {
    param ([string]$message)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $message" | Out-File -FilePath $logPath -Append
}

# Main support menu loop
$continue = $true
while ($continue) {
    Write-Host "`nSelect a support option:"
    Write-Host "1. Network Diagnostics"
    Write-Host "2. System Diagnostics"
    Write-Host "3. Performance Monitoring"
    Write-Host "4. Maintenance Tools"
    Write-Host "5. Exit"

    $mainChoice = Read-Host "Enter your choice (1-5)"
    Log-Action "Main menu selection: $mainChoice"

    switch ($mainChoice) {
        "1" {
            Write-Host "`nNetwork Diagnostics:" 
            Write-Host "  a. Check User's IP Configuration"
            Write-Host "  b. Check Network Connectivity (Ping Test)"
            Write-Host "  c. Check Internet Connectivity"
            Write-Host "  d. Flush DNS Resolver Cache"
            $subChoice = Read-Host "Select an option (a-d)"
            Log-Action "Network Diagnostics selection: $subChoice"

            switch ($subChoice) {
                "a" { ipconfig /all | Tee-Object -FilePath $logPath -Append }
                "b" { $address = Read-Host "Enter the IP or domain to ping"; Log-Action "Ping target: $address"; Test-Connection $address -Count 4 | Tee-Object -FilePath $logPath -Append }
                "c" { Test-Connection -ComputerName 8.8.8.8 -Count 4 | Tee-Object -FilePath $logPath -Append }
                "d" { Clear-DnsClientCache; Log-Action "DNS cache flushed." }
            }
        }
        "2" {
            Write-Host "`nSystem Diagnostics:" 
            Write-Host "  a. Retrieve System Information"
            Write-Host "  b. View Recent System Error Logs"
            Write-Host "  c. Check for Pending Reboot"
            $subChoice = Read-Host "Select an option (a-c)"
            Log-Action "System Diagnostics selection: $subChoice"

            switch ($subChoice) {
                "a" { systeminfo | Tee-Object -FilePath $logPath -Append }
                "b" { Get-EventLog -LogName System -EntryType Error -Newest 10 | Format-Table | Tee-Object -FilePath $logPath -Append }
                "c" { $rebootRequired = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue; if ($rebootRequired) { Log-Action "A system reboot is pending." } else { Log-Action "No pending reboot detected." } }
            }
        }
        "3" {
            Write-Host "`nPerformance Monitoring:" 
            Write-Host "  a. Show Running Processes"
            Write-Host "  b. Check Disk Space Usage"
            Write-Host "  c. Basic CPU and Memory Usage"
            $subChoice = Read-Host "Select an option (a-c)"
            Log-Action "Performance Monitoring selection: $subChoice"

            switch ($subChoice) {
                "a" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 | Format-Table | Tee-Object -FilePath $logPath -Append }
                "b" { Get-PSDrive -PSProvider FileSystem | Format-Table | Tee-Object -FilePath $logPath -Append }
                "c" { Get-CimInstance Win32_Processor, Win32_OperatingSystem | Tee-Object -FilePath $logPath -Append }
            }
        }
        "4" {
            Write-Host "`nMaintenance Tools:" 
            Write-Host "  a. Restart Spooler Service (Printer Issues)"
            Write-Host "  b. Clear Temporary Files"
            Write-Host "  c. Check for Windows Updates"
            $subChoice = Read-Host "Select an option (a-c)"
            Log-Action "Maintenance Tools selection: $subChoice"

            switch ($subChoice) {
                "a" { Restart-Service -Name spooler -Force; Log-Action "Spooler service restarted." }
                "b" { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Log-Action "Temporary files cleared." }
                "c" { Get-WindowsUpdateLog | Tee-Object -FilePath $logPath -Append; Log-Action "Windows Update log retrieved." }
            }
        }
        "5" {
            Write-Output "Exiting support script."
            Log-Action "Script exited."
            $continue = $false
        }
        default {
            Write-Warning "Invalid selection. Please choose a valid option."
        }
    }
}

# Self-delete after completion
Start-Sleep -Seconds 3
Remove-Item -Path $MyInvocation.MyCommand.Definition -Force
Log-Action "Script self-deleted."
