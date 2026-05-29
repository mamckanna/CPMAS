---
id: compaction-and-recovery
name: Context compaction detection and recovery
category: core
authority: community
url: https://www.anthropic.com/news/context-management
covers: [compaction, context-window, session-recovery, drift-detection, checkpoint-integrity]
agent_use: Cite when designing or reviewing recovery prompts, when an agent suspects a compaction has occurred, or when validating that state-on-disk and in-context state are consistent.
volatility: medium
licensing: convention (this library)
last_verified: 2026-05-25
---

# Context compaction detection and recovery

A normative model for detecting context compaction (when a host or model summarizes prior turns and drops detail) and recovering cleanly from it. Combines the agents.md / state-and-handoffs convention with explicit integrity checks.

## Why this entry exists

Every conversational agent host (VS Code Copilot, Claude Code, Cursor, ChatGPT) compacts context when it grows large. Compaction is a normal and necessary operation, but it has a known failure mode: the post-compaction context is a *summary*, not the original turns. An agent that proceeds without realizing compaction has happened will operate on degraded information.

This entry defines the integrity checks and recovery prompt that make the multi-agent system compaction-resilient.

## Key requirements

- Every state-writing turn updates `.agents/state/checkpoint.md` with these fields:
  - `last_agent:` the chat mode that just acted
  - `last_action:` one-sentence summary of what was done
  - `expected_next_agent:` the chat mode that should act next
  - `expected_next_action:` one-sentence summary of the next action
  - `turn_token:` a monotonically increasing integer (incremented every turn)
  - `last_updated:` ISO date-time
- Every agent, at the **start** of every turn, reads `checkpoint.md` **before** any other action.
- If `expected_next_agent` does not match the current chat mode, the agent **refuses** the task and routes the user to `/recover` or to the expected chat mode.
- If `turn_token` is missing or non-monotonic (e.g., backward), the agent **refuses** and routes to `/recover`.
- If the agent's in-context understanding of the current phase disagrees with `plan.md`'s `Current phase`, the agent **refuses** and routes to `/recover`.
- `/recover` is the canonical recovery prompt. It rebuilds working context from state files alone and ignores chat history.
- `/health-check` is the canonical drift-detection prompt. It validates:
  - Phase consistency across `plan.md` and `checkpoint.md`.
  - Every artifact in `artifacts.md` exists on disk.
  - No open blocker in `review-log.md` lacks a follow-up in `handoff.md`.
  - No agent edited files outside its tool allow-list since the last checkpoint (best-effort via git diff).
- Recovery is **not** the same as resumption. Resumption reads `handoff.md` and continues. Recovery rebuilds context from all state files because integrity was already breached.

## Common misuses

- Treating compaction as something that "shouldn't happen." It always happens eventually; design for it.
- Putting recovery logic inside a chat mode's system prompt only. The user needs an explicit `/recover` prompt they can run; otherwise recovery is at the agent's discretion (and the agent is the entity that already lost context).
- Letting the checkpoint live inside `handoff.md`. They serve different purposes — `handoff.md` is the next-action payload (human-readable), `checkpoint.md` is the integrity header (machine-checkable). Keep them separate.
- Skipping `turn_token`. Without a monotonic counter, the integrity check is unreliable — text can look right but be stale.

## Notes

- This entry is the practical lesson from sessions where compaction occurred without error correction. The mechanism is simple but it must be **mandatory** to be useful — soft "read state at start" instructions are not enough.
- The integrity check is best-effort: a sufficiently large compaction can lose the chat-mode-switch event itself. In that case the agent should detect mode mismatch via `expected_next_agent` and route to `/recover`.
