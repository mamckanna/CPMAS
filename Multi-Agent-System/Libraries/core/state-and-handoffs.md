---
id: state-and-handoffs
name: File-based state and handoff model
category: core
authority: community
url: https://agents.md
covers: [shared-state, handoff, append-only-log, decision-log, artifact-log, review-log]
agent_use: Cite when authoring, reading, or reviewing files under .agents/state/; when handing off between roles; or when explaining state discipline to a user.
volatility: low
licensing: convention (this library)
last_verified: 2026-05-25
---

# File-based state and handoff model

The convention used by the multi-agent system template to maintain state across turns, agents, and sessions. Inspired by the agents.md ecosystem, BMAD per-role artifacts, and standard ADR practice; consolidated here as the system's normative state model.

## Key requirements

- All persistent state lives in **`.agents/state/`** as plain markdown. No state in chat context.
- The state directory contains exactly these files (no others):
  - `plan.md` — project plan, phase queue, current phase. **Owner: Orchestrator.**
  - `decisions.md` — append-only ADR-style decision log. **All agents may append; none may edit.**
  - `artifacts.md` — append-only artifact log produced during Build. **Owner: Builder.**
  - `review-log.md` — append-only review findings. **Owner: Reviewer.**
  - `handoff.md` — single payload describing the next action and next agent. **Overwritten each handoff.**
  - `checkpoint.md` — integrity header used to detect context drift across turns. **Updated by every agent at turn end.**
- Every agent **reads** the relevant state files at the **start** of every turn, before generating any other output.
- Every agent **writes** state updates at the **end** of every turn, even if the only change is a checkpoint refresh.
- `decisions.md`, `artifacts.md`, `review-log.md` are **append-only**. Never edit an existing entry. Supersede with a new entry and link.
- `handoff.md` is **overwritten** each handoff. Old handoff content is not preserved — the durable record lives in the append-only logs.
- Every entry in the append-only logs uses a stable id prefix: `D-NNN` (decisions), `A-NNN` (artifacts), `R-NNN` (review), `G-NNN` (gate). Ids are monotonic per file.
- Citations in entries use the reference-library `id` form (`ref: <id>` or `refs: <id>, <id>`), never raw URLs.
- An agent that cannot read or parse a required state file must **stop and ask** rather than guess. State corruption is a higher-priority concern than task completion.

## Common misuses

- Storing project-critical state in chat context. Chat is ephemeral; compaction erases it. Anything that matters goes to disk.
- Editing past `decisions.md` entries to "fix" them. That destroys the audit trail. Supersede instead.
- Letting `handoff.md` accumulate history. It is overwritten each handoff by design; history lives in the append-only logs.
- Skipping state reads "for speed." The cost of re-reading is small; the cost of acting on stale assumptions after a compaction is large.

## Notes

- This convention is **project-local** and not part of any external standard. It is the system's normative model and is enforced by the chat modes' system prompts.
- The append-only discipline is the single most important property: it makes the state files survive compaction, model swaps, and human takeover.
