<!--
artifact-manifest.md — per-artifact declaration of type, path, format, and validation rule.
Co-produced by Architect + Builder at the Plan phase. Locked at Plan gate-pass.
Adding entries after lock requires re-gate of the affected entry.
Spec: Design/SYSTEM-DESIGN.md §8.
-->

# Artifact Manifest

```yaml
manifest:
  locked_at: YYYY-MM-DDTHH:MM:SSZ
  locked_by: orchestrator
  derived_from_plan_at: YYYY-MM-DDTHH:MM:SSZ

  entries:
    - id: A-001
      purpose: "<one sentence of why this artifact exists>"
      path: <relative path from repo root>
      type: source-code | iac | schema | migration | test | config | doc | spec | data | binary
      language: <e.g., python, typescript, csharp, bicep, terraform, sql, powershell, go, markdown> # null for non-code types
      expected_format:
        extension: ".<ext>"
        must_parse_as: <parser id, e.g., python-3.11, typescript-5, bicep, postgres-15, commonmark>
        must_pass:
          - command: "<toolchain command, e.g., 'ruff check <path>'>"
          - command: "<toolchain command, e.g., 'mypy <path>'>"
          - command: "<test command, e.g., 'pytest tests/<this>'>"
      must_NOT_be:
        - ".docx"
        - ".pdf"
        - ".pptx"
        - "prose"
        - "design document"
        - "wireframe"
      produced_by: builder | architect | database-engineer | documenter | sre | release-manager | librarian | maintainer
      validated_by: validator
      reviewed_by: [reviewer]  # add security-engineer, privacy-engineer, rai, accessibility per artifact tags
      on_format_violation: refuse-and-route-back
      on_validation_failure: refuse-and-route-back
      manifest_locked: true
```

## Field rules

- Every entry must have all fields. No optional `expected_format` blocks.
- `must_NOT_be` MUST include any binary office formats (`.docx`, `.pptx`, `.xlsx`, `.pdf`) for any non-binary `type`. This prevents the Copilot-365 failure mode.
- `produced_by` is the role that authors the artifact. Validator runs the gate; Reviewer (plus any role in `reviewed_by`) reviews.
- `reviewed_by` must include every role whose domain the artifact touches:
  - Code that handles auth, secrets, or external input: include `security-engineer`.
  - Code or schema that touches PII / PHI / PCI / financial / classified: include `privacy-engineer`.
  - Code that calls an LLM or trains a model: include `rai` (only if active in Role Manifest).
  - UI artifact: include `accessibility` (only if active in Role Manifest).
  - Schema, migration, or RLS rule: produced_by is `database-engineer`; reviewed_by adds `database-engineer` (yes, they review each other's work via supersede + co-review).
- An entry remains in the manifest after the artifact is `archived`; status lives in `artifacts.md`, not here.

## Gates that consume this manifest

| Gate | Check |
|---|---|
| Plan | Every task in `implementation-plan.md` maps to one or more manifest entries. No entry has `type: doc` for something Concept declared as a runtime feature. |
| Build per-artifact | The on-disk artifact's path matches the manifest entry's path; extension matches; Validator's three-pass returns `pass` (recorded in `validation-log.md`). |
| Audit | Every manifest entry has a corresponding on-disk artifact in the declared format and language. No `.docx` exists where the manifest says `.py`. No orphan artifacts (on-disk files not in the manifest). |

## Adding entries after lock

If the Build phase reveals a needed artifact not in the manifest:

1. Builder stops on the current artifact.
2. Builder writes `handoff.md` with a `design-gap` entry naming the missing artifact.
3. Orchestrator routes to Architect to extend the manifest.
4. Architect (with Builder if needed) adds the entry and re-locks the affected portion (a partial re-gate; the rest of the manifest stays locked).
5. Builder resumes.
