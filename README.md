# RemoteDesktopSupportToolkit
A modular PowerShell menu designed for IT Technicians providing remote desktop support to end-users. Includes diagnostic tools, maintenance utilities, and basic system health checks.

## Features:
- Network Diagnostics (IP config, Ping, DNS flush)
- System Diagnostics (System Info, Event Logs, Pending Reboot)
- Performance Monitoring (Processes, Disk, CPU/Memory)
- Maintenance Tools (Clear Temp Files, Restart Spooler, Check Windows Updates)

## Getting Started:
1. Clone the repository.
2. Open PowerShell as Administrator.
3. Run the script:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ./RemoteSupportTool.ps1
