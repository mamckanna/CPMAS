---
description: "Route the user to Validator mode for the next artifact in artifact-manifest.md lacking a passing entry in validation-log.md. Idempotent; safe to run anytime in Build phase."
mode: agent
---

# /validate

Find the next artifact awaiting validation and route the user to **Validator** mode.

## Pre-flight

- Read `.agents/state/checkpoint.md`; refuse if integrity check fails (route to `/recover`).
- Read `.agents/state/plan.md`. If current phase is not Build, refuse with "Not in Build phase; nothing to validate." Stop.
- Read `.agents/state/artifact-manifest.md`. Refuse if missing or not locked (route to Architect/Builder for Plan gate). Stop.

## Step 1 — Scan

Walk `.agents/state/artifacts.md` in append order. For each entry with `Status: validation-requested`, look for a matching `V-<NNN>` entry in `.agents/state/validation-log.md` with `Verdict: pass` referencing the same A-id.

The **target** of `/validate` is the first artifact in append order with:

- `Status: validation-requested` in `artifacts.md`, AND
- No `V-<NNN>` with `Verdict: pass` for this A-id in `validation-log.md`.

(Or: an artifact with a prior V- failure that has been re-submitted; `Attempt > 1` in the new V- entry.)

## Step 2 — If a target exists

Write `.agents/state/handoff.md`:

```markdown
# Handoff

## From
<current agent>

## To
Validator

## Phase
Build

## Last completed
- /validate scan identified target artifact

## Outputs / artifacts in scope
- A-<NNN>: <path from manifest>

## Manifest entry
- A-<NNN>: <path>  produced_by=<role>  reviewed_by=[<roles>]
- expected_format.extension: <.ext>
- must_pass: <commands from manifest>

## Validation status
- Attempt: <int> (1 if first, prior failed V-ids if not)

## Recommended next action
Run the three-pass gate on A-<NNN>. Append a V- entry to validation-log.md.
```

Update `.agents/state/checkpoint.md`:

- `last_agent`: agent running `/validate`.
- `last_action`: "Routed to Validator for A-<NNN>."
- `expected_next_agent`: Validator
- `expected_next_action`: "Run three-pass gate on A-<NNN>."
- `turn_token`: previous + 1.
- `last_updated`: current UTC ISO 8601.

Print:

```
Next artifact for validation: A-<NNN>
Path: <path>
Attempt: <int>
Switch to: Validator
turn_token: <int>
```

## Step 3 — If no target exists

Possible reasons:

| Condition | Message |
|---|---|
| All `validation-requested` entries already have a passing V- | "No pending validations. Latest artifact is validated; route to Reviewer or run /handoff." |
| Most recent artifact is `draft` and has not been handed off | "Most recent artifact A-<NNN> is still draft; producing agent must finish self-check before /validate." |
| `artifact-manifest.md` has unbuilt entries past the current task position | "No pending validations; current task is awaiting Builder/producing-agent." |
| No artifacts produced yet | "No artifacts on disk; Build has not started." |

Do not update `checkpoint.md` in this case (no state-writing turn).

## Stop

Do not invoke Validator yourself. The user switches modes and Validator's own pre-flight runs.

## Hard rules

- `/validate` never authors V- entries. Validator does that.
- `/validate` never advances past a `block` verdict from a prior V- attempt without a re-submission first (Builder/producing-agent must produce `Attempt N+1` material).
- `/validate` is read-only on every file except `handoff.md` and `checkpoint.md`.
