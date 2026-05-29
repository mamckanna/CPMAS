# Prior Art: GitHub Spec-Kit

## What it is

Spec-Kit is GitHub's open-source toolkit for **spec-driven development** with AI agents. The premise: instead of prompting an agent to "write the feature," you co-author a specification first, then the agent generates a plan, tasks, and code from the spec. Repository: [github.com/github/spec-kit](https://github.com/github/spec-kit).

## Why it matters

Spec-Kit is the cleanest articulation of "specification as the durable artifact, code as the disposable output." That inversion is the heart of why multi-agent systems need a structured kickoff: the agent's reliability is bounded by the quality of the upstream spec, not the cleverness of the implementation prompt.

## Surface (loosely)

- A `/specify` step that produces a feature specification document.
- A `/plan` step that turns the spec into a technical plan.
- A `/tasks` step that decomposes the plan into actionable tasks.
- An execution step that runs each task.
- Templates per phase (`spec-template.md`, `plan-template.md`, `tasks-template.md`).

## What we adopted

- **Spec-first kickoff.** The `/kickoff` prompt in our template interviews the user and writes `plan.md` before any code is produced. Same idea, narrower scope (we produce a project plan, not a per-feature spec).
- **Templated phase artifacts.** Each of our phases has a canonical output (`docs/concept.md`, `docs/architecture.md`, `docs/design.md`, `docs/implementation-plan.md`). Spec-Kit calls them spec/plan/tasks; we call them concept/architecture/design/plan. Same skeleton.
- **Decompose before doing.** The Plan phase exists specifically to force task breakdown before Builder starts writing code.

## What we did not adopt

- Spec-Kit's per-feature granularity. Our template targets project-level orchestration; per-feature work happens *inside* the Build phase as Builder tasks.
- Spec-Kit's specific command names. We use `/kickoff`, `/handoff`, `/phase-gate` to fit VS Code's slash-command surface.

## Cautions

- Spec-Kit is GitHub-published but still community-maturity. Treat the toolkit as inspiration, not a versioned dependency.
- "Spec-driven" is a discipline, not a guarantee. A bad spec still produces bad code, just earlier.
