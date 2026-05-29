---
applyTo: "**"
description: "Baseline coding and authoring rules for every file in this repo."
---

# General instructions (all files)

## Reading order

Every turn, before generating output:

1. Read `.agents/state/handoff.md` (current state).
2. Read `.agents/state/plan.md` (current phase).
3. Read this file and any other `.instructions.md` whose `applyTo` matches the file you're editing.

## Code quality

- Match existing patterns; do not introduce a new convention without a `decisions.md` entry.
- Keep functions small. Prefer composition over inheritance unless the language idiom says otherwise.
- Public APIs require doc comments. Internal/private code does not.
- Tests live alongside code; new code without tests is a Reviewer blocker except for prototypes flagged as such in `plan.md`.

## Microsoft-first authoring

- Prose follows the Microsoft Writing Style Guide (reference id: `ms-style`).
- Docs that target Microsoft Learn follow the Learn contributor guide (`learn-contrib`).
- Accessibility checks per `ms-a11y` apply to any UI deliverable.

## Tool use

- Prefer MCP servers over raw shell when both exist.
- Never run destructive git commands (`reset --hard`, `push --force`, branch delete) without explicit user approval.
- Long-running commands go in async terminals; one-shot commands in sync.

## Stopping conditions

Stop and ask the user when:

- A required state file is missing or malformed.
- A decision is needed that affects ≥ 2 future phases.
- The next step would violate a non-negotiable in `copilot-instructions.md`.
