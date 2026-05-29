# Concept — mas-worked-example

## Problem
Provide a small, real-world worked example that exercises the Multi-Agent-System template's `/kickoff`, `/health-check`, `/handoff`, and `/recover` flows end-to-end. The example itself is a docs-only internal knowledge base — it does not ship software — and serves as Stage 1 acceptance evidence for the template repo.

## Users
- Template maintainers verifying the kickoff toolchain on a clean downstream consumer.
- Future downstream operators reading this as a reference of what a freshly-kicked-off project looks like before any real Concept work has been performed.

## Approach
1. Lock `project-profile.md` at kickoff (already done; integrity defaults applied: every-step cadence, durability.mode=none, hash_readback=true, local-bare remote).
2. Use a docs-only repo shape: README + `.agents/state/` + Template scaffolding (chatmodes, prompts, instructions).
3. Demonstrate four prompt-driven flows in sequence: `/kickoff` → `/health-check` (IL-001) → `/handoff` (turn_token cycle) → `/recover` (dry-run classification).
4. Record evidence in `tests/2026-05-26-kickoff-evidence.md`.

## Out of scope
- Any real product feature work (no Build phase, no artifacts beyond this concept doc).
- Stage 2 (durable receipts) — that's exercised in the parent template repo separately.

## Success criteria
- IL-001 verdict=healthy.
- `/handoff` increments turn_token monotonically and updates `checkpoint.md`.
- `/recover` dry-run correctly classifies the last IL as healthy and routes to the context-breach path.
- Evidence doc commits cleanly; remote `ls-remote` matches HEAD after final push.

## Open questions
- None at this scope. The example is intentionally minimal.
