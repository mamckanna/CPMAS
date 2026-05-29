<!--
artifacts.md — append-only index of artifacts produced by Builder (and other producing roles).
Owner: producing role (Builder primarily; Database Engineer, Documenter, SRE, Release Manager, Librarian, Maintainer also append).
Spec: Design/SYSTEM-DESIGN.md §4.
-->

# Artifacts

This file is **append-only**. Never edit an existing entry; supersede with a new one referencing the prior id.

Each entry indexes one artifact on disk, links it to its manifest entry, and tracks its status through the gate chain (validation -> review -> pass).

## Entry shape

```
## A-<NNN>: <short title>
- Date: YYYY-MM-DDTHH:MM:SSZ
- Path: <relative path>
- Manifest entry: A-<NNN>            (MUST match an entry in artifact-manifest.md)
- Task: <task id from implementation-plan.md>
- Produced by: <role>
- Status: draft | validation-requested | validated | review-requested | reviewed-pass | reviewed-blocked | superseded | archived
- Validation: V-<NNN> | pending
- Reviews: REV-<NNN>, SEC-<NNN>, PRIV-<NNN>, RAI-<NNN>, A11Y-<NNN>, ... (per manifest's reviewed_by; "pending" if not yet started)
- Supersedes: A-<NNN> | none
- turn_token: <int>
```

## Status semantics

| Status | Meaning |
|---|---|
| `draft` | Artifact authored; self-check not run. |
| `validation-requested` | Handoff to Validator pending. |
| `validated` | Validator returned `Verdict: pass`. |
| `review-requested` | Handoff to Reviewer (and any other roles in manifest `reviewed_by`) pending. |
| `reviewed-pass` | All reviews returned pass. Artifact is shippable. |
| `reviewed-blocked` | At least one review returned `block`. Producing agent owns the fix. |
| `superseded` | A newer artifact replaces this one. The new entry's `Supersedes` field points back. |
| `archived` | Migration retirement (see Migration workflow). Kept on disk under `archive/` for traceability. |

## Hard rules

1. One A-id per artifact. Reattempts that produce a meaningfully different artifact get a new A-id with `Supersedes`.
2. `Manifest entry` MUST match an existing entry in `artifact-manifest.md`. No orphan artifacts.
3. `Status` advances strictly along the chain (draft -> validation-requested -> validated -> review-requested -> reviewed-pass). Backwards transitions are not edits — append a new line with the regressed status and a reason in the title.
4. A-ids are zero-padded three-digit (`A-001`, ...) and shared with the manifest's numbering space (the same A-id refers to the same logical artifact in both files).
5. Audit pass requires every `manifest_locked: true` entry in `artifact-manifest.md` to have a corresponding A-id in this file with `Status: reviewed-pass` (or `superseded` -> a successor with `reviewed-pass`).

## Numbering

A-ids are allocated by the producing role on first append. Allocation is sequential across the project, shared with `artifact-manifest.md`. Do not reset.
