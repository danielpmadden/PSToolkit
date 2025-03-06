# Remote Desktop Support Toolkit

## Overview

This PowerShell-based support toolkit is designed for IT technicians to efficiently perform diagnostics, maintenance, and troubleshooting during remote desktop sessions. It provides a simple, menu-driven interface with automatic audit logging and a self-cleaning mechanism that removes the script after use, ensuring no leftover files on the user's system.

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
- View CPU and memory usage

### Maintenance Tools
- Restart the print spooler service
- Clear temporary files
- Retrieve the Windows Update log

### Additional Functions
- Automatically logs all actions and outputs to a timestamped log file.
- Self-deletes after execution to prevent leaving behind support tools on the system.

---

## Prerequisites

- **Operating System**: Windows 10 or later
- **PowerShell**: Version 5.1 or higher
- **Permissions**: Administrator privileges are required

---

## Installation

1. Download the script.
2. Copy the script to the target machine (e.g., `C:\SupportTools\`).
3. (Optional) Review or customize the script as needed.

---

## Usage

1. Open **PowerShell as Administrator**.
2. Bypass the execution policy if necessary:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
