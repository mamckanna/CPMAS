# Research Cross-Reference: `_research/` vs Stage-2 Tracks

Date: 2026-05-26
Sources: shallow clones at `C:\Users\mmcka\Documents\Projects\_research\`
- `drew_ai_skills/` (boss's repo, ~264 KiB, 69 skill dirs)
- `awesome-copilot/` (official GitHub-curated, ~56 MiB, 33.9k stars)

Verification context: read directly from disk (not web fetches). Status: triage only,
no `Libraries/` edits made.

## Headline finding

**GitHub Copilot ships an official hooks spec.** This is the single most important
artifact across either reference repo for our Stage-2 work. Event names:

| Event | Stage-2 role |
|---|---|
| `sessionStart` | baseline capture (record HEAD + IL hash on session begin) |
| `userPromptSubmitted` | governance audit (threat scan, IL state assertion) |
| `preToolUse` | **enforcement** — refuse writes that would corrupt IL chain |
| `postToolUse` | **readback** — Track A's independent `git hash-object` verify fires here |
| `sessionEnd` | durability commit + push to local-bare remote |
| `errorOccurred` | recovery handoff (mark IL entry as failed, freeze further writes) |

Spec: `https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks`
Reference implementations: `_research/awesome-copilot/hooks/` (six hooks, all shell-based).

This replaces the planned "wire readback into /health-check" approach. Hooks fire
automatically across all agent sessions and don't depend on the agent remembering
to call /health-check. Lower friction, higher coverage, uses official infrastructure.

## Direct prior-art search results

Grep for `fsync|hash-object|integrity[-_ ]log|attestation|readback|content[-_ ]addressed|durability`:

- **awesome-copilot**: 6 hits, all unrelated (AWS security, OWASP compliance, M365, Power Automate governance, a quality playbook). No direct Stage-2 prior art.
- **drew_ai_skills**: 2 hits, both unrelated (android-security, positioning audit).

Conclusion: our Stage-2 vocabulary (fsync mode names, IL chain, independent-process
readback, content-addressed external attestation) is not duplicated anywhere in
either reference repo. The git-as-IL-substrate insight remains ours.

## awesome-copilot — absorbable artifacts

### 1. `hooks/` (22 files, 6 hooks) — direct Stage-2 primitives

| Hook | Maps to | Notes |
|---|---|---|
| `tool-guardian` (`preToolUse`) | Track A enforcement | ~20 regex patterns across 6 threat categories; `GUARD_MODE=block` exits non-zero to refuse the tool call. Writes JSON Lines log to `.github/logs/copilot/tool-guardian/guard.log`. Zero deps. **Fork this** for Stage-2 IL-chain enforcement. |
| `session-auto-commit` (`sessionEnd`) | Track B durability | 50-line bash script: `git add -A` + timestamped commit + push. Uses `--no-verify`. **Doesn't fsync.** Forking adds `core.fsync=committed` and per-file `Flush($true)` before commit. |
| `governance-audit` (`sessionStart`/`sessionEnd`/`userPromptSubmitted`) | IL audit trail | Append-only JSON Lines log of governance events with privacy-aware redaction (logs threat-match snippets, not full prompts). Four governance levels: `open`/`standard`/`strict`/`locked`. **Direct analogue to integrity-log.md**, including the "log evidence not content" privacy pattern. |
| `session-logger` (3 events) | session journal | Simpler than governance-audit; just timestamps + cwd. Useful baseline structure if we want a separate session log distinct from the IL. |
| `secrets-scanner` (`sessionEnd`) | Stage-3 nice-to-have | Out of Stage-2 scope. Worth knowing it exists. |
| `dependency-license-checker` (`sessionEnd`) | not relevant | — |

### 2. `.schemas/` (3 files) — partial coverage

- `tools.schema.json` — tools catalog (`website/data/tools.yml`); not relevant to our customization files.
- `collection.schema.json` — collection manifests bundling prompts/instructions/agents/skills; relevant if we ever ship a Multi-Agent-System plugin bundle.
- `cookbook.schema.json` — recipe schema.

**Notable absence**: no JSON schema for `.agent.md`, `.instructions.md`, `.prompt.md`,
or `SKILL.md` frontmatter. The validation rules are documented in prose in `AGENTS.md`
and enforced by `npm run skill:validate` / `npm run plugin:validate` scripts under `eng/`.
If we want strict validation in our repo we either (a) write our own JSON schemas, or
(b) invoke their `eng/` validators against our customization files.

### 3. `AGENTS.md` — repo-level agent guidance pattern

Drop-in pattern for our `Template/AGENTS.md`: project overview → directory structure
→ setup commands → development workflow → testing → code style. Worth borrowing the
"Setup Commands" + "Testing Instructions" sections verbatim as headers since they're
de-facto convention.

### 4. `instructions/hooks.instructions.md` (not yet read)

Authoring rules for writing new hooks. Read this before we write our own Stage-2 hooks.

### 5. `docs/README.hooks.md` — the hook table

Canonical event list and a one-line-per-hook overview table. Same format we should
use in `Libraries/tools/multi-agent-system/index.md` for our own hooks.

### 6. `llms.txt` (at `awesome-copilot.github.com/llms.txt`)

Machine-readable index, not yet pulled. Grep target for future research.

## drew_ai_skills — absorbable artifacts

Boss's repo. Lean, well-structured, but **zero direct fit** for Stage-2 fsync/git-fsck/
readback work. Value is in authoring discipline, not persistence engineering.

### Methodology patterns worth absorbing

1. **Intent-phrase YAML descriptions** — descriptions are full activation phrases
   (e.g. "use when X happens or user says Y") rather than keyword lists. Claimed
   `OPTIMIZATION_REPORT.md` improvement: -84% tokens per invocation at equal
   decision quality. Our `Template/AGENTS.md` and any future `.skill.md` should
   follow this style.

2. **Hard line cap + structured template** (~75 lines):
   Identity → Stack Defaults → Decision Framework → Anti-Patterns → Quality Gates.
   The Anti-Patterns table is mandatory. We should adopt this for our internal
   skill files even though our doc culture is more verbose elsewhere.

3. **Repo-level `CLAUDE.md`** — single source of truth for repo-wide agent
   guidance, separate from per-skill files. Analogue: our `Template/AGENTS.md`,
   but boss's version is shorter and operational rather than aspirational.

4. **Cross-platform capability catalogs** — one file per agent platform
   (`claude_capabilities_catalog.md`, `chatgpt_capabilities_catalog.md`,
   `copilot_capabilities_catalog.md`, `gemini_capabilities_catalog.md`,
   `cursor_capabilities_catalog.md`) cataloguing what each platform supports.
   We don't need this yet but it's a pattern to remember if we expand beyond Copilot.

5. **`.serena/` dir present** — boss is running the Serena MCP server alongside
   Copilot. Not relevant unless we adopt MCP.

### Skill dirs worth a future deep-read (none Stage-2 critical)

- `orchestration-scaffold/` (555-line outlier; LangGraph + OpenCode + Ollama + MCP + SLIs) — closest in spirit to our `SYSTEM-DESIGN.md`.
- `truenas-ops/`, `deploy-pipeline/` — ZFS snapshots, rollback strategies. Backup architecture only.
- `federated-memory/` — maps to our `state-and-handoffs.md`.
- `repo-auditor-pro/` — analogue to our planned `/health-check`.
- `karpathy-trace-infrastructure/` — observability primitives.
- `sre-operations-lead/` — SLOs, runbooks.

## Revised Stage-2 plan (post-research)

The hook spec changes the architecture. Updated tracks:

- **Track A (independent readback)**: ship as a `postToolUse` hook that runs
  `git hash-object --no-filters <path>` for every file touched by the agent and
  compares against the IL entry's recorded hash. Fork structure from `tool-guardian`.
  Exit non-zero on mismatch.
- **Track B (durability modes)**: ship as a `sessionEnd` hook forked from
  `session-auto-commit`, but add:
  - PowerShell pre-commit step: `[IO.FileStream]::Flush($true)` on every modified file.
  - `git -c core.fsync=committed -c core.fsyncMethod=fsync commit` for per-file durability.
  - Optional `per-step-volume-sync` mode invoking Win32 `FlushFileBuffers` via P/Invoke.
- **Track C (external attestation)**: out-of-band restic backup with manifest;
  attestation hook runs at `sessionEnd` after successful auto-commit.
- **Governance/IL chain**: fork `governance-audit` to produce IL entries at
  `userPromptSubmitted` (record planned action) and `postToolUse` (record outcome
  + readback hash). The IL becomes append-only JSON Lines, matching the existing
  `governance-audit/audit.log` pattern.

**Implication for `Libraries/core/validation-and-recovery.md`**: the spec already
describes the layers correctly (durability / integrity / truthfulness). What needs
to change is the **delivery mechanism** — the doc currently implies a `/health-check`
slash-command-driven flow. Rewrite the "How" sections to describe hook-driven
enforcement with `/health-check` as a manual-override audit tool.

## What stays in Libraries/ as a result

No edits this triage. Next planned edits, in order:

1. New file: `Libraries/core/hooks-and-lifecycle.md` — Copilot hook spec, our six
   hook adaptations, JSON schema for our IL entry format. Cite `_research/awesome-copilot/`
   in references, do not import its files verbatim.
2. Edit: `Libraries/core/validation-and-recovery.md` — replace `/health-check`-centric
   enforcement language with hook-driven enforcement; keep `/health-check` as audit-only.
3. Edit: `Libraries/core/state-and-handoffs.md` — link `userPromptSubmitted` /
   `postToolUse` lifecycle to existing state-transition prose.
4. New file: `tools/multi-agent-system/hooks/` — actual Stage-2 hook implementations
   (forked from `tool-guardian`, `session-auto-commit`, `governance-audit`).

## Open questions for user

1. Adopt hook-driven enforcement as the primary Stage-2 delivery mechanism, with
   `/health-check` demoted to audit-only? (Recommended.)
2. Fork the three hooks above into `tools/multi-agent-system/hooks/` under our
   repo, or keep `_research/` as read-only reference and write hooks from scratch
   using their structure as the model? (Forking is faster; from-scratch keeps our
   repo dependency-free of external authorship.)
3. Pull the official hook spec page from
   `https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks`
   into `Libraries/_prior-art/copilot-hooks.md` before we author our own hook docs?
   (Recommended — we cite a moving target otherwise.)
