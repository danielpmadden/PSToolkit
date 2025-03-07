# PSToolkit - a PowerShell support toolkit with JSON outputs, robust logging, and modular structure.

# Provides interactive system diagnostics, performance monitoring, and maintenance tools for Windows systems.

# Implements structured logging, error handling, input validation, and optional JSON outputs for further processing.

# Enforce termination on all non-handled errors to avoid inconsistent script state.
$ErrorActionPreference = "Stop"

# Generate consistent timestamp for log and JSON file naming.
$timestamp = (Get-Date -Format 'yyyyMMdd_HHmmss')

# Define log file path for session-wide action tracking.
$logPath = "$PSScriptRoot\Outputs\Logs\SupportLog_$timestamp.txt"

# Define directory for JSON outputs to store structured results.
$jsonPath = "$PSScriptRoot\Outputs\Json"

<# 
    Log-Action
    Records timestamped actions to a session log to provide a traceable history of operations.
#>
function Log-Action {
    param ([string]$message)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $message" | Out-File -FilePath $logPath -Append
}

<# 
    Write-JsonOutput
    Writes structured data to JSON files to enable machine-readable output for analysis or reporting.
#>
function Write-JsonOutput {
    param (
        [string]$fileName,
        [object]$data
    )
    $fullPath = Join-Path $jsonPath $fileName
    $data | ConvertTo-Json -Depth 5 | Out-File -FilePath $fullPath -Encoding UTF8
    Log-Action "Wrote JSON output to $fullPath"
}

<#
    Get-ValidatedChoice
    Prompts the user until a valid option from the predefined list is entered.
    Protects against invalid input and ensures predictable script flow.
#>
function Get-ValidatedChoice {
    param (
        [string]$prompt,
        [string[]]$validOptions
    )
    do {
        $choice = Read-Host $prompt
    } while ($choice -notin $validOptions)
    return $choice
}

<#
    Ensure-Administrator
    Validates that the script is running with administrative privileges, required for system-level operations.
#>
function Ensure-Administrator {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "This script must be run as Administrator."
        Log-Action "Script terminated: insufficient privileges."
        exit
    }
}

<#
    Show-NetworkDiagnostics
    Interactive submenu for network troubleshooting tasks.
    Captures outputs to both log and JSON where applicable.
#>
function Show-NetworkDiagnostics {
    Write-Host "`nNetwork Diagnostics:"
    Write-Host "1. IP Configuration"
    Write-Host "2. Ping Test"
    Write-Host "3. Internet Connectivity"
    Write-Host "4. Flush DNS Cache"
    $choice = Get-ValidatedChoice "Select an option (1-4)" @('1','2','3','4')
    Log-Action "Network Diagnostics menu selection: $choice"

    switch ($choice) {
        "1" {
            $output = ipconfig /all
            $output | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "IPConfiguration.json" -data $output
            Log-Action "Captured IP configuration."
        }
        "2" {
            $target = Read-Host "Enter IP or hostname to ping"
            $result = Test-Connection $target -Count 4
            $result | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "PingTest.json" -data $result
            Log-Action "Executed ping to $target."
        }
        "3" {
            $result = Test-Connection -ComputerName 8.8.8.8 -Count 4
            $result | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "InternetConnectivity.json" -data $result
            Log-Action "Verified internet connectivity."
        }
        "4" {
            Clear-DnsClientCache
            Log-Action "Cleared DNS cache."
        }
    }
}

<#
    Show-SystemDiagnostics
    Collects general system health information and checks for reboot status.
#>
function Show-SystemDiagnostics {
    Write-Host "`nSystem Diagnostics:"
    Write-Host "1. System Information"
    Write-Host "2. Recent System Errors"
    Write-Host "3. Pending Reboot Check"
    $choice = Get-ValidatedChoice "Select an option (1-3)" @('1','2','3')
    Log-Action "System Diagnostics menu selection: $choice"

    switch ($choice) {
        "1" {
            $output = systeminfo
            $output | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "SystemInfo.json" -data $output
            Log-Action "Collected system information."
        }
        "2" {
            $errors = Get-EventLog -LogName System -EntryType Error -Newest 10
            $errors | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "RecentSystemErrors.json" -data $errors
            Log-Action "Retrieved recent system errors."
        }
        "3" {
            $rebootRequired = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue
            $status = if ($rebootRequired) { "Reboot Required" } else { "No Reboot Required" }
            Write-JsonOutput -fileName "RebootStatus.json" -data @{ Status = $status }
            Log-Action "$status."
        }
    }
}

