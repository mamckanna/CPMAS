---
description: "Validate state-file integrity without changing anything. Run on demand, or before risky operations."
mode: agent
---

# /health-check

Run a non-destructive integrity scan across `.agents/state/` and the artifacts it references. Report; do not fix.

## Check 1 — Checkpoint freshness

- Read `.agents/state/checkpoint.md`.
- All six fields present (`last_agent`, `last_action`, `expected_next_agent`, `expected_next_action`, `turn_token`, `last_updated`)?
- `turn_token` is a positive integer?
- `last_updated` is valid ISO 8601 UTC?
- Time since `last_updated` is plausible (warn if > 14 days)?

## Check 2 — Phase consistency

- Does `checkpoint.md`'s implied phase agree with `plan.md`'s `Current phase`?
- Is `expected_next_agent` consistent with the phase-to-agent dispatch table in `orchestrator.chatmode.md`?

## Check 3 — Token monotonicity

- Scan `decisions.md`, `artifacts.md`, `review-log.md` for any `turn_token:` references.
- The highest token found anywhere must equal `checkpoint.md`'s `turn_token`.
- If higher tokens appear in logs than in `checkpoint.md`: **token regression**.

## Check 4 — Artifacts on disk

- For every `A-NNN` entry in `artifacts.md` with status other than `superseded`, verify the listed `Path` exists on disk.
- Report missing paths as blockers.

## Check 5 — Open blockers vs. handoff

- For every `[BLOCKER]` finding in `review-log.md` not later marked resolved:
  - Verify `handoff.md` references it or routes to the producer agent.
  - Report orphan blockers.

## Check 6 — Allow-list discipline (best-effort)

- Run `git diff --name-only HEAD~1 HEAD` (or equivalent).
- For each file touched, infer the likely owning agent from path:
  - `docs/` → Architect
  - `src/`, `infra/`, `tests/`, `.github/workflows/` → Builder
  - `.agents/state/review-log.md` (and only that) → Reviewer
  - `.agents/state/plan.md`, `.agents/state/handoff.md` → Orchestrator
- Cross-reference with the last few `last_agent` values in the logs. Report mismatches as warnings.

## Persistence-integrity checks (gated by `project-profile.md` → `integrity:`)

Checks 7–11 verify that what we *believe* is on disk *actually is* on disk, unaltered, and survives an independent readback. Skip the check entirely when its profile gate is off. Each run that executes any of checks 7–11 appends one `IL-NNN` entry to `.agents/state/integrity-log.md` (this is the only file `/health-check` writes; profile must set `integrity.enabled: true` first).

## Check 7 — Git object integrity

- Gate: `integrity.git_fsck` in `{on-validate, on-commit}` and a `.git/` exists at repo root.
- Run `git fsck --full --strict --no-progress`.
- `pass` if exit 0 and zero `error:` / `missing` lines; `fail` otherwise.
- Cite the offending object ids in the IL entry.

## Check 8 — Hash readback

- Gate: `integrity.hash_readback: true` AND prior `IL-NNN` exists with a recorded `sha256_baseline` manifest.
- For each file under `.agents/state/`, `docs/`, and the produced-artifact paths in `artifacts.md` (excluding `superseded`), compute SHA-256 via `Get-FileHash -Algorithm SHA256` (PowerShell) or `sha256sum` (POSIX).
- Compare against the manifest recorded in the most recent `IL-NNN` with verdict `healthy`.
- `pass` if every expected path matches; `warn` if files were intentionally modified since (changes are visible in `git diff`); `fail` if a file's recorded hash no longer matches and there is no corresponding git diff explaining the change.

## Check 9 — Cross-reference integrity

- Gate: always on.
- Scan `.agents/state/*.md` and `docs/**/*.md` for `ref: <id>` and `refs: <id>, <id>` tokens.
- For each referenced id, verify a file exists at `Libraries/**/<id>.md` with matching frontmatter `id:`.
- `pass` if every reference resolves; `fail` with the orphan id list otherwise.

## Check 10 — Encoding audit

- Gate: always on.
- For every `.md` file in the repo:
  - Reject UTF-8 BOM (bytes `EF BB BF` at offset 0).
  - Reject `\uXXXX` escape sequences in markdown body text (regex `\\u[0-9A-Fa-f]{4}`); they signal a JSON-escaped paste that never got decoded.
- `pass` if `BOM=0` and `ESC=0`; `fail` with file lists otherwise.

## Check 11 — Remote sync

- Gate: `integrity.trust_domain.remote_git != none`.
- Run `git fetch --quiet <remote>` then `git rev-list --count HEAD..<remote>/HEAD` and the inverse.
- `pass` if local equals remote; `warn` if local is ahead (un-pushed work); `fail` if remote is ahead (someone else pushed; potential trust-domain divergence) or if fetch errored.
- `n/a` if `remote_git: none`.

## Output

Print, then append one `IL-NNN` entry to `integrity-log.md` if any of checks 7–11 ran:

```
Health check — <UTC timestamp>
- Checkpoint freshness:  <ok | warn: ...>
- Phase consistency:     <ok | block: ...>
- Token monotonicity:    <ok | block: ...>
- Artifacts on disk:     <ok | block: <count> missing>
- Open blockers:         <ok | warn: <count> orphan>
- Allow-list discipline: <ok | warn: <count> mismatches>
- Git fsck:              <ok | fail: ... | skipped (gate off)>
- Hash readback:         <ok | warn: <count> drift | fail: <count> | skipped (no baseline)>
- Cross-ref integrity:   <ok | fail: <count> orphan refs>
- Encoding audit:        <ok | fail: BOM=<n> ESC=<n>>
- Remote sync:           <ok | warn: ahead <n> | fail: behind <n> | n/a>

Verdict: <healthy | warn | unhealthy>
Recommended next: <none | run /recover | resolve specific item>
IL entry: <IL-NNN | none>
```

## Hard rules

- Do not write to any state file **except** `integrity-log.md`, and only append (never edit) when any of checks 7–11 actually ran.
- Do not "fix" anything you find. Recommend `/recover` for state issues; recommend operator review for integrity failures.
- Do not skip checks 1–6 or checks 9–10. They are unconditional.
- Do not silently change profile gates. If `integrity.enabled` is unset, treat as `false` and skip checks 7, 8, 11 with `skipped (profile)`.
- Do not let an agent produce a `healthy` verdict on a turn where it ran zero of checks 7–11. Either gates are off (then verdict caps at `warn` with note `no persistence checks ran`), or at least one of 7–11 must execute.
