<!--
project-profile.md — locked answers to profile questions. Drives role-manifest.md.
Produced by Orchestrator during /kickoff. Locked at Concept gate.
Re-opening requires /profile and a re-gate of role-manifest.md.
Spec: Design/SYSTEM-DESIGN.md §6.
-->

# Project Profile

```yaml
project_profile:
  name: <fill in>
  type: product | internal-tool | library | research | platform
  audience: internal-only | enterprise-customers | consumer | open-source
  ai_features: none | uses-llms | trains-models | inference-only
  data_products: none | reads | produces | trains-on
  ui: none | internal-only | external
  distribution: internal | ms-oss | external-commercial | mixed
  regulated_data: none | pii | phi | pci | financial | classified | multiple
  cloud_spend_tier: none | low | medium | high
  external_users: yes | no
  multi_team: yes | no
  release_cadence: continuous | weekly | monthly | quarterly | adhoc
  ms_stack: none | optional | preferred | required
  migrating_from: none | copilot-365 | chatgpt | claude | gemini | other-surface

integrity:
  enabled: true                                # master switch for checks 7–11 in /health-check
  cadence: every-step | every-turn | on-demand # default every-step
  durability:
    mode: none | per-file-fsync | per-step-volume-sync   # default none
    rationale: ""                              # required if mode != none
  git_fsck: on-validate | on-commit | never    # default on-validate
  hash_readback: true | false                  # default true (Check 8)
  external_backup:
    tool: none | restic | borg | kopia | other
    cadence: daily | weekly | on-demand
    repo: ""                                   # path or URL of backup repo
  trust_domain:
    independent_readback: true | false         # default true
    remote_git: none | local-bare | github | azure-devops | gitlab | other
    remote_path_or_url: ""                     # required if remote_git != none
    operator_spot_check: required | opt-in | never  # default opt-in

locked_at: YYYY-MM-DDTHH:MM:SSZ
locked_by: orchestrator
```

## Field rules

- Every field must have an explicit value. If the user does not know, the Orchestrator records `unknown` and surfaces it at the Concept gate; defaults do not silently apply.
- `migrating_from: <surface>` routes kickoff through `/migrate-existing` before standard phases (see `Design/SYSTEM-DESIGN.md` §14).
- Once locked, this file is rewritten only on explicit `/profile` followed by re-gate.
- The `integrity:` block gates `/health-check` checks 7–11 (persistence, durability, truthfulness). `enabled: false` disables all five; sub-keys gate individually. See [validation-and-recovery](../../../Libraries/core/validation-and-recovery.md) for the model.
- Recommended Stage-1 defaults (set at kickoff unless operator changes them): `cadence: every-step`, `durability.mode: none`, `git_fsck: on-validate`, `hash_readback: true`, `trust_domain.remote_git: local-bare`, `operator_spot_check: opt-in`.

## How this drives the Role Manifest

| Field | Activates |
|---|---|
| `ai_features != none` | RAI Engineer |
| `data_products != none` | Data Steward |
| `ui != none` | Accessibility Engineer |
| `cloud_spend_tier in [medium, high]` | FinOps Engineer |
| `distribution in [ms-oss, external-commercial, mixed]` | Legal / IP |
| `type == product` | Product / PM |
| `ui == external` | UX Researcher |
| `type in [product, platform]` OR `multi_team == yes` | QA Engineer |
| `external_users == yes` | Support / SuccessOps |

The Orchestrator derives `role-manifest.md` from these rules at the Concept gate.
