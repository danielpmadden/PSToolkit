# PSToolkit Roadmap

Author: Daniel Madden

## Current Status
PSToolkit is a prototype-stage PowerShell script that offers interactive diagnostics and remediation menus for Windows endpoints. The codebase is monolithic and lacks automated testing, packaging, or non-interactive execution modes. Documentation and automation have now been modernized to make future improvements easier without altering functional behavior.

## Near-Term Goals (0–3 Months)
1. **Stabilize core actions**
   - Add input validation and confirmation prompts for maintenance tasks that call external executables (`defrag`, `cleanmgr.exe`).
   - Wrap network and maintenance actions in `try/catch` blocks to improve user-facing error messages.
   - Ensure JSON exports emit structured objects rather than raw command output strings.
2. **Introduce automation guardrails**
   - Implement a `param` block to support non-interactive execution aligned with documentation expectations.
   - Create Pester smoke tests covering each menu path and wire them into the CI workflow.
   - Publish baseline lint configuration for PSScriptAnalyzer.

## Mid-Term Goals (3–6 Months)
1. **Modularization**
   - Refactor script functions into a PowerShell module with an accompanying module manifest.
   - Separate user interface prompts from action logic to enable headless execution and reuse.
2. **Configuration and Packaging**
   - Implement configuration loading from `config.json`/`config.local.json` with environment overrides.
   - Prepare an automated release pipeline that packages the module for the PowerShell Gallery or internal feeds.

## Long-Term Goals (6+ Months)
1. **Security and Observability Enhancements**
   - Integrate telemetry for JSON log rotation, central log shipping, and optional event forwarding.
   - Adopt Just Enough Administration (JEA) or role-based execution profiles for privileged tasks.
2. **Scalability Features**
   - Add remote session orchestration (PowerShell remoting) and centralized reporting dashboards.
   - Provide an extensibility model for custom remediation scripts.

## Deferred Work and Open Questions
- Determine whether maintenance operations such as defragmentation should be scoped down or moved to a separate script due to operational risk.
- Evaluate support for non-Windows environments using PowerShell 7; most commands are Windows-specific.
- Assess logging footprint on constrained endpoints and determine retention policies.

## Dependencies and Compatibility
- Built-in Windows tools (`ipconfig`, `systeminfo`, `cleanmgr.exe`, `defrag`) remain unversioned and tied to the host OS. Document minimum OS builds when known issues are discovered.
- Optional dependency: `PSWindowsUpdate`. Version should be pinned once functionality is implemented.
- No package manifests or module metadata currently exist. Creating a `.psd1` manifest is a prerequisite for versioned releases.

## Security and Compliance Notes
- **Static analysis:** Recommended to run `Invoke-ScriptAnalyzer -Path .` locally and integrate results into CI. No automated findings captured yet.
- **Secret scanning:** Enable repository-level secret scanning and consider adding pre-commit hooks for credential detection.
- **Risk areas:**
  - User-provided input for `defrag` and `Test-Connection` is not sanitized.
  - TEMP directory cleanup can remove files still in use; add warnings and exclusions.
  - Windows Update check is a placeholder and should either be implemented securely or hidden until ready.
- **Simulated audits:** As part of this review, PowerShell-specific tooling such as PSScriptAnalyzer and recommended security scans were documented but not executed in the CI pipeline (output is informational only).

## Audit Findings Summary
- Repository now includes `.gitignore`, documentation, and CI scaffolding to support future modernization.
- Tests remain absent; investment in Pester coverage is a prerequisite for higher maturity.
- Documentation now reflects actual behavior, removing references to unimplemented CLI flags.
- Non-destructive improvements were prioritized; functional code remains unchanged pending future feature work.

## Audit Summary
- Dependencies checked and aligned with current script requirements; no external packages are bundled.
- Deprecated settings replaced per Python.org guidance for 2026: not applicable (PowerShell project).
- Security tools recommended but not executed; instructions are documented above for manual runs.
- CI workflow ready for continuous review with linting and simulated security audit steps.
- No functional changes made to the PowerShell script during this audit.
