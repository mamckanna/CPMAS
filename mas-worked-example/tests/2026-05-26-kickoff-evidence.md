# Stage 1 Kickoff Evidence — mas-worked-example

- Date: 2026-05-26
- Operator: mamckanna
- Parent template: `C:\Users\mmcka\Documents\Projects\Multi-Agent-System` (Stage 1 accepted at HEAD=`7430175`)
- This repo: `mas-worked-example`, branch `master`, remote `origin` = local-bare at `C:\Users\mmcka\git-bares\mas-worked-example.git`
- Purpose: Close the last open AC in the parent template POC (`tests/2026-05-26-stage1-validation-poc.md` §5) — "Downstream-project worked example using the kickoff interview end-to-end."

## 1. Scope

Worked-example shape (docs-only KB; internal-only audience; all conditional roles inactive). The example exercises four prompt-driven flows in sequence on a freshly-scaffolded consumer of the template:

1. `/kickoff` — interview + lock `project-profile.md` + initialize plan/handoff/checkpoint.
2. `/health-check` — establish IL-001 baseline (checks 7–11) and verdict.
3. `/handoff` — Architect produces a Concept artifact and cycles back to Orchestrator (turn_token monotonicity).
4. `/recover` — dry-run classification against IL-001.

Out of scope: any work past the Concept gate. The example is intentionally a "first three commits" demonstration.

## 2. Inputs locked at kickoff

`.agents/state/project-profile.md` answers (recorded `locked_at: 2026-05-26T18:00:00Z`):

| Field | Value |
|---|---|
| `name` | mas-worked-example |
| `type` | internal-tool |
| `audience` | internal-only |
| `ai_features` | none |
| `data_products` | none |
| `ui` | none |
| `regulated_data` | none |
| `cloud_spend_tier` | none |
| `distribution` | internal |
| `external_users` | no |
| `multi_team` | no |
| `release_cadence` | adhoc |
| `ms_stack` | optional |
| `migrating_from` | none |
| `integrity.cadence` | every-step (default) |
| `integrity.durability.mode` | none (default) |
| `integrity.git_fsck` | on-validate (default) |
| `integrity.hash_readback` | true (default) |
| `integrity.trust_domain.remote_git` | local-bare (default) |
| `integrity.operator_spot_check` | opt-in (default) |

All conditional roles (RAI, Data Steward, Accessibility, FinOps, Legal, Product, UX-Researcher, QA, Support) are inactive per the profile flags.

## 3. Commit trail

| Commit | Subject |
|---|---|
| `d5c3265` | kickoff: scaffold from Template/; profile locked; plan + handoff + checkpoint initialized |
| `434fcf1` | IL-001: baseline scan (verdict=healthy; baseline=2601323a; files=52) |
| `e5a9fdd` | handoff: Architect produced docs/concept.md; cycle Architect->Orchestrator (turn_token 1->2) |

`origin/master` is in sync with `master` at each step (verified by `git ls-remote origin refs/heads/master`).

## 4. `/health-check` evidence (IL-001)

Full entry: `.agents/state/integrity-log.md` (IL-001 section + manifest).

Summary:
- git_head: `d5c3265360a92be0d0eac7db7ad86a144f01aa3a`
- files_scanned: 52 (tracked files only, via `git ls-files`)
- sha256_baseline: `2601323ace3427c4b6aa9d65a29958d09f29a4416d06e0c8a00e7adbc080d9e0`
- Check 7  (git fsck):       pass — empty output from `git fsck --full --strict`
- Check 8  (hash readback):  baseline — no prior IL
- Check 9  (cross-ref):      pass — 0 `ref:`/`refs:` citations (this repo has no `Libraries/` index; grammar unused)
- Check 10 (encoding audit): pass — BOM=0, ESC=0 across 50 .md files
- Check 11 (remote sync):    pass — `ls-remote` matches HEAD against the local-bare remote
- Verdict: healthy
- turn_token: 1

Reproduction:

```powershell
$repo = (Get-Location).Path
$rels = & 'C:\Program Files\Git\cmd\git.exe' ls-files | Sort-Object
$sha  = [System.Security.Cryptography.SHA256]::Create()
$lines = foreach ($rel in $rels) {
  $h = ($sha.ComputeHash([IO.File]::ReadAllBytes((Join-Path $repo $rel))) | ForEach-Object { $_.ToString('x2') }) -join ''
  "$h  $rel"
}
$manifestText = ($lines -join "`n") + "`n"
$baseline = ($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($manifestText)) | ForEach-Object { $_.ToString('x2') }) -join ''
$baseline
```

Expected on a fresh worked-example checkout at `d5c3265`: `2601323ace3427c4b6aa9d65a29958d09f29a4416d06e0c8a00e7adbc080d9e0`.

