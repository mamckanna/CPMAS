<!--
checkpoint.md — integrity header for compaction-detection.
This file is rewritten (not appended) every state-writing turn.
Spec: Libraries/core/compaction-and-recovery.md
-->

# Checkpoint

last_agent: Orchestrator
last_action: Initialized checkpoint at kickoff.
expected_next_agent: Architect
expected_next_action: Produce Concept artifact (docs/concept.md).
turn_token: 1
last_updated: YYYY-MM-DDTHH:MM:SSZ

---

## How to use this file

- Every agent reads this file **first** at the start of every turn, before any other action.
- Compare `expected_next_agent` to the current chat mode.
  - If they match, proceed.
  - If they do not match, **refuse the task** and tell the user to switch to `expected_next_agent` or run `/recover`.
- Read `turn_token`. The next state-writing turn must write `turn_token + 1`.
  - If you see a token lower than what you expect, or missing, **refuse** and run `/recover`.
- Compare `plan.md`'s `Current phase` to your in-context understanding. If they disagree, **refuse** and run `/recover`.

## Field rules

| Field | Rule |
|---|---|
| `last_agent` | Exactly one of: `Orchestrator`, `Architect`, `Builder`, `Reviewer`. |
| `last_action` | One sentence, past tense. |
| `expected_next_agent` | Exactly one of the four modes, or `Human` (for human gates). |
| `expected_next_action` | One sentence, imperative. |
| `turn_token` | Positive integer, strictly monotonic across turns. Never reset, never reused. |
| `last_updated` | ISO 8601 UTC, e.g. `2026-05-25T14:32:00Z`. |

## Do not

- Do not append history here. This file is a **single current state**; the durable history lives in `decisions.md`, `artifacts.md`, and `review-log.md`.
- Do not merge this with `handoff.md`. `handoff.md` is the human-readable next-action payload; `checkpoint.md` is the machine-checkable integrity header.
- Do not skip writing this file on a state-writing turn. If you wrote to any other state file this turn, you must update this one.
