# AGENTS.md

> Cross-tool entry point. Read by GitHub Copilot Coding Agent, Claude Code, Cursor, Aider, and any other agent that follows the [agents.md](https://agents.md) convention.

## Project

- **Name:** <project name>
- **Purpose:** <one-line purpose>
- **Primary stack:** <fill in>

## Operating model

This project runs a **multi-agent system** with 14 baseline roles (always-on) and 9 conditional roles (activated by the locked Project Profile). All agents are stateless; state lives on disk under `.agents/state/`.

The system progresses through a **10-phase queue**:

```
References (recurring)
  → Concept → Architecture → Design → Plan → Build → Operate → Release → Audit
  (Maintain runs as a perpetual sibling phase)
```

Human gates: Concept, Plan, Release, Audit.

### Baseline roles (14)

| Role | Owns |
|---|---|
| **Orchestrator** | Plan, dispatch, phase gates. Never writes artifacts. |
| **Architect** | Concept, architecture, design docs. |
| **Builder** | Implementation plan, runtime code artifacts. |
| **Reviewer** | Cross-cutting code / standards review (narrowed — domain reviews route out). |
| **Librarian** | Library citations; resolves missing `id`s, references phase. |
| **Validator** | Three-pass gate on every artifact before Reviewer sees it. |
| **Security Engineer** | Threat model, security review, security artifacts. |
| **Privacy Engineer** | Data flows, privacy review, DSR plumbing. |
| **Compliance Officer** | Regulatory framework matrix, audit gate. |
| **Documenter** | End-user / customer-facing docs. |
| **Database Engineer** | Schemas, migrations, data integrity. Active when `data_products != none`. |
| **SRE** | Runbooks, observability, SLOs, deploy artifacts. |
| **Release Manager** | Release notes, version policy, customer comms. |
| **Maintainer** | Inventory + retirement of legacy or superseded artifacts. |

### Conditional roles (9, activated by Project Profile)

| Role | Activates when |
|---|---|
| **RAI** | `ai_features != none` |
| **Data Steward** | `data_products != none` |
| **Accessibility** | `ui != none` |
| **FinOps** | `cloud_spend_tier in {medium, high}` |
| **Legal** | `distribution in {ms-oss, external-commercial, mixed}` OR `regulated_data != none` |
| **Product** | `audience in {enterprise-customers, consumer}` OR `external_users == yes` |
| **UX Researcher** | `ui != none` AND `audience != internal-only` |
| **QA** | `external_users == yes` OR `release_cadence in {weekly, monthly, quarterly}` |
| **Support** | `external_users == yes` |

A conditional role appears in the chat dropdown but **refuses work** unless listed in `.agents/state/role-manifest.conditional_active`. Activation is one-shot at the Concept gate; revise via `/profile`.

## Shared state

Persistent state under `.agents/state/`:

| File | Kind | Owner |
|---|---|---|
| `checkpoint.md` | overwriting integrity header | every agent at turn end |
| `handoff.md` | overwriting payload | every agent at turn end |
| `plan.md` | overwriting | Orchestrator |
| `project-profile.md` | **locked** declarative | Orchestrator (locked after `/kickoff`) |
| `role-manifest.md` | **locked** declarative | Orchestrator (locked at Concept gate) |
| `artifact-manifest.md` | **locked** declarative | Architect + Builder (locked at Plan gate) |
| `decisions.md` | append-only `D-NNN` log | any agent |
| `artifacts.md` | append-only artifact-status log | producing agent |
| `validation-log.md` | append-only `V-NNN` log | Validator only |
| `review-log.md` | append-only `REV-NNN` + `G-NNN` log | Reviewer / domain reviewers / Orchestrator (gates) |

Every agent **must**:

1. Pre-flight: read `checkpoint.md`; refuse if integrity check fails (route to `/recover`).
2. Read `handoff.md`, `plan.md`, and the manifests relevant to the current phase.
3. Append to the right log (never overwrite append-only files).
4. Write `handoff.md` + `checkpoint.md` at turn end.
5. Never store project-critical state in chat context.

## Slash prompts (8)

- `/kickoff` — interview Project Profile, lock it, write initial plan.
- `/handoff` — write next-agent handoff payload and bump `checkpoint.md`.
- `/phase-gate <phase>` — run the gate for the named (or current) phase; writes `G-NNN`.
- `/migrate-existing` — orchestrate the 6-phase migration workflow for projects with `migrating_from != none`.
- `/validate` — route to Validator for the next artifact pending validation.
- `/profile` — re-open `project-profile.md`; re-derive `role-manifest.md`.
- `/recover` — restore integrity after a `checkpoint.md` mismatch (compaction etc.).
- `/health-check` — read-only integrity scan.

## Reference library

Citations must reference an entry `id` in `Libraries/` (this project's curated library, or a downstream tool's index that extends it). Inventing URLs is forbidden — a missing citation routes to Librarian, no exceptions.

## Artifact Manifest discipline

Every Build artifact is declared in `artifact-manifest.md` **before** Build starts. Each entry carries:

- `path`, `type`, `expected_format` (with `extension` and `parseable_as`).
- `must_NOT_be` (e.g., a runtime feature must not be a `.docx`).
- `produced_by`, `validated_by` (always Validator), `reviewed_by` (Reviewer + domain reviewers per artifact tags).

The Plan gate locks the manifest. The Audit gate compares disk to manifest:

- Every locked entry has an on-disk artifact in the declared format.
- No `.docx` / `.pdf` / `.pptx` where the manifest declares a non-binary `type`.
- No orphan artifacts outside `archive/` that are not in the manifest.

## Validation chain

```
producing agent → Validator (V-NNN) → Reviewer + reviewed_by domain reviewers (REV-NNN) → reviewed-pass
```

No artifact reaches Reviewer without a passing V-id. No artifact reaches `reviewed-pass` without a pass from every role in its `reviewed_by`.

## Migration

If this project's `project-profile.migrating_from` is non-`none`, the standard Concept / Architecture / Design phases are replaced by **Inventory** (Maintainer) → **Reconciliation** (Architect + Validator + DB Engineer). Outputs: `migration/inventory.md`, `migration/reconciliation.md`, draft `artifact-manifest.md`. Retired files are moved to `archive/`, never deleted.

## Microsoft-first

For an MS-owned project (`project-profile.ms_stack in {preferred, required}`), Microsoft sources in `Libraries/microsoft/` take precedence over external sources covering the same topic. Reviewer flags any "MS-compliant" claim that does not cite an MS-authority `id`.

## Host requirement

This template assumes an agents.md-compatible host that supports per-mode chat modes with YAML frontmatter, per-mode tool allow-lists, slash-prompt files, and per-workspace MCP server registration. VS Code Copilot Chat is the reference host.