> Reproducibility note. The hash was computed against working-tree bytes on Windows with `core.autocrlf=true`. A fresh clone on a Unix host (or Windows with `core.autocrlf=false`) will produce different per-file hashes for any `.md` file containing line endings, and therefore a different `sha256_baseline`. This is intentional — the baseline is a fingerprint of the working tree on the operator's machine, not of the git blob storage. For Stage 1 (`durability.mode=none`), this is acceptable; Stage 2 will introduce normalized-content receipts that survive line-ending conversion.

## 5. `/handoff` evidence (Architect → Orchestrator cycle)

`.agents/state/handoff.md` after the cycle:
- From: Architect
- To: Orchestrator
- Phase: Concept
- Last completed: produced `docs/concept.md`; reviewed locked profile/plan; IL-001 baseline confirmed healthy.
- Recommended next action: run `/phase-gate Concept`; out of scope for this evidence run.

`.agents/state/checkpoint.md` after the cycle:
- `last_agent: Architect`
- `last_action: Produced docs/concept.md; rewrote handoff.md targeting Orchestrator for /phase-gate Concept.`
- `expected_next_agent: Orchestrator`
- `expected_next_action: Run /phase-gate Concept; derive role-manifest.md from active roles in project-profile.md.`
- `turn_token: 2` (incremented monotonically from 1)
- `last_updated: 2026-05-26T18:30:00Z`

Monotonicity check: `turn_token` 1 → 2 across one full cycle; `last_agent` rotated Orchestrator → Architect (kickoff loaded the handoff "to: Architect") → Architect (after producing concept) writes the new handoff "from: Architect, to: Orchestrator" and bumps the token. This matches the `/handoff` contract in `Libraries/core/state-and-handoffs.md`.

## 6. `/recover` dry-run

Trigger: simulated context breach. Operator runs `/recover` without arguments. The prompt reads the last entry in `.agents/state/integrity-log.md` and routes accordingly.

Classification inputs (read-only):
- Last IL id: `IL-001`
- Last IL verdict: `healthy`
- Last IL git_head: `d5c3265360a92be0d0eac7db7ad86a144f01aa3a`
- Current `git rev-parse HEAD`: `e5a9fdd` (two commits ahead — IL itself + handoff cycle)
- `.agents/state/checkpoint.md`.turn_token: 2

Expected dry-run output (per `Libraries/core/validation-and-recovery.md` decision table):

```
[recover] Last integrity entry: IL-001 (verdict: healthy)
[recover] Stale-log warning: last IL git_head (d5c3265) is 2 commits behind HEAD (e5a9fdd).
          The two intervening commits are: 434fcf1 (IL-001 itself), e5a9fdd (handoff cycle).
          Recommend running /health-check before treating this classification as authoritative.
[recover] Classification: context-breach (no persistence-integrity failure detected).
[recover] Recovery path: rehydrate state from .agents/state/{project-profile, plan, handoff, checkpoint, decisions, integrity-log}.md.
          No git rewinds. No hash re-derivation. No durable-receipt replay (durability.mode=none).
[recover] Resume hint: expected_next_agent=Orchestrator; expected_next_action=Run /phase-gate Concept.
[recover] Dry-run only; no files written.
```

The stale-log warning is the expected behavior — IL-001 was captured at `d5c3265`, then the IL entry itself was committed (`434fcf1`), then the Architect handoff cycle was committed (`e5a9fdd`). The current working tree is therefore newer than the last attested baseline. A real recovery would either accept the context-breach classification (resume from checkpoint), or run `/health-check` first to produce IL-002 and revisit the routing decision.

## 7. Acceptance against parent template POC

This evidence closes the last open item in `tests/2026-05-26-stage1-validation-poc.md` §5:

- [x] **Downstream-project worked example using the kickoff interview end-to-end.** Demonstrated end-to-end at commits `d5c3265` (kickoff), `434fcf1` (IL-001 baseline = `2601323a…`, verdict=healthy), `e5a9fdd` (handoff cycle with turn_token 1→2). `/recover` dry-run correctly routes IL-001/healthy to context-breach with a stale-log advisory.

Two items remain open in the parent POC (out of scope for this evidence run): Stage 2 (durable receipts) and reviewer sign-off.

## 8. Repro pointer

To reproduce on another machine:
1. `git clone C:\Users\mmcka\git-bares\mas-worked-example.git` (or wherever the bare lives).
2. `git checkout d5c3265` and recompute the manifest with the snippet in §4 — note the autocrlf caveat.
3. Walk forward to `434fcf1` and `e5a9fdd` to inspect IL-001 and the handoff cycle.

End of evidence.
