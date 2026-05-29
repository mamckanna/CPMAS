# Shared State

All persistent state lives in this folder. Each file has a fixed schema so any agent can read and write it without context loss. Specs live in `../../../Design/SYSTEM-DESIGN.md` and `../../../Libraries/core/compaction-and-recovery.md`.

## File catalog

| File | Owner (writer) | Readers | Lifecycle | Schema source |
|---|---|---|---|---|
| `checkpoint.md` | Every agent on every state-writing turn | All (read **first**) | Rewritten each turn | `checkpoint.template.md` |
| `plan.md` | Orchestrator | All | Mutated by Orchestrator | `plan.template.md` |
| `project-profile.md` | Orchestrator (at `/kickoff`) | All | Locked at Concept gate; re-opened only via `/profile` + re-gate | `project-profile.template.md` |
| `role-manifest.md` | Orchestrator (at Concept gate) | All (conditional roles check on every turn) | Locked at gate-pass; re-derived only when `project-profile.md` is re-locked | `role-manifest.template.md` |
| `artifact-manifest.md` | Architect + Builder (at Plan phase) | All | Locked at Plan gate; per-entry re-gate allowed | `artifact-manifest.template.md` |
| `decisions.md` | Architect primary; any role may append | All | Append-only ADR log | `decisions.template.md` |
| `artifacts.md` | Builder primary; other producing roles append | All | Append-only artifact index | `artifacts.template.md` |
| `validation-log.md` | Validator | All (Reviewer cites V-ids) | Append-only three-pass log | `validation-log.template.md` |
| `review-log.md` | Reviewer + Security + Privacy + Compliance + Accessibility + RAI + Legal + FinOps + Documenter + Release Manager (each prefixes its entries) | All | Append-only review log | See per-role chat modes for entry prefixes (REV-, SEC-, PRIV-, COMP-, A11Y-, RAI-, LEG-, FIN-, DOC-, REL-, etc.). |
| `handoff.md` | Whichever agent is finishing a phase or task | Next agent | Single payload; overwritten each handoff | See per-role chat modes |

## Hard rules

1. **Read `checkpoint.md` first**, every turn, before any other file. Integrity check failure (wrong agent, non-monotonic `turn_token`, phase drift) -> refuse and run `/recover`.
2. **Conditional roles** also read `role-manifest.md` early in pre-flight. If the role is not in `conditional_active`, refuse with the standard "Not active per Role Manifest" message and route to Orchestrator.
3. **Read all other relevant files** at turn start; **write back** at turn end. Any turn that writes to any other state file MUST also update `checkpoint.md` (incrementing `turn_token`).
4. **Append-only files**: `decisions.md`, `artifacts.md`, `validation-log.md`, `review-log.md`. Never edit existing entries; supersede with a new one.
5. **Overwritten files**: `handoff.md`, `checkpoint.md`. `project-profile.md`, `role-manifest.md`, `artifact-manifest.md` are rewritten only on explicit re-gate events.
6. **No state lives in chat context.** If it matters, it goes in one of these files.

## Gate ordering

```
Validator pass (validation-log V-id) -> Reviewer pass (review-log REV-id, cites V-id) -> other-role passes (per artifact-manifest.reviewed_by) -> Status: reviewed-pass in artifacts.md
```

Reviewer cannot issue `pass` without a matching Validator `pass`. Other domain reviewers (Security, Privacy, RAI, Accessibility, ...) follow Reviewer in the chain and likewise cite the V-id. Audit pass requires every manifest entry to terminate in `reviewed-pass`.

## Compaction-recovery

This state model is designed to survive context compaction. The mechanism is in `checkpoint.md` (integrity header) plus the `/recover` and `/health-check` prompts. See `../../../Libraries/core/compaction-and-recovery.md` for the full rationale.

## Role-manifest awareness

Conditional roles (RAI, Data Steward, Accessibility, FinOps, Legal, Product, UX Researcher, QA, Support) each have a 6-step pre-flight where step 4 is "Activation gate": read `role-manifest.md`; if not in `conditional_active`, refuse. This is the single mechanism for inactive-role enforcement — there is no other check.
