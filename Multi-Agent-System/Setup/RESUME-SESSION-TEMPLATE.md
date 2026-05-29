# MAS Resume Session Template
# This script summarizes the current validated state and provides a step-by-step prompt for resuming work.
# It should be updated automatically at each session end for seamless handoff.

# --- MAS Session Resume Protocol ---
# 1. Repo: Multi-Agent-System (current workspace)
# 2. Session resume file: /memories/repo/mas-session-resume-YYYY-MM-DD.md
# 3. Validation: All Copilot PowerShell hooks (sessionStart.ps1, postToolUse.ps1, errorOccurred.ps1) are robust, validated, and pass all POC tests.
# 4. Compaction and data integrity: Confirmed for all hooks and tests.
# 5. Last validated state: See /memories/repo/mas-session-resume-YYYY-MM-DD.md for details and next steps.
#
# To resume:
# - Read /memories/repo/mas-session-resume-YYYY-MM-DD.md for the last validated state and next actions.
# - Optionally, review the latest entries in integrity.log and the verdict table in tests/2026-05-26-stage1-validation-poc.md for additional context.
# - Summarize where we left off and present the next menu options for continuing work (e.g., further enhancements, new features, or extended test coverage).
#
# Usage:
# - At session end, update this template with the current date and state.
# - At session start, follow the steps above for seamless context rehydration.
#
# This protocol can be adapted to match other project standards as needed.
