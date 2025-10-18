# PSToolkit

## Overview
PSToolkit is an interactive PowerShell script that streamlines common help desk diagnostics and maintenance activities on Windows workstations. The script guides operators through targeted menus for network checks, system triage, performance monitoring, and basic remediation steps while recording a full activity log and optional JSON exports for later review.

The repository currently ships as a single script (`PSToolkit.ps1`) with no external module dependencies. This audit focuses on improving documentation, quality guardrails, and repository hygiene without modifying the functional code paths.

## Key Features
- Interactive console menus for network diagnostics, system health inspection, performance snapshots, and maintenance operations.
- Automatic session logging to `Outputs/Logs` with timestamps for traceability.
- Optional JSON exports under `Outputs/Json` for structured reporting and downstream analysis.
- Administrator check (`Ensure-Administrator`) to prevent privileged actions from running without elevation.
- Modular helper functions (`Log-Action`, `Write-JsonOutput`, `Get-ValidatedChoice`) that centralize reusable behavior within the script.

## Requirements
- Windows PowerShell 5.1 or PowerShell 7.0+ on Windows.
- Local administrative rights for maintenance actions such as restarting services, clearing temporary files, and launching Disk Cleanup.
- Sufficient disk space on the host for log and JSON export directories created at runtime.

## Installation
1. **Clone the repository**
   ```powershell
   git clone https://github.com/your-org/PSToolkit.git
   cd PSToolkit
   ```
2. **Review execution policy** (if not already permitting local scripts)
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```
3. **Verify PowerShell version**
   ```powershell
   $PSVersionTable.PSVersion
   ```

> Restore your organization’s preferred execution policy after confirming PSToolkit runs as expected.

## Quick Start
1. Launch PowerShell with administrative rights when you intend to run maintenance tasks.
2. Navigate to the cloned repository directory.
3. Execute the script:
   ```powershell
   .\PSToolkit.ps1
   ```
4. Follow the on-screen prompts to select diagnostic or maintenance actions. Logs and JSON exports are created automatically.

### Example Session
```text
Select a support option:
1. Network Diagnostics
2. System Diagnostics
3. Performance Monitoring
4. Maintenance Tools
5. Exit
Enter your choice (1-5): 1
```

### Output Locations
- Logs: `Outputs/Logs/SupportLog_<timestamp>.txt`
- JSON exports: `Outputs/Json/*.json`

## Troubleshooting and Support
| Issue | Resolution |
| --- | --- |
| Execution policy prevents script launch | Run the installation step above to set `RemoteSigned`, then retry. |
| Log files fail to write | Confirm the current user has write access to the repository directory or set PowerShell to run as Administrator. |
| Maintenance actions warn about privileges | Rerun PowerShell as Administrator; the script exits early without elevation. |
| Windows Update check warning appears | Install the optional [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) module or skip the menu item. |

For additional support or to report issues, open a ticket in the repository issue tracker with log excerpts and the selected menu path.

## Development Notes
- The codebase currently consists of a single script. Future refactors should consider extracting reusable logic into a PowerShell module to improve testability.
- Repository automation now includes linting guidance via GitHub Actions (see `.github/workflows/lint.yml`).
- Planned test coverage will use [Pester](https://pester.dev/). Place future tests under the `tests/` directory.
- Run static analysis locally with `Invoke-ScriptAnalyzer -Path .` after installing `PSScriptAnalyzer`.

## Testing
While automated tests are not yet implemented, contributors can prepare the environment with the following commands:
```powershell
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
Invoke-ScriptAnalyzer -Path .\PSToolkit.ps1
```
Add Pester tests as they are developed:
```powershell
Invoke-Pester -Path .\tests -Output Detailed
```

## Security and Compliance
- Input prompts for ping targets and defragmentation accept raw user input. Validate entries manually before confirming operations.
- Clearing temporary files and launching Disk Cleanup or defragmentation may affect end-user workloads; communicate scheduled maintenance windows.
- Recommended security tooling: PSScriptAnalyzer for linting, secret scanning via GitHub Advanced Security (if available), and Just Enough Administration (JEA) policies for production environments.

## Dependency Overview
A high-level view of repository contents is maintained in [`docs/DEPENDENCY_OVERVIEW.md`](docs/DEPENDENCY_OVERVIEW.md). Update this document when new modules, scripts, or documentation directories are added.

## License
This project is licensed under the [MIT License](LICENSE).

## Credits
Created and maintained by Daniel Madden. Contributions are welcome via pull requests that include updated documentation and lint results.
