# PSToolkit Improvement Roadmap

This roadmap outlines a sequence of incremental, single-day tasks that build from quick wins to more advanced enhancements. Each task includes a brief description, rationale, and post-implementation checks.

## Day 1: Script Formatting and Comment Cleanup
- **Task**: Normalize indentation, remove trailing whitespace, and clarify ambiguous inline comments in `PSToolkit.ps1`.
- **Why it matters**: Establishes a clean baseline that improves readability and reduces noise in future diffs.
- **Verify**: Run `pwsh -NoLogo -File PSToolkit.ps1` in a dry-run mode (menu navigation without executing destructive actions) to ensure no syntax errors were introduced.

## Day 2: Fix Menu Exit Logic Edge Cases
- **Task**: Ensure the menu gracefully handles unexpected input (e.g., blank lines, whitespace, non-numeric characters) and loops until a valid selection or explicit exit.
- **Why it matters**: Prevents user confusion and reduces support calls caused by the script appearing to hang or exit unexpectedly.
- **Verify**: Manually enter invalid inputs followed by a valid selection; confirm the menu continues functioning and logs the input handling.

## Day 3: Centralize Logging Utilities
- **Task**: Refactor repeated logging snippets into a dedicated helper function that handles timestamps and log file creation.
- **Why it matters**: Reduces duplication, simplifies maintenance, and ensures consistent log formatting across actions.
- **Verify**: Execute representative actions from each menu section and confirm the log file contains the expected entries.

## Day 4: Add Configuration File Support
- **Task**: Allow optional configuration via a JSON or PSD1 file for items such as log directory, default ping targets, and disk cleanup exclusions.
- **Why it matters**: Enables teams to adapt the toolkit to their environment without modifying the script directly.
- **Verify**: Run with and without the config file to confirm defaults are preserved and overrides are applied correctly.

## Day 5: Enhanced Error Handling and User Feedback
- **Task**: Wrap key operations (network tests, service restarts, cleanup tasks) with `try { } catch { }` blocks that surface actionable error messages to the user and logs.
- **Why it matters**: Improves resilience and makes troubleshooting faster when external commands fail or require elevated permissions.
- **Verify**: Simulate failures (e.g., stop the print spooler service) and confirm errors are handled gracefully and logged.

## Day 6: Add Structured Logging Option
- **Task**: Introduce an optional switch to emit log entries in JSON lines format alongside the existing text log for easier ingestion by monitoring tools.
- **Why it matters**: Facilitates integration with centralized logging platforms and enables more advanced analysis of support sessions.
- **Verify**: Enable the switch, run a set of actions, and validate that both human-readable and JSON logs are generated with consistent content.

## Day 7: Pluggable Task Registry
- **Task**: Refactor the menu definition into a data-driven structure (e.g., an array of task objects) to simplify adding or reordering toolkit actions.
- **Why it matters**: Lowers the barrier for contributions, makes unit-like testing easier, and sets the stage for future modularization.
- **Verify**: Add a temporary sample task via the registry to ensure it appears in the menu and executes correctly.

## Day 8: Remote Session Integration
- **Task**: Add support for running diagnostics on remote hosts via PowerShell Remoting, with prompts for credentials and connection validation.
- **Why it matters**: Expands the toolkit’s usefulness to multi-machine support scenarios without requiring manual remote logins.
- **Verify**: Connect to a test remote machine (or mocked session) and run a subset of diagnostics, ensuring logs include the remote target context.

## Day 9: Optional Transcript and Artifacts Bundle
- **Task**: Provide a switch that packages the session log, screenshots (if any), and selected reports into a zip archive for hand-off.
- **Why it matters**: Streamlines documentation for escalations and compliance requirements by collecting artifacts in one bundle.
- **Verify**: Execute a session with the switch enabled and confirm the archive contains expected files with correct naming.

## Day 10: Lightweight UI Layer
- **Task**: Implement a simple Windows Presentation Foundation (WPF) or WinForms front-end that invokes the existing PowerShell functions while retaining the CLI for automation.
- **Why it matters**: Offers a more approachable interface for less PowerShell-savvy technicians and improves discoverability of toolkit features.
- **Verify**: Launch the UI, execute a sampling of tasks, and confirm both UI feedback and underlying logs remain consistent.

