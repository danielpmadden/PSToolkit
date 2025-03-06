# Remote Desktop Support Toolkit

## Overview

This PowerShell script is designed to assist IT technicians in providing remote desktop support on Windows. It offers a menu-driven interface to quickly perform common diagnostics, troubleshooting tasks, and basic system maintenance on Windows systems. The goal is to streamline support sessions by giving technicians direct access to essential tools in one place.

---

## Features

### Network Diagnostics
- View IP configuration
- Test network connectivity
- Check internet access
- Flush DNS resolver cache

### System Diagnostics
- Retrieve system information
- View recent system error logs
- Check for pending reboots

### Performance Monitoring
- Display running processes
- Check disk space usage
- View CPU and memory statistics

### Maintenance Tools
- Restart the print spooler service
- Clear temporary files
- Retrieve the Windows Update log

---

## Prerequisites

- **Operating System**: Windows 10 or later
- **PowerShell Version**: 5.1 or higher
- **Permissions**: Administrator privileges are required for full functionality

---

## Installation

1. Download the repository files.
2. Place the script (`RemoteSupportTool.ps1`) in an accessible directory.
3. (Optional) Review the script to customize or extend functionality.

---

## Usage

1. Open **PowerShell as Administrator**.
2. If the script is blocked due to execution policy, enter the following:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
