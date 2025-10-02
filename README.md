# PSToolkit - A PowerShell support toolkit

## Overview

A PowerShell support toolkit designed to perform remote desktop support tasks efficiently. Includes automated logging and a menu-driven interface for diagnostics and maintenance.

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

## Prerequisites

- **Operating System**: Windows 10 or later
- **PowerShell**: Version 5.1 or higher
- **Permissions**: Administrator privileges are required

## Installation

1. Download the script.
2. Copy the script to the target machine (for example: `C:\SupportTools\`).
3. (Optional) Review or customize the script before use.

## Usage

1. Open **PowerShell as Administrator**.
2. If needed, temporarily bypass the execution policy: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
3. Run the script: ./PSToolkit.ps1
4. Follow the on-screen menu to select and run support tasks.

## Logs

Every action is automatically logged in a timestamped .txt file. The script automatically creates an `Outputs` folder alongside the script on first run. Log files are stored in `Outputs/Logs` and JSON data exports are written to `Outputs/Json`.

## License

This project is licensed under the MIT License.
