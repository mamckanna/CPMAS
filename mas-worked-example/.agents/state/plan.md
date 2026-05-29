# Plan

## Project
- **Name:** mas-worked-example
- **Owner:** mamckanna
- **Audience:** internal-only (template-development dogfood)
- **Primary stack:** Markdown only (docs project)

## Success criteria
- `/kickoff` produces a complete and valid `project-profile.md`, `plan.md`, `handoff.md`, `checkpoint.md`.
- `/health-check` establishes an IL-001 baseline and produces verdict `healthy` with Check 11 live against a local-bare remote.
- `/handoff` rewrites `handoff.md` and increments `turn_token` cleanly.
- `/recover` dry-run classifies the breach correctly given the last IL verdict.

## Non-goals
- Shipping any real product or feature.
- Exercising the conditional roles (RAI, Data Steward, Accessibility, FinOps, Legal, Product, UX-Researcher, QA, Support) — profile keeps them all inactive.
- Going past the Concept gate. We stop at "first handoff to Architect" for this evidence run.

## Phase queue
1. Concept       — status: in-progress
2. Architecture  — status: not-started
3. Design        — status: not-started
4. Plan          — status: not-started
5. Build         — status: not-started
6. Audit         — status: not-started

## Current phase
Concept

## Gate status
pending Role Manifest derivation; Concept artifact (`docs/concept.md`) written by Architect

## Notes
This plan is intentionally minimal — the project's purpose is to *be* the worked example, not to do further work. The Concept phase will produce `docs/concept.md` only if the user continues past kickoff; this evidence run stops at the first `/handoff`.
