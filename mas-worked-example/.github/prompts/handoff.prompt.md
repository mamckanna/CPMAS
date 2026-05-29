---
description: "Write a clean handoff payload to .agents/state/handoff.md and update checkpoint.md. Usable from any chat mode."
mode: agent
---

# /handoff

Rewrite `.agents/state/handoff.md` from current state, then update `.agents/state/checkpoint.md`.

## Step 1 — Gather

Read:

- `.agents/state/checkpoint.md` (current integrity header)
- `.agents/state/plan.md` (current phase, gate status)
- `.agents/state/role-manifest.md` (if exists — determines which conditional roles are eligible as next-agent)
- `.agents/state/artifact-manifest.md` (if exists — for per-artifact `produced_by` / `reviewed_by` routing during Build)
- `.agents/state/decisions.md` (last 3 entries)
- `.agents/state/artifacts.md` (last 5 entries)
- `.agents/state/validation-log.md` (last 5 entries)
- `.agents/state/review-log.md` (any open blockers)

## Step 2 — Determine next agent

Apply rules **in order**; the first match wins.

| Condition | Next agent |
|---|---|
| Any open BLOCKER in `review-log.md` or `validation-log.md` | The artifact's `produced_by` role from `artifact-manifest.md` (Builder, Architect, Database Engineer, Documenter, ...) |
| A cited Library `id` does not resolve to an entry | Librarian (References phase, recurring) |
| Current phase is References (re-entry) | Librarian |
| Current phase is Concept and no `docs/concept.md` yet | Architect |
| Concept artifact done but `role-manifest.md` not yet produced | Orchestrator (derive Role Manifest at Concept gate) |
| Current phase is Architecture or Design | Architect (+ Database Engineer if `data_products != none`) |
| Current phase is Plan and `artifact-manifest.md` not locked | Architect + Builder |
| Current phase is Build and an artifact has `Status: validation-requested` | Validator |
| Current phase is Build and an artifact has `Status: review-requested` | next unfulfilled role in that entry's `reviewed_by` list (Reviewer first, then Security / Privacy / RAI / Accessibility per artifact tags) |
| Current phase is Build and the active artifact is `reviewed-pass` | Orchestrator (dispatch next manifest entry) |
| Current phase is Operate | SRE |
| Current phase is Release | Release Manager (+ Documenter, Support if `external_users`) |
| Current phase is Audit | Compliance Officer (+ Security Engineer, Privacy Engineer, plus active conditional roles per Manifest) |
| Phase just completed and human gate pending | Human (Orchestrator stays in mode) |

A conditional role appears as `next agent` **only** if it is in `role-manifest.conditional_active`. If the rule selects an inactive conditional role, fall through to the next rule.

## Step 3 — Overwrite `handoff.md`

Use this exact template:

```markdown
# Handoff

## From
<current agent>

## To
<next agent>

## Phase
<current phase>

## Last completed
- <bullets>

## Outputs / artifacts in scope
- <paths>

## Manifest entry (if Build phase)
- A-<NNN>: <path>  produced_by=<role>  reviewed_by=[<roles>]

## Decisions referenced
- <D-IDs>

## Validation status (if Build phase)
- <V-IDs and verdicts>

## Open blockers
- <list, or "none">

## Recommended next action
<one sentence>
```

## Step 4 — Update the checkpoint

Rewrite `.agents/state/checkpoint.md`:

- `last_agent`: the agent currently running `/handoff`.
- `last_action`: one sentence summarizing what was just completed.
- `expected_next_agent`: the next agent determined in Step 2.
- `expected_next_action`: one sentence imperative.
- `turn_token`: previous value + 1.
- `last_updated`: current UTC ISO 8601.

## Step 5 — Print the payload + checkpoint

So the user can see both the handoff and the new `turn_token` / `expected_next_agent` without opening the files.

## Step 6 — Stop

Do not invoke the next agent. The user switches chat modes.

## Hard rules

- Routing to a conditional role requires it to be in `role-manifest.conditional_active`. Inactive conditional roles never appear as next-agent.
- A blocker on an artifact routes to its `produced_by` from `artifact-manifest.md`, not to a generic "Builder" default.
- Missing Library citation -> Librarian, always. Do not let the originating agent proceed.
