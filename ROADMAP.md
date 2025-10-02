# PSToolkit Improvement Proposals

This document outlines a set of incremental improvements for PSToolkit, grouped from quick wins to more advanced enhancements. Each proposal includes a brief description, rationale, and post-implementation checks. Teams can pursue them individually or sequence them to match priorities and available effort.

### Quick Wins

- **Script Formatting and Comment Cleanup**
  - *Why it matters*: Establishes a clean baseline that improves readability and reduces noise in future diffs.
  - *Verify*: Run `pwsh -NoLogo -File PSToolkit.ps1` in a dry-run mode (menu navigation without executing destructive actions) to ensure no syntax errors were introduced.

- **Fix Menu Exit Logic Edge Cases**
  - *Why it matters*: Prevents user confusion and reduces support calls caused by the script appearing to hang or exit unexpectedly.
  - *Verify*: Manually enter invalid inputs followed by a valid selection; confirm the menu continues functioning and logs the input handling.

- **Centralize Logging Utilities**
  - *Why it matters*: Reduces duplication, simplifies maintenance, and ensures consistent log formatting across actions.
  - *Verify*: Execute representative actions from each menu section and confirm the log file contains the expected entries.

### Moderate Improvements

- **Add Configuration File Support**
  - *Why it matters*: Enables teams to adapt the toolkit to their environment without modifying the script directly.
  - *Verify*: Run with and without the config file to confirm defaults are preserved and overrides are applied correctly.

- **Enhanced Error Handling and User Feedback**
  - *Why it matters*: Improves resilience and makes troubleshooting faster when external commands fail or require elevated permissions.
  - *Verify*: Simulate failures (e.g., stop the print spooler service) and confirm errors are handled gracefully and logged.

- **Add Structured Logging Option**
  - *Why it matters*: Facilitates integration with centralized logging platforms and enables more advanced analysis of support sessions.
  - *Verify*: Enable the switch, run a set of actions, and validate that both human-readable and JSON logs are generated with consistent content.

### Ambitious Enhancements

- **Pluggable Task Registry**
  - *Why it matters*: Lowers the barrier for contributions, makes unit-like testing easier, and sets the stage for future modularization.
  - *Verify*: Add a temporary sample task via the registry to ensure it appears in the menu and executes correctly.

- **Remote Session Integration**
  - *Why it matters*: Expands the toolkit’s usefulness to multi-machine support scenarios without requiring manual remote logins.
  - *Verify*: Connect to a test remote machine (or mocked session) and run a subset of diagnostics, ensuring logs include the remote target context.

- **Optional Transcript and Artifacts Bundle**
  - *Why it matters*: Streamlines documentation for escalations and compliance requirements by collecting artifacts in one bundle.
  - *Verify*: Execute a session with the switch enabled and confirm the archive contains expected files with correct naming.

- **Lightweight UI Layer**
  - *Why it matters*: Offers a more approachable interface for less PowerShell-savvy technicians and improves discoverability of toolkit features.
  - *Verify*: Launch the UI, execute a sampling of tasks, and confirm both UI feedback and underlying logs remain consistent.
