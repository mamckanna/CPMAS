---
description: "Initialize or resume the multi-agent system for this project. Run from Orchestrator mode. Produces project-profile.md, plan.md, role-manifest.md (at Concept gate), checkpoint.md."
mode: agent
---

# /kickoff

Initialize (or resume) the multi-agent system for this project.

## Step 1 — Read existing state

Read these files. Do not summarize them — just note what is present and what is missing.

- `.agents/state/checkpoint.md`
- `.agents/state/plan.md`
- `.agents/state/handoff.md`
- `.agents/state/project-profile.md`
- `.agents/state/role-manifest.md`
- `.agents/state/decisions.md`

## Step 2 — Decide branch

| State | Branch |
|---|---|
| `checkpoint.md` exists and `plan.md` has an active phase | **Resume**. Go to Step 7. |
| `project-profile.md` exists and is locked but `plan.md` is empty | **Profile-only**. Go to Step 5. |
| Nothing or only templates present | **New project**. Go to Step 3. |

## Step 3 — Project Profile interview (new project only)

Ask the user, one question per turn, the questions defined in `project-profile.template.md`. Do not invent answers. If the user does not know a field, record it as `unknown` (do not silently default).

Minimum prompts:

1. One sentence: what is this project?
2. `type`: product | internal-tool | library | research | platform
3. `audience`: internal-only | enterprise-customers | consumer | open-source
4. `ai_features`: none | uses-llms | trains-models | inference-only
5. `data_products`: none | reads | produces | trains-on
6. `ui`: none | internal-only | external
7. `distribution`: internal | ms-oss | external-commercial | mixed
8. `regulated_data`: none | pii | phi | pci | financial | classified | multiple
9. `cloud_spend_tier`: none | low | medium | high
10. `external_users`: yes | no
11. `multi_team`: yes | no
12. `release_cadence`: continuous | weekly | monthly | quarterly | adhoc
13. `ms_stack`: none | optional | preferred | required
14. `migrating_from`: none | copilot-365 | chatgpt | claude | gemini | other-surface

## Step 3.5 — Integrity & durability interview (new project only)

Ask the operator the questions below. Present recommended defaults; record `unknown` if the operator declines to choose (do **not** silently default). These answers populate the `integrity:` block of `project-profile.md` and gate `/health-check` checks 7–11. Cite `Libraries/core/validation-and-recovery.md` for the rationale.

15. `integrity.enabled` (default **true**): turn on persistence/durability/truthfulness checks at all?
16. `integrity.cadence` (default **every-step**): when does `/health-check` run? `every-step` = once per state-writing turn; `every-turn` = also on read-only turns; `on-demand` = only when invoked.
17. `integrity.git_fsck` (default **on-validate**): run `git fsck --full --strict` when? `on-validate` = each `/health-check` invocation; `on-commit` = before each git commit; `never` = opt-out.
18. `integrity.hash_readback` (default **true**): independent SHA-256 readback of state files + artifacts on each `/health-check`?
19. `integrity.durability.mode` (default **none**): how do we force bytes to physical media? `none` = trust the OS page cache; `per-file-fsync` = call FlushFileBuffers / fsync after each write; `per-step-volume-sync` = `sync` the volume at end of each state-writing turn. If not `none`, also capture `rationale`.
20. `integrity.external_backup.tool` (default **none**): out-of-band backup tool? `none | restic | borg | kopia | other`. If not `none`, also capture `cadence` and `repo` (path or URL).
21. `integrity.trust_domain.remote_git` (default **local-bare**): independent trust domain for the working tree? `none` = no remote; `local-bare` = sibling `<project>.git/` bare repo (recommended Stage-1 minimum); else a hosted remote. If not `none`, capture `remote_path_or_url`.
22. `integrity.trust_domain.operator_spot_check` (default **opt-in**): operator pulls a random file and diffs it against the agent's claimed last write — `required` (gated), `opt-in` (suggested), `never`.

Pre-flight before the interview: confirm `git --version` resolves and a `.git/` exists at repo root. If not, surface the missing-git remediation steps from `Libraries/core/validation-and-recovery.md` §Bootstrap and offer to run `git init` plus an initial commit before continuing. Do not silently skip — record `integrity.enabled: false` if the operator declines git.

## Step 4 — Write project-profile.md

Copy `.agents/state/project-profile.template.md` to `.agents/state/project-profile.md`, fill in every field from the interview, and set:

```
locked_at: <current UTC ISO 8601>
locked_by: orchestrator
```

If `project_profile.migrating_from != none`: do **not** continue to Step 5. Instead, write a handoff routing the user to `/migrate-existing` and stop. The migration workflow (`Design/SYSTEM-DESIGN.md` §14) takes precedence.

## Step 5 — Write the initial plan

Populate `.agents/state/plan.md` from `plan.template.md` with:

- Project header (filled in from Step 3).
- 10-phase queue: References (recurring) -> Concept -> Architecture -> Design -> Plan -> Build -> Operate -> Release -> Audit, plus Maintain (perpetual sibling).
- Current phase: **Concept**.
- Gate status: **pending Concept artifact + Role Manifest derivation**.

## Step 6 — First handoff

Write `.agents/state/handoff.md` recommending the user switch to **Architect** mode to produce `docs/concept.md`. The Role Manifest will be derived by Orchestrator at the Concept gate (after Architect's concept artifact passes review).

## Step 7 — Initialize the checkpoint

If `.agents/state/checkpoint.md` does not exist, copy `.agents/state/checkpoint.template.md` to `.agents/state/checkpoint.md` and fill in:

```
last_agent: Orchestrator
last_action: Initialized project at kickoff; project-profile.md locked.
expected_next_agent: Architect
expected_next_action: Produce docs/concept.md.
turn_token: 1
last_updated: <current UTC ISO 8601>
```

If `checkpoint.md` already exists, this is a **resume**: do not overwrite. Read it, validate integrity, and report the current state to the user.

## Step 8 — Stop

Print the standard Orchestrator end-of-turn block and wait. Do not invoke the Architect yourself; the user switches modes.

## Concept-gate follow-up (later turn, after Architect produces docs/concept.md)

When the user returns to Orchestrator with `docs/concept.md` ready for the Concept gate:

1. Run `/phase-gate Concept`.
2. On pass: derive `.agents/state/role-manifest.md` from `project-profile.md` per the activation rules in `Design/SYSTEM-DESIGN.md` §7. Lock it. Append a process decision to `decisions.md` (`category: process`, title `Role Manifest locked`).
3. Advance the phase pointer to Architecture.

## Hard rules

- Do not invent profile values. `unknown` is a valid value; silent defaults are not.
- Do not produce `role-manifest.md` before Concept-gate pass; the manifest depends on the locked profile and the gate decision.
- Do not advance past the Concept gate without `role-manifest.md` on disk.
- Do not skip Step 4's `migrating_from` check; routing to `/migrate-existing` is mandatory if set.
