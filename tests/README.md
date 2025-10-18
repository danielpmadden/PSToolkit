# Tests

This directory is reserved for future Pester-based unit and integration tests. Contributors should:

1. Install Pester if it is not already available:
   ```powershell
   Install-Module -Name Pester -Scope CurrentUser -Force
   ```
2. Add test files following the `*.Tests.ps1` naming convention.
3. Run the suite locally with:
   ```powershell
   Invoke-Pester -Path . -Output Detailed
   ```

Document new test cases in `CHANGELOG.md` and update the CI workflow if additional setup steps are required.
