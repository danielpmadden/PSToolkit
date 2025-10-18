# PSToolkit Dependency Overview

The project currently consists of a single interactive PowerShell script. The layout below highlights the primary assets and their responsibilities.

```
PSToolkit/
 ├── PSToolkit.ps1       → Interactive diagnostics and maintenance menu
 ├── README.md           → Project overview, usage, and contributor guidance
 ├── docs/               → Extended documentation and architecture notes
 │    └── DEPENDENCY_OVERVIEW.md → This document
 ├── tests/              → Placeholder for future Pester-based test suites
 ├── .github/workflows/  → Continuous integration definitions
 │    └── lint.yml       → Lint and audit workflow for GitHub Actions
 ├── .gitignore          → Repository hygiene rules for generated artifacts
 ├── LICENSE             → MIT license terms
 ├── CHANGELOG.md        → Versioned summary of repository-level updates
 └── ROADMAP.md          → Planned enhancements, audit notes, and security guidance
```

## Script Dependencies
- Built-in Windows executables: `ipconfig`, `systeminfo`, `cleanmgr.exe`, `defrag`.
- PowerShell cmdlets: `Get-Process`, `Get-EventLog`, `Get-CimInstance`, `Restart-Service`, `Start-Process`, and `Test-Connection`.
- Optional module: `PSWindowsUpdate` for Windows Update integration (not bundled).

## Documentation and Automation
- Documentation artifacts live under `docs/` and the repository root.
- Continuous integration tooling is defined under `.github/workflows/` and uses GitHub-hosted runners (`ubuntu-latest`) with PowerShell 7.
- No packaged modules or external libraries are committed; repository consumers should install optional dependencies locally as needed.
