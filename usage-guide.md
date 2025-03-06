# Remote Desktop Support Toolkit – Usage Guide

## Introduction

This toolkit is designed to assist IT technicians during remote desktop support sessions. The PowerShell script provides a menu-driven interface to perform common diagnostics and maintenance tasks on Windows systems efficiently. It helps streamline support sessions by giving technicians direct access to essential tools in one place.

---

## Running the Script

### Prerequisites
- **Operating System**: Windows 10 or later
- **PowerShell**: Version 5.1 or higher
- **Permissions**: Administrator privileges are required for full functionality

### How to Run
1. Open **PowerShell as Administrator**.
2. If necessary, bypass the execution policy:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