<#
    Show-PerformanceMonitoring
    Reports on resource usage, highlighting high-load processes and system status.
#>
function Show-PerformanceMonitoring {
    Write-Host "`nPerformance Monitoring:"
    Write-Host "1. Running Processes"
    Write-Host "2. Disk Space Usage"
    Write-Host "3. CPU and Memory Usage"
    $choice = Get-ValidatedChoice "Select an option (1-3)" @('1','2','3')
    Log-Action "Performance Monitoring menu selection: $choice"

    switch ($choice) {
        "1" {
            $processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First 20
            $processes | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "RunningProcesses.json" -data $processes
            Log-Action "Reported top CPU-consuming processes."
        }
        "2" {
            $drives = Get-PSDrive -PSProvider FileSystem
            $drives | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "DiskSpaceUsage.json" -data $drives
            Log-Action "Reported disk space usage."
        }
        "3" {
            $stats = Get-CimInstance Win32_Processor, Win32_OperatingSystem
            $stats | Out-File -FilePath $logPath -Append
            Write-JsonOutput -fileName "CpuMemoryUsage.json" -data $stats
            Log-Action "Reported CPU and memory usage."
        }
    }
}
<#
    Show-MaintenanceTools
    Provides common system maintenance actions to enhance system stability and performance.
#>
function Show-MaintenanceTools {
    Write-Host "`nMaintenance Tools:"
    Write-Host "1. Restart Spooler Service"
    Write-Host "2. Clear Temporary Files"
    Write-Host "3. Check Windows Updates"
    Write-Host "4. Run Disk Cleanup"
    Write-Host "5. Defragment Drive"
    $choice = Get-ValidatedChoice "Select an option (1-5)" @('1','2','3','4','5')
    Log-Action "Maintenance Tools menu selection: $choice"

    switch ($choice) {
        "1" {
            # Restart the print spooler service, commonly needed to resolve print queue issues.
            Restart-Service -Name spooler -Force
            Log-Action "Restarted spooler service."
        }
        "2" {
            # Clears the TEMP folder to free disk space and remove unnecessary files.
            $deletedFiles = (Get-ChildItem -Path "$env:TEMP" -Recurse -ErrorAction SilentlyContinue).Count
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-JsonOutput -fileName "TempFilesCleared.json" -data @{ FilesDeleted = $deletedFiles }
            Log-Action "Cleared $deletedFiles temporary files."
        }
        "3" {
            # Placeholder for Windows Update checks using PSWindowsUpdate if available.
            Write-Warning "Windows Update check requires PSWindowsUpdate module."
            Log-Action "Skipped Windows Update check (module missing)."
        }
        "4" {
            # Launches Disk Cleanup in silent mode using predefined settings (configured via cleanmgr.exe /sageset).
            Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
            Log-Action "Executed Disk Cleanup."
        }
        "5" {
            # Performs defragmentation on the specified drive to optimize disk performance.
            $drive = Read-Host "Enter drive letter (e.g., C:)"
            defrag $drive -f
            Log-Action "Defragmented $drive."
        }
    }
}

<#
    Ensure the script runs with administrative privileges before performing any sensitive actions.
#>
Ensure-Administrator

<#
    Main Menu Loop
    Continuously presents the user with high-level options until exit is selected.
    Each submenu executes its own category of system support actions.
#>
while ($true) {
    Write-Host "`nSelect a support option:"
    Write-Host "1. Network Diagnostics"
    Write-Host "2. System Diagnostics"
    Write-Host "3. Performance Monitoring"
    Write-Host "4. Maintenance Tools"
    Write-Host "5. Exit"

    $mainChoice = Get-ValidatedChoice "Enter your choice (1-5)" @('1','2','3','4','5')
    Log-Action "Main menu selection: $mainChoice"

    switch ($mainChoice) {
        "1" { Show-NetworkDiagnostics }
        "2" { Show-SystemDiagnostics }
        "3" { Show-PerformanceMonitoring }
        "4" { Show-MaintenanceTools }
        "5" { 
            Log-Action "User exited the script."
            break
        }
    }
}

<#
    Session Conclusion
    Notifies the user of the log file location and gracefully ends the script.
#>
Write-Host "`nSupport session completed."
Write-Host "Log file saved to: $logPath"
Write-Host "JSON outputs saved to: $jsonPath"
