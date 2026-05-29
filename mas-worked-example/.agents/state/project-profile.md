<!--
project-profile.md — locked at /kickoff. Drives role-manifest.md (derived at Concept gate).
Spec: ../../.github/prompts/kickoff.prompt.md ; ../../../Multi-Agent-System/Design/SYSTEM-DESIGN.md §6.
-->

# Project Profile

```yaml
project_profile:
  name: mas-worked-example
  type: internal-tool
  audience: internal-only
  ai_features: none
  data_products: none
  ui: none
  distribution: internal
  regulated_data: none
  cloud_spend_tier: none
  external_users: no
  multi_team: no
  release_cadence: adhoc
  ms_stack: optional
  migrating_from: none

integrity:
  enabled: true
  cadence: every-step
  durability:
    mode: none
    rationale: ""
  git_fsck: on-validate
  hash_readback: true
  external_backup:
    tool: none
    cadence: on-demand
    repo: ""
  trust_domain:
    independent_readback: true
    remote_git: local-bare
    remote_path_or_url: C:\Users\mmcka\git-bares\mas-worked-example.git
    operator_spot_check: opt-in

locked_at: 2026-05-26T18:00:00Z
locked_by: orchestrator
```

## Notes

- Profile answers chosen to model the smallest realistic shape: a docs-only internal KB, single team, no AI features, no data products. This exercises the *template* end-to-end without code complexity.
- `integrity:` block uses Stage-1 recommended defaults verbatim (per [validation-and-recovery](../../../Multi-Agent-System/Libraries/core/validation-and-recovery.md)).
- `migrating_from: none` ⇒ continue past Step 4 of `/kickoff` to Step 5 (plan), then Step 6 (handoff), then Step 7 (checkpoint).
- Role-manifest derivation (at Concept gate, not now) will yield `conditional_active: []` because every conditional trigger is `none`/`internal`/`no`/`adhoc`/`optional`. The 9 conditional roles all land in `conditional_inactive`.
