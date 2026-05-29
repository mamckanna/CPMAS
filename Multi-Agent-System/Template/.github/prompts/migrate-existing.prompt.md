---
description: "Apply the multi-agent system to an existing misformed project. Orchestrates inventory + reconciliation, producing migration/inventory.md and migration/reconciliation.md. Hands off to standard Plan/Build once the migration plan is locked. Run from Orchestrator."
mode: agent
---

# /migrate-existing

Apply the multi-agent system to a project that was conceived in a different surface (Copilot 365, ChatGPT, Edge Copilot, Claude, Gemini web, etc.) and may contain **misformed artifacts** — content **about** a project (e.g., `.docx`, `.pptx`, prose narratives) where artifacts **of** the project (`.py`, `.sql`, `.bicep`, etc.) are needed.

Spec: `Design/SYSTEM-DESIGN.md` §14.

## Pre-flight

- Read `.agents/state/checkpoint.md` first; refuse if integrity check fails.
- Read `.agents/state/project-profile.md`. Confirm `migrating_from` is set to a non-`none` value. If it is `none`, refuse with "Not a migration; run /kickoff instead." Stop.
- Confirm the user has placed the existing project's contents somewhere in the workspace (under `legacy/`, `incoming/`, or similar). If not, ask the user where the source material lives before proceeding.

## Phase 1 — Inventory (Maintainer)

The Orchestrator routes the user to **Maintainer** mode with this instruction:

> Scan all existing artifacts under `<source path>`. For each file: record path, extension, sniffed content type (does the body match the extension?), and a one-line description of what it appears to contain. Classify by extension and by content-sniff into one of: `source-code`, `iac`, `schema`, `migration`, `test`, `config`, `doc`, `spec`, `data`, `binary-office`, `unknown`.

Output: `migration/inventory.md` with a table of every file. Maintainer appends an artifacts.md entry (`status: inventory-complete`).

## Phase 2 — Reconciliation (Architect + Validator + Database Engineer if data)

The Orchestrator routes the user to **Architect** mode with this instruction:

> Read `migration/inventory.md`. Derive a target **Artifact Manifest** for what this project SHOULD contain, working backward from the existing design intent (even if that intent is captured in misformed artifacts like `.docx`). For every inventory item, mark one of:
>
> - **keep** — already in correct format at the right path; will be re-validated as-is.
> - **convert** — content is correct in intent but format is wrong; produce a corrected artifact in the right format and path (e.g., `.docx` design narrative -> `docs/design.md` + extract spec into `docs/spec.md`; `.docx` "schema description" -> `infra/schema.sql` + `docs/data-model.md`).
> - **replace** — content is wrong or stale; will be regenerated from scratch during Build.
> - **discard** — content is obsolete and has no successor; will be archived (not deleted) under `archive/`.
>
> Validator confirms each `keep` artifact still passes the three-pass gate.

If `project_profile.data_products != none`, the Database Engineer joins Phase 2 to derive the target schema, migrations, and integrity constraints from whatever data definitions exist in the source material.

Output: `migration/reconciliation.md` with a `keep / convert / replace / discard` table, plus a draft `artifact-manifest.md` populated with target entries.

## Phase 3 — Plan (Builder)

Standard Plan phase, but the implementation plan's tasks are mostly **convert** and **replace** rather than greenfield. Each task maps to one or more manifest entries from Phase 2. Plan gate runs `/phase-gate Plan` as normal — manifest must be locked before Build starts.

## Phase 4 — Execute (Builder + Database Engineer + Documenter, gated by Validator)

Standard Build phase. Each artifact passes Validator's three-pass gate, then Reviewer + domain reviewers per the manifest's `reviewed_by`. The only difference from greenfield Build is the higher rate of `supersedes` entries in `artifacts.md`, since converted/replaced artifacts cite their source.

## Phase 5 — Retire (Maintainer)

For every `discard` and every superseded source artifact:

- Move (not delete) the file into `archive/<original-path>/`.
- Append to `artifacts.md` with `Status: archived` and `Supersedes: <A-id>` (or `Supersedes: none` if `discard`).
- Update `migration/reconciliation.md` to mark the row resolved.

Maintainer never deletes; the archive is the traceable record.

## Phase 6 — Audit (Compliance + Security + Privacy + active conditional roles)

Standard Audit phase. The migrated project must meet the same audit gate as a greenfield one:

- Every manifest entry has a `reviewed-pass` artifact.
- No `.docx` / `.pdf` / `.pptx` exists where the manifest says non-binary `type`.
- No orphans on disk outside `archive/` that are not in the manifest.
- All cited Library ids resolve.

## Outputs created by this prompt

- `migration/inventory.md` (Maintainer)
- `migration/reconciliation.md` (Architect, with Validator + DB Engineer input)
- A draft `.agents/state/artifact-manifest.md` populated with target entries (locked at the Plan gate of Phase 3)

## Step-by-step orchestration

When invoked, the Orchestrator:

1. Confirms `project-profile.migrating_from != none`.
2. Writes `.agents/state/plan.md` with a migration-flavored phase queue: References (recurring) -> **Inventory** -> **Reconciliation** -> Plan -> Build -> Operate -> Release -> Audit, with Maintain as perpetual sibling. Inventory and Reconciliation are substituted for Concept/Architecture/Design (the design intent already exists, even if misformed).
3. Writes `.agents/state/handoff.md` routing to Maintainer for Phase 1.
4. Updates `checkpoint.md` (`expected_next_agent: Maintainer`, `turn_token` + 1).
5. Stops. The user switches to Maintainer mode to run Phase 1.

## Hard rules

- Never delete an existing file. `discard` means move to `archive/`.
- Never accept a `keep` for a file whose Validator three-pass fails — that becomes `convert` or `replace`.
- The migration's Build phase still enforces the Artifact Manifest gates. A `.docx` cannot survive into the migrated project where the manifest declares `.py`.
- Migrating projects that span multiple regulated-data classes (`pii + financial`, etc.) MUST keep all relevant conditional roles in the Role Manifest until the Audit gate, even if a class disappears from the live artifacts.
