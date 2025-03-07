# Remote Desktop Support Toolkit

## Overview

This PowerShell-based support toolkit is designed to help IT technicians quickly perform diagnostics, maintenance, and troubleshooting during remote desktop support sessions. The script provides a simple, menu-driven interface to run common tasks while logging all actions for audit purposes.

---

## Features

### Network Diagnostics
- Display IP configuration
- Run ping tests
- Check internet connectivity
- Flush DNS resolver cache

### System Diagnostics
- Retrieve system information
- View recent system error logs
- Check for pending reboots

### Performance Monitoring
- Display top running processes
- Check disk space usage
- Monitor CPU and memory usage

### Maintenance Tools
- Restart the print spooler service
- Clear temporary files
- Retrieve the Windows Update log
- Run Disk Cleanup
- Defragment a selected drive

### Additional
- Logs all actions and outputs to a timestamped log file.
- No installation required — run directly from any folder.

---

## Prerequisites

- **Operating System**: Windows 10 or later
- **PowerShell**: Version 5.1 or higher
- **Permissions**: Administrator privileges are required

---

## Installation

1. Download the script.
2. Copy the script to the target machine (for example: `C:\SupportTools\`).
3. (Optional) Review or customize the script before use.

---

## Usage

1. Open **PowerShell as Administrator**.
2. If needed, temporarily bypass the execution policy: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
3. Run the script: ./RemoteSupportTool.ps1
4. Follow the on-screen menu to select and run support tasks.

---

## Logs

Every action is automatically logged in a timestamped .txt file.
The log file is saved in the same directory as the script.

---

## Best Practices

- Always run the script with administrator privileges.
- Test the script in a controlled environment before using it in production.
- Retain logs as part of your service documentation when needed.

---

## License

This project is licensed under the MIT License.
