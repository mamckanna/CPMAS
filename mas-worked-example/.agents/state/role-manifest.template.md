<!--
role-manifest.md — which conditional roles are active for this project.
Produced by Orchestrator at the Concept gate, derived from project-profile.md.
Locked at gate-pass. Activating an inactive role later requires re-gate.
Spec: Design/SYSTEM-DESIGN.md §7.
-->

# Role Manifest

```yaml
role_manifest:
  baseline:
    - orchestrator
    - architect
    - builder
    - validator
    - database-engineer
    - reviewer
    - security-engineer
    - privacy-engineer
    - compliance-officer
    - sre
    - release-manager
    - librarian
    - documenter
    - maintainer

  conditional_active: []
    # populate from project-profile.md per Design/SYSTEM-DESIGN.md §7:
    #   rai            -- if project_profile.ai_features != none
    #   data-steward   -- if project_profile.data_products != none
    #   accessibility  -- if project_profile.ui != none
    #   finops         -- if project_profile.cloud_spend_tier in [medium, high]
    #   legal          -- if project_profile.distribution in [ms-oss, external-commercial, mixed]
    #   product        -- if project_profile.type == product
    #   ux-researcher  -- if project_profile.ui == external
    #   qa             -- if project_profile.type in [product, platform] OR multi_team
    #   support        -- if project_profile.external_users == yes

  conditional_inactive: []
    # everything in {rai, data-steward, accessibility, finops, legal, product,
    # ux-researcher, qa, support} that is NOT in conditional_active.

  locked_at: YYYY-MM-DDTHH:MM:SSZ
  locked_by: orchestrator
  derived_from_profile_locked_at: YYYY-MM-DDTHH:MM:SSZ
```

## Field rules

- `conditional_active` + `conditional_inactive` together MUST list all 9 conditional roles. No omissions, no duplicates.
- A conditional role appears in exactly one of the two lists.
- `locked_at` is the time this manifest was produced.
- `derived_from_profile_locked_at` MUST match `project-profile.md`'s `locked_at`. If `project-profile.md` is re-locked (via `/profile`), this manifest must be re-derived and re-locked.

## How inactive roles behave

Each conditional chat-mode file checks this manifest in its mandatory pre-flight (step 4, "Activation gate"). If its role-id is not in `conditional_active`, it refuses with:

> Not active per Role Manifest. Re-activation requires re-gate at Concept.

It then routes back to the Orchestrator.

## Decision trail

When the Orchestrator locks this manifest, it appends a process decision to `decisions.md`:

```
## D-<NNN>: Role Manifest locked
- Date: YYYY-MM-DD
- Phase: Concept
- Category: process
- Context: Concept gate reached; manifest derived from project-profile locked_at <ts>.
- Decision: <count> conditional roles active: <list>.
- References: design/system-design (§7)
- Consequences: inactive roles refuse work; re-activation requires re-gate.
- turn_token: <int>
```
