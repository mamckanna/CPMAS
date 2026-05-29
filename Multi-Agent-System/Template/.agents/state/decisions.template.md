# Decisions (append-only)

> ADR-style. Append new entries at the bottom. Never edit existing entries — supersede with a new one and link.

## D-000: Adopt multi-agent system as default
- Date: <fill in on first use>
- Phase: Concept
- Context: Single-agent workflows lose context across sessions and cannot enforce cross-cutting concerns reliably. See Concept Report 01 §1 (Question A).
- Decision: Use the four-mode multi-agent template (Orchestrator / Architect / Builder / Reviewer) as the default for this project.
- Alternatives considered: Single-agent free-form chat; ad-hoc instruction file only; full Report 01 §6 tier model.
- References: Report 01 §1, §6; `references/01_*.references.md`.
- Consequences: All work follows phase-gated flow; state lives in `.agents/state/`; sub-agents are stateless prompts.

<!-- Add new decisions below this line as D-001, D-002, ... -->
