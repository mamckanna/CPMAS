# Setup Checklist

Run through this once after installing. If any item fails, see `SETUP.md` §11 Troubleshooting.

## Files in place

- [ ] `AGENTS.md` exists at the project root with name / purpose / stack filled in.
- [ ] `.github/copilot-instructions.md` reflects the project's stack and non-negotiables.
- [ ] `.github/instructions/general.instructions.md` and `security.instructions.md` exist.
- [ ] `.github/chatmodes/` contains all **23** chat modes (14 baseline + 9 conditional):
  - Baseline: `orchestrator`, `architect`, `builder`, `reviewer`, `librarian`, `validator`, `security-engineer`, `privacy-engineer`, `compliance-officer`, `documenter`, `database-engineer`, `sre`, `release-manager`, `maintainer`.
  - Conditional: `rai`, `data-steward`, `accessibility`, `finops`, `legal`, `product`, `ux-researcher`, `qa`, `support`.
- [ ] `.github/prompts/` contains all **8** slash prompts: `kickoff`, `handoff`, `phase-gate`, `migrate-existing`, `validate`, `profile`, `recover`, `health-check`.
- [ ] `.vscode/mcp.json` exists and `MCP: List Servers` shows them running.
- [ ] `.agents/state/` contains the 9 templates (`checkpoint`, `plan`, `decisions`, `artifacts`, `validation-log`, `project-profile`, `role-manifest`, `artifact-manifest`, plus `README.md`).
- [ ] `.agents/state/plan.md`, `decisions.md`, `artifacts.md`, `validation-log.md`, `checkpoint.md` exist (copied from templates).
- [ ] `.agents/state/handoff.md` and `review-log.md` exist (empty files).
- [ ] `.agents/state/project-profile.md`, `role-manifest.md`, `artifact-manifest.md` do **NOT** exist yet (they are produced under controlled conditions during the run).

## Surface verification

- [ ] In Copilot Chat, all 23 chat modes appear in the dropdown.
- [ ] At least one conditional mode (e.g., `accessibility`) reports "not in active manifest; refusing work" when invoked — confirms activation-gate is functioning.

## First-run smoke

- [ ] `/kickoff` in Orchestrator mode begins the 14-field Project Profile interview.
- [ ] After the interview, `project-profile.md` exists, is fully populated, has `locked_at` set, and is referenced by `checkpoint.md`.
- [ ] If `migrating_from != none`: Orchestrator stopped and recommended `/migrate-existing`.
- [ ] Otherwise: `plan.md` shows the 10-phase queue with **Concept** as the current phase.
- [ ] `handoff.md` recommends switching to **Architect**.
- [ ] `checkpoint.md` has `turn_token: 1` and `expected_next_agent: Architect`.

## Concept-gate smoke (after Architect produces `docs/concept.md`)

- [ ] `/phase-gate Concept` in Orchestrator mode passes.
- [ ] On pass, `role-manifest.md` is written, is locked (`locked_at` set, `derived_from_profile_locked_at` matches the Profile), and lists the correct `conditional_active` set for the Profile.
- [ ] A `D-NNN` decision entry "Role Manifest locked" appears in `decisions.md`.
- [ ] Plan pointer advanced to **Architecture**.

## Integrity smoke

- [ ] `/health-check` from Orchestrator reports green (`turn_token` consistent, no orphan files, all locked manifests valid).
- [ ] Manually edit `checkpoint.md` to a bogus `turn_token`, then run `/health-check` → it reports red and recommends `/recover`.
- [ ] Run `/recover` → integrity restored. Revert the manual edit.

## Migration smoke (only if `migrating_from != none`)

- [ ] `/migrate-existing` rewrote `plan.md` with the migration-flavored phase queue (Inventory → Reconciliation → Plan → Build → Operate → Release → Audit).
- [ ] `handoff.md` routes to **Maintainer** for Phase 1 Inventory.
- [ ] After Inventory, `migration/inventory.md` exists with every legacy file classified.
- [ ] After Reconciliation, `migration/reconciliation.md` exists with `keep` / `convert` / `replace` / `discard` per item, and a draft `artifact-manifest.md` is populated.
