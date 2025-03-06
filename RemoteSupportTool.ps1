# PowerShell Remote Desktop Support Script
# Author: [Your First and Last Name] - [Student ID]

# Script designed for IT Technicians providing remote desktop support.

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

    switch ($mainChoice) {
        "1" {
            Write-Host "`nNetwork Diagnostics:" 
            Write-Host "  a. Check User's IP Configuration"
            Write-Host "  b. Check Network Connectivity (Ping Test)"
            Write-Host "  c. Check Internet Connectivity"
            Write-Host "  d. Flush DNS Resolver Cache"
            $subChoice = Read-Host "Select an option (a-d)"

            switch ($subChoice) {
                "a" { ipconfig /all }
                "b" { $address = Read-Host "Enter the IP or domain to ping"; Test-Connection $address -Count 4 }
                "c" { Test-Connection -ComputerName 8.8.8.8 -Count 4 }
                "d" { Clear-DnsClientCache; Write-Output "DNS cache flushed." }
            }
        }
        "2" {
            Write-Host "`nSystem Diagnostics:" 
            Write-Host "  a. Retrieve System Information"
            Write-Host "  b. View Recent System Error Logs"
            Write-Host "  c. Check for Pending Reboot"
            $subChoice = Read-Host "Select an option (a-c)"

            switch ($subChoice) {
                "a" { systeminfo | Out-String | Write-Output }
                "b" { Get-EventLog -LogName System -EntryType Error -Newest 10 | Format-Table TimeGenerated, Source, Message -AutoSize }
                "c" { $rebootRequired = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue; if ($rebootRequired) { Write-Output "A system reboot is pending." } else { Write-Output "No pending reboot detected." } }
            }
        }
        "3" {
            Write-Host "`nPerformance Monitoring:" 
            Write-Host "  a. Show Running Processes"
            Write-Host "  b. Check Disk Space Usage"
            Write-Host "  c. Basic CPU and Memory Usage"
            $subChoice = Read-Host "Select an option (a-c)"

            switch ($subChoice) {
                "a" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 | Format-Table -AutoSize }
                "b" { Get-PSDrive -PSProvider FileSystem | Format-Table Name, @{Label='Free(GB)';Expression={[math]::Round($_.Free/1GB,2)}}, @{Label='Used(GB)';Expression={[math]::Round(($_.Used)/1GB,2)}}, @{Label='Total(GB)';Expression={[math]::Round($_.Size/1GB,2)}} -AutoSize }
                "c" { Get-CimInstance Win32_Processor | Select-Object Name, LoadPercentage; Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory }
            }
        }
        "4" {
            Write-Host "`nMaintenance Tools:" 
            Write-Host "  a. Restart Spooler Service (Printer Issues)"
            Write-Host "  b. Clear Temporary Files"
            Write-Host "  c. Check for Windows Updates"
            $subChoice = Read-Host "Select an option (a-c)"

            switch ($subChoice) {
                "a" { Restart-Service -Name spooler -Force; Write-Output "Spooler service restarted." }
                "b" { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Write-Output "Temporary files cleared." }
                "c" { Get-WindowsUpdateLog; Write-Output "Windows Update log retrieved." }
            }
        }
        "5" {
            Write-Output "Exiting support script."
            $continue = $false
        }
        default {
            Write-Warning "Invalid selection. Please choose a valid option."
        }
    }
}
