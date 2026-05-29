---
description: "Rebuild working context from state files alone, or surface rollback candidates after an integrity breach. Run after a suspected compaction or when /health-check reports warn/unhealthy."
mode: agent
---

# /recover

Two breach types share this prompt:

- **Context breach** — chat compaction or wrong-mode handoff. Working context is suspect; state files on disk are trusted. Rebuild the working context from state files.
- **Integrity breach** — `/health-check` reported `warn` or `unhealthy`. State files on disk are suspect. Surface rollback candidates from the integrity log; the operator decides whether to roll back.

Ignore everything you "remember" from chat history above this prompt.

## Step 1 — Read state

1. `.agents/state/checkpoint.md` — integrity header.
2. `.agents/state/plan.md` — current phase and gate status.
3. `.agents/state/handoff.md` — last next-action payload.
4. `.agents/state/decisions.md` — last 5 entries.
5. `.agents/state/artifacts.md` — last 10 entries.
6. `.agents/state/review-log.md` — any open blockers.
7. `.agents/state/integrity-log.md` — the **most recent IL entry only** (capture `Date`, `Trigger`, `git_head`, `files_scanned`, `sha256_baseline`, per-check results, `Verdict`).

Do not summarize. Just read.

## Step 2 — Classify the breach

Use the most recent `IL-NNN` entry's `Verdict`:

| Last IL Verdict | Breach class | Continue to |
|---|---|---|
| `healthy` | **Context breach** | Step 3-context |
| `warn` or `unhealthy` | **Integrity breach** | Step 3-integrity |
| (no `integrity-log.md` present) | **Unknown** — treat as context breach; flag in Step 6 and recommend running `/health-check` after recovery | Step 3-context |

Also compute and remember: does the most recent IL's `git_head` equal the current `git rev-parse HEAD`? If not, the integrity log is stale (at least one commit landed after the last scan) — flag this in Step 6 regardless of path.

## Step 3-context — Detect the context breach

State, in one sentence each:

- What `checkpoint.md` says the current state is (`last_agent`, `expected_next_agent`, `turn_token`, `last_updated`).
- What `plan.md` says the current phase is.
- Whether `expected_next_agent` in `checkpoint.md` matches the chat mode currently active.
- Whether there are open blockers in `review-log.md` that are not referenced in `handoff.md`.

### Classify

| Symptom | Classification |
|---|---|
| `expected_next_agent` != current chat mode | **Wrong-mode breach**. Route the user to the expected mode. |
| `turn_token` missing, zero, or lower than the most recent `decisions.md` / `artifacts.md` / `review-log.md` reference to it | **Token breach**. Rebuild `checkpoint.md` from the highest token found in the logs + 1. |
| Phase in `checkpoint.md` disagrees with `plan.md` | **Phase drift**. Trust `plan.md`; rewrite `checkpoint.md` to match. |
| Artifacts in `artifacts.md` missing on disk | **Artifact drift**. Flag in `review-log.md`; route to Reviewer. |

### Rewrite `checkpoint.md`

Use the canonical schema (see `checkpoint.template.md`). Increment `turn_token`. Set `last_action` to `Recovered from <classification>.`. Set `last_updated` to current UTC ISO 8601.

Proceed to Step 5-context, then Step 6.

## Step 3-integrity — Surface rollback candidates

1. Walk `integrity-log.md` entries **most-recent-first** and pick the first entry whose `Verdict: healthy`. This is the **last-known-good (LKG)**. Capture its `IL-NNN`, `Date`, `git_head`, and `sha256_baseline`.
2. Continue walking and capture up to **two more** prior healthy entries as alternates.
3. From the failing (most recent) IL entry, extract:
   - The failed check number(s): 7, 8, 9, 10, and/or 11.
   - For a Check 8 fail: the file path(s) named in the entry's Check 8 line or `Notes:` field.
   - The `sha256_baseline` recorded under the failure (so the operator can re-derive after rollback).
4. Compose the rollback-candidates output (Step 4-integrity).

### Step 4-integrity — Present options to the operator

Print exactly this block, filled in:

```
Integrity breach detected.
- Failing IL: IL-<NNN> (<date>), verdict <warn|unhealthy>
- Failed checks: <comma-separated list, e.g. "8">
- Files implicated (Check 8 only): <comma-separated list, or "none">
- Last-known-good: IL-<NNN> at <git_head short>, sha256_baseline <short>, scanned <date>
- Alternates (older healthy IL entries): IL-<NNN> @ <short>; IL-<NNN> @ <short>

Recovery options (operator runs the command; /recover does not execute it):

A. Minimal — revert only the named file(s) to LKG
     git checkout <LKG git_head> -- <path> [<path> ...]
   Use when Check 8 named specific files and no other failures are present.

B. Working-tree restore — restore every tracked file to LKG state, keep history
     git status --short                                    # review uncommitted work first
     git stash push -u -m "pre-recover snapshot"           # only if there is work to preserve
     git checkout <LKG git_head> -- .
   Use when multiple files are implicated or the failure pattern is unclear.

C. Hard reset — discard commits ahead of LKG (destructive)
     git reset --hard <LKG git_head>
   Use only when commits themselves are bad. push --force-with-lease only after the operator confirms.

D. Investigate manually — stop, do nothing, ask for guidance.

Pick A / B / C / D.
```

Stop. Do not execute any of A/B/C. Recovery actions touch source files and are operator-driven.

After the operator runs the chosen action, instruct them to run `/health-check` to append a new IL entry. Expected outcome:

- Option A: new `sha256_baseline` equals the LKG baseline if and only if the named files were the **only** drift.
- Option B/C: new `sha256_baseline` equals the LKG baseline byte-for-byte.
- Any other result is a second-order issue and warrants another `/recover` pass.

Proceed to Step 6 (skip Step 5-context).

## Step 5-context — Tell the user

Print:

```
Recovery complete (context).
- Breach: <classification>
- Current phase: <phase from plan.md>
- Next agent: <expected_next_agent from rewritten checkpoint.md>
- Next action: <one sentence>
- turn_token: <new value>
```

## Step 6 — Stale-log + missing-log warnings (always)

After either path, also print whichever of these apply:

- If the last IL's `git_head` ≠ current `HEAD`: `Warning: integrity log is stale (last scan at <short>, HEAD is <short>). Run /health-check to refresh.`
- If `integrity-log.md` was missing: `Warning: integrity-log.md not found. Run /health-check to establish a baseline.`

## Step 7 — Stop

Do not continue the next action yourself. The user re-issues the next request once they have switched to the correct chat mode (context path) or completed the chosen recovery action (integrity path).

## Hard rules

- Do not invent state. If a file is missing or unreadable, **say so** and stop. Do not guess.
- Do not edit `decisions.md`, `artifacts.md`, `review-log.md`, or `integrity-log.md` during recovery. They are append-only and owned by other prompts.
- Do not edit source files during recovery. Recovery is metadata-only. For the integrity-breach path: print rollback commands, do not execute them.
- The default rollback target is the **most recent** healthy IL. Do not pick an older alternate unless the operator explicitly asks.
- Recovery always ends with the operator running `/health-check` (integrity path) or switching chat mode (context path). The new IL entry closes the loop.
