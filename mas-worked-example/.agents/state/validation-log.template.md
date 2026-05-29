<!--
validation-log.md — append-only log of Validator three-pass results.
Owner: Validator. Readers: all (Reviewer must cite a V-id before passing).
Spec: Design/SYSTEM-DESIGN.md §9.
-->

# Validation Log

This file is **append-only**. Never edit an existing entry; supersede with a new one (next V-id, reference prior).

Each entry records one artifact, one attempt, three passes (format -> static -> build/test). Passes are strict-ordered: a later pass is `skipped` if an earlier pass failed.

## Entry shape

```
## V-<NNN>: <artifact-id> validation
- Date: YYYY-MM-DDTHH:MM:SSZ
- Artifact: A-<NNN>            (from artifact-manifest.md)
- Path: <on-disk path>
- Attempt: <int, 1 on first attempt for this artifact>
- Format pass: pass | fail: <one-line reason>
- Static pass: pass | fail: <one-line reason> | skipped (prior fail)
- Build/test pass: pass | fail: <one-line reason> | skipped (prior fail)
- Verdict: pass | fail
- Tool output excerpt: |
    <5-20 key lines, NOT full output>
- Recommendation if fail: <what produced_by agent must do>
- turn_token: <int>
```

## Hard rules

1. One entry per artifact per attempt. Reattempts get a new V-id with `Attempt: <prior+1>`.
2. Pass order is strict. Validator runs Format first, Static only if Format passed, Build/test only if Static passed.
3. A `.docx`, `.pdf`, `.pptx`, or any binary office format where the manifest's `type` is not `binary` is an immediate Format fail with reason `format-violation`.
4. Reviewer **cannot** issue a `pass` verdict on an artifact without a matching `V-NNN` with `Verdict: pass`. Reviewer cites the V-id in their REV- entry.
5. Audit **cannot** pass without every manifest entry having a V- entry with `Verdict: pass`.
6. Entries never disappear. A superseded artifact's V- entries stay in the log; the new artifact gets new V-ids.

## Numbering

V-ids are zero-padded three-digit (`V-001`, `V-002`, ...). Allocate sequentially across the whole project. Do not reset.
