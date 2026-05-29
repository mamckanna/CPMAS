# mas-worked-example

A downstream worked example for the [Multi-Agent-System](../Multi-Agent-System) template.

**Shape:** docs-only internal knowledge-base project. Single-team, no UI, no cloud spend, no regulated data. The point is to exercise the template's `/kickoff` → `/health-check` → `/handoff` → `/recover` loop end-to-end against a real (if tiny) project — *not* to ship real software.

**Status:** kickoff complete; Stage-1 integrity baseline established. See `tests/2026-05-26-kickoff-evidence.md` and `.agents/state/integrity-log.md`.

## Layout

| Path | Purpose |
|---|---|
| `.agents/state/` | Shared agent state (checkpoint, plan, profile, handoff, integrity log, …). |
| `.github/chatmodes/` | VS Code chat modes (Orchestrator, Architect, Builder, Reviewer, …). |
| `.github/prompts/` | Slash commands (`/kickoff`, `/health-check`, `/handoff`, `/recover`, …). |
| `AGENTS.md` | Top-level agent entry point. |
| `tests/` | POC evidence captured from this worked example. |

## Reproduction

See the parent template's [tests/2026-05-26-stage1-validation-poc.md](../Multi-Agent-System/tests/2026-05-26-stage1-validation-poc.md) §6 for the canonical health-check scan recipe.
