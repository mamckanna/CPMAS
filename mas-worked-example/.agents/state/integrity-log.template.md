<!--
integrity-log.md — append-only log of /health-check persistence-integrity scans (checks 7–11).
Owner: /health-check prompt. Readers: all (Validator, Reviewer, Auditor may cite an IL-id when arguing a verdict).
Spec: Libraries/core/validation-and-recovery.md.
-->

# Integrity Log

This file is **append-only**. Never edit an existing entry; supersede by appending a new IL-id that references the prior one.

Each entry records one `/health-check` invocation that ran at least one of checks 7–11 (git fsck, hash readback, cross-reference, encoding audit, remote sync). Checks 1–6 are reported in `/health-check` output but **not** logged here — they are state-consistency checks, not persistence-integrity checks.

## Entry shape

```
## IL-<NNN>: integrity scan
- Date: YYYY-MM-DDTHH:MM:SSZ
- Trigger: health-check | kickoff | manual | pre-commit
- git_head: <40-char SHA>                    (or "n/a (no git)" if integrity.git_fsck=never and no .git/)
- files_scanned: <int>
- sha256_baseline: <64-char SHA-256 of the sorted hash manifest below>
- Check 7  (git fsck):       pass | fail: <reason> | skipped (gate off)
- Check 8  (hash readback):  pass | warn: <count> intended-diff | fail: <count> drift | skipped (no baseline)
- Check 9  (cross-ref):      pass | fail: <count> orphan refs: <id-list>
- Check 10 (encoding audit): pass | fail: BOM=<n> ESC=<n>; files: <list>
- Check 11 (remote sync):    pass | warn: ahead <n> | fail: behind <n> | n/a (no remote) | skipped (gate off)
- Verdict: healthy | warn | unhealthy
- Notes: <one-line freeform; cite specific files / object ids / refs>
- turn_token: <int from checkpoint.md at end of this turn>
```

### Hash manifest (appended below each IL entry when Check 8 ran)

```
### IL-<NNN> hash manifest
<sha256>  <relative path>
<sha256>  <relative path>
...
```

Manifest must be sorted by path (LC_ALL=C order). The `sha256_baseline` field above is the SHA-256 of the manifest's exact bytes (concatenated lines, LF-terminated). This makes the manifest itself tamper-evident: any future scan that re-derives the baseline must match.

## Hard rules

1. One entry per `/health-check` invocation that ran at least one of checks 7–11. Read-only invocations (all gates off) produce no entry; the agent prints `IL entry: none`.
2. Verdict precedence: any `fail` → `unhealthy`; otherwise any `warn` → `warn`; else `healthy`. A scan that ran zero of checks 7–11 caps at `warn`.
3. The hash manifest is the artifact that makes Check 8 work on the next run. Removing it breaks readback verification; the next run will record `skipped (no baseline)` and restart the baseline chain.
4. `git_head` records the exact commit at the time of the scan. If the working tree is dirty (uncommitted changes), append ` (dirty)` to the SHA.
5. Entries never disappear. A superseded scan stays in the log; the new IL-id has `Notes:` `supersedes: IL-<prior>` and explains why (e.g., manifest restart after intentional bulk edit).
6. `/health-check` is the **only** writer of this file. No other agent, prompt, or human edit. Drift here is a trust-domain breach.

## Numbering

IL-ids are zero-padded three-digit (`IL-001`, `IL-002`, ...). Allocate sequentially across the whole project. Never reset, never reuse.
