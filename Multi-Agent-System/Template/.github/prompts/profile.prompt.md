---
description: "Re-open and revise .agents/state/project-profile.md. Triggers a re-derivation and re-locking of role-manifest.md. Run from Orchestrator only."
mode: agent
---

# /profile

Revise the Project Profile. Any change that flips a conditional-role activation requires a re-gate of the Role Manifest.

## Pre-flight

- Read `.agents/state/checkpoint.md`; refuse if integrity check fails.
- Confirm current chat mode is Orchestrator. If not, refuse and route to Orchestrator.
- Read `.agents/state/project-profile.md`. If it does not exist, refuse with "No profile to revise; run /kickoff instead." Stop.
- Read `.agents/state/role-manifest.md` (current state, for diff).

## Step 1 — Show current profile

Print the full current `project-profile.md` (in a code block) so the user sees what they are revising.

## Step 2 — Ask which fields to change

Ask the user, one at a time, for new values. Only revise fields the user explicitly names. For each new value: validate it against the allowed values in `project-profile.template.md`. Reject `unknown` -> something else without an explicit user confirmation.

Track the diff (which fields changed, old -> new).

## Step 3 — Rewrite project-profile.md

Rewrite `.agents/state/project-profile.md` with the new values and:

```
locked_at: <current UTC ISO 8601>
locked_by: orchestrator
```

The prior `locked_at` is **not** preserved here. The historical record lives in `decisions.md` (Step 5 below).

## Step 4 — Re-derive role-manifest.md

Compute the new `conditional_active` set from the updated profile per `Design/SYSTEM-DESIGN.md` §7 activation rules. Compare against the current manifest's `conditional_active`.

| Change type | Action |
|---|---|
| No conditional flips | Re-lock the manifest with the new `locked_at` and updated `derived_from_profile_locked_at`; no other change required. |
| Role newly **activated** | Add to `conditional_active`; remove from `conditional_inactive`. The newly-active role will pick up its responsibilities from the current phase onward. If the project is past the Concept gate and the role would have produced upstream artifacts (e.g., RAI eval suite at Design phase), record the gap as a decision in `decisions.md` (category: `scope-gap`) and surface it at the next human gate. |
| Role newly **deactivated** | Move from `conditional_active` to `conditional_inactive`. Existing review-log entries from that role stay (append-only). The role will refuse new work via its activation-gate pre-flight. |

Rewrite `.agents/state/role-manifest.md` with the new `conditional_active` / `conditional_inactive` lists and:

```
locked_at: <current UTC ISO 8601>
locked_by: orchestrator
derived_from_profile_locked_at: <new project-profile locked_at, matching Step 3>
```

## Step 5 — Append a decision

Append to `.agents/state/decisions.md`:

```
## D-<NNN>: Project Profile revised; Role Manifest re-derived
- Date: YYYY-MM-DDTHH:MM:SSZ
- Phase: <current phase>
- Category: process
- Context: User invoked /profile to revise <N> field(s).
- Decision: Profile fields changed: <field>: <old> -> <new>; ... Role Manifest re-locked. Newly active: <list or "none">. Newly inactive: <list or "none">.
- References: design/system-design (§6, §7)
- Consequences: <one or two bullets>
- turn_token: <int>
```

## Step 6 — Update the checkpoint

Rewrite `.agents/state/checkpoint.md` with `turn_token` + 1 and:

- `last_agent: Orchestrator`
- `last_action: "Profile revised; Role Manifest re-derived (<N> conditional flips)."`
- `expected_next_agent`: whatever was expected before, unless a newly-activated role needs to do upstream catch-up (in that case, route to it next).
- `expected_next_action`: one sentence.
- `last_updated`: current UTC ISO 8601.

## Step 7 — Print summary

```
Profile revised.
Fields changed: <list>
Manifest changes: <N activated, M deactivated>
Newly active roles: <list>
Newly inactive roles: <list>
Outstanding scope-gaps: <list, if any>
turn_token: <int>
```

## Step 8 — Stop

Do not invoke any newly-activated role yourself. The user switches modes when ready.

## Hard rules

- Only Orchestrator may run `/profile`.
- `project-profile.md` and `role-manifest.md` must be re-locked together. They never disagree.
- A deactivation does not erase prior work by that role. Append-only logs are sacred.
- An activation that needs upstream catch-up MUST be recorded as a `scope-gap` decision; silent late activation is not allowed.
- Never change `migrating_from` via `/profile` after initial kickoff. Migration status is one-shot at `/kickoff`; later flips require manual handling and explicit user confirmation in a decision entry.
