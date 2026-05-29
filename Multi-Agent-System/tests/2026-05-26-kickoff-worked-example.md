# Kickoff Worked Example — mas-worked-example

- Date: 2026-05-26
- Operator: mamckanna
- Purpose: Record, inside this template repo, that the Stage 1 POC's last open item — "Downstream-project worked example using the kickoff interview end-to-end" — was exercised in a separate consumer repo. This doc is the meta-repo's pointer; the full evidence (state file contents, manifest, dry-run output) lives with the consumer.
- Status: PASS. Closes the last open AC from [tests/2026-05-26-stage1-validation-poc.md](2026-05-26-stage1-validation-poc.md) §5.

## Consumer repo

- Working tree: `C:\Users\mmcka\Documents\Projects\mas-worked-example`
- Remote: local-bare at `C:\Users\mmcka\git-bares\mas-worked-example.git` (`origin/master`)
- Shape: docs-only internal knowledge base. All conditional roles (RAI, Data Steward, Accessibility, FinOps, Legal, Product, UX-Researcher, QA, Support) intentionally inactive per the locked profile.
- Detailed evidence (state files, full IL-001 manifest, /recover dry-run transcript): `mas-worked-example/tests/2026-05-26-kickoff-evidence.md` at consumer HEAD `1c9a92c`.

## Commit chain

| Commit | Flow | What it proves |
|---|---|---|
| `d5c3265` | `/kickoff` | Scaffold from `Template/` produces 52 tracked files; `project-profile.md` locked at 2026-05-26T18:00:00Z with integrity defaults; `plan.md` @ Concept; `handoff.md` Orchestrator→Architect; `checkpoint.md` turn_token=1. |
| `434fcf1` | `/health-check` IL-001 | Baseline `sha256_baseline=2601323ace3427c4b6aa9d65a29958d09f29a4416d06e0c8a00e7adbc080d9e0` over 52 files. Checks 7/10/11 pass; check 8 = baseline (no prior IL); check 9 pass (0 `ref:` citations expected — no `Libraries/` index). Verdict: **healthy**. |
| `e5a9fdd` | `/handoff` cycle | Architect produced `docs/concept.md` and rewrote `handoff.md` (Architect→Orchestrator); `turn_token` advanced 1→2 monotonically; `checkpoint.md` updated with `last_agent=Architect`. |
| `1c9a92c` | Evidence doc | Consumer-side write-up of all four flows including the `/recover` dry-run transcript. |

`origin/master` matched `master` at each push (verified via `git ls-remote`).

## `/recover` dry-run outcome

Inputs at the time of dry-run:
- last IL: `IL-001` (verdict=healthy, git_head=`d5c3265`)
- current HEAD: `e5a9fdd` (two commits ahead)

Expected classification per [Libraries/core/validation-and-recovery.md](../Libraries/core/validation-and-recovery.md): **context-breach** path with stale-log advisory (IL git_head ≠ current HEAD). No git rewinds, no hash re-derivation, no durable-receipt replay (`durability.mode=none`). Full simulated output in the consumer's evidence doc §6.

## AC mapping

This worked example exercises the same Stage 1 ACs already documented in `2026-05-26-stage1-validation-poc.md`. It does **not** introduce new ACs. The role of this doc is to record that the toolchain has been driven end-to-end on a fresh consumer of the template, not just on the template-development workspace itself.

| AC | Evidence in this run |
|---|---|
| AC-1..AC-3 (`/kickoff` outputs) | Consumer commit `d5c3265`; state files in `.agents/state/`. |
| AC-4..AC-12 (checks 7–11, manifest, verdict) | Consumer commit `434fcf1`; IL-001 entry. |
| AC-13..AC-16 (`/handoff` token monotonicity, checkpoint rewrite) | Consumer commit `e5a9fdd`. |
| AC-17..AC-20 (`/recover` routing, stale-log advisory) | Consumer evidence doc §6 (dry-run; no commit produced). |

## Known caveats reproduced during this run

1. **Working-tree baselines are operator-machine fingerprints.** Hashes are computed over working-tree bytes; on Windows with `core.autocrlf=true`, a Unix clone produces different per-file hashes for any `.md` file. Acceptable for Stage 1 (`durability.mode=none`); Stage 2 must introduce normalized-content receipts. Documented in consumer evidence §4.
2. **PowerShell terminal CWD can desync from `[Environment]::CurrentDirectory`.** `Get-Location` and the `[IO.File]` static methods can disagree. Mitigation: after `Set-Location`, set `[Environment]::CurrentDirectory = (Get-Location).Path` before any `[IO.File]` call with a relative path.
3. **Backtick-fence authoring via PowerShell `-replace` is fragile.** A naive `-replace '``', '`'` overlap-collapses 3-backtick fences to 2-backticks. Authoring fenced code blocks via the file-write tooling avoided the issue.

## Repro pointer

To reproduce the consumer side from a clean clone of the bare:

```pwsh
& 'C:\Program Files\Git\cmd\git.exe' clone C:\Users\mmcka\git-bares\mas-worked-example.git
cd mas-worked-example
& 'C:\Program Files\Git\cmd\git.exe' checkout d5c3265
# Recompute baseline using the snippet in mas-worked-example/tests/2026-05-26-kickoff-evidence.md §4
# Expected baseline (Windows + autocrlf=true): 2601323ace3427c4b6aa9d65a29958d09f29a4416d06e0c8a00e7adbc080d9e0
```

End of pointer.
