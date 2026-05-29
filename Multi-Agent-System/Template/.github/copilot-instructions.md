# Copilot Instructions (repo-wide)

> Loaded on every Copilot turn in this repo. Keep this file short. Put scoped rules in `.github/instructions/*.instructions.md`.

## Project facts

- **Stack:** <fill in: e.g., .NET 8 + Bicep + GitHub Actions>
- **Owner:** <fill in>
- **Audience:** Microsoft internal / public OSS / customer-facing — pick one.

## Multi-agent system in use

This repo runs a **23-mode multi-agent system** (14 baseline + 9 conditional roles) with a 10-phase queue. The authoritative description is `AGENTS.md` + `Design/SYSTEM-DESIGN.md` (in the source `Multi-Agent-System/` workspace).

Before doing any non-trivial work, **every turn**:

1. **Pre-flight** — read `.agents/state/checkpoint.md`. If integrity check fails, stop and run `/recover`.
2. Read `.agents/state/handoff.md`, `plan.md`, and (after Concept gate) `role-manifest.md` + `artifact-manifest.md`.
3. Confirm the active chat mode matches `checkpoint.expected_next_agent`. Do not blend roles.
4. Follow that mode's system prompt verbatim.
5. End turn by writing `handoff.md` and bumping `checkpoint.md` (`turn_token` + 1).

If you are a **conditional role** (RAI / Data Steward / Accessibility / FinOps / Legal / Product / UX Researcher / QA / Support), additionally confirm your role name is in `role-manifest.conditional_active`. If not, refuse work and route back to Orchestrator.

## Non-negotiables

1. **No fabricated references.** Every cited doc, URL, standard, or best practice must resolve to an entry `id` in `Libraries/`. Missing citation → route to Librarian. Do not guess URLs.
2. **No secrets in code.** Use managed identity / Key Vault. Hardcoded credentials are a blocker.
3. **No new dependencies without a decision entry.** Adding a dep requires an append to `.agents/state/decisions.md` with rationale and a Library `id`.
4. **State writes are mandatory.** End every meaningful turn by updating `handoff.md` + `checkpoint.md`. Append (never overwrite) to `decisions.md`, `artifacts.md`, `validation-log.md`, `review-log.md`.
5. **Append-only logs are append-only.** Never edit a prior `D-NNN` / `V-NNN` / `REV-NNN` / `G-NNN` entry. Supersede with a new entry that cites the old one.
6. **Locked files are locked.** `project-profile.md` (locked at `/kickoff`), `role-manifest.md` (locked at Concept gate), `artifact-manifest.md` (locked at Plan gate). Only the documented prompts (`/profile`, `/phase-gate`) may re-lock.
7. **No artifact bypasses Validator.** Every Build artifact passes the three-pass gate (`V-NNN`) before Reviewer + domain reviewers see it.
8. **No misformed artifacts.** Runtime features are code in the declared format/extension, not `.docx` / `.pdf` / `.pptx`. The Audit gate refuses these where the manifest says otherwise.
9. **Migration archives, never deletes.** Files marked `discard` or superseded move to `archive/`. No `Remove-Item` / `rm` on legacy artifacts.
10. **Microsoft-first when MS-owned.** When `project-profile.ms_stack in {preferred, required}` and an MS source and a non-MS source cover the same topic, prefer the MS source unless a `D-NNN` decision says otherwise.

## Output style

- Be brief. Long preamble is noise.
- Use markdown tables for comparisons and decision matrices.
- Use Mermaid for diagrams (not ASCII art).
- Prefer code over prose when the user asked for code.
- Cite Library entries by `id` (e.g., `agents-md`, `mcp`, `owasp-llm-top10`). The reader resolves URLs from the entry frontmatter.

## Tooling

- MCP servers registered in `.vscode/mcp.json` are the canonical tool surface. Prefer them over shell commands when both are available.
- Terminal use: PowerShell on Windows; cross-platform shell syntax otherwise.
- Honor each chat mode's `tools:` allow-list. Read-only modes (Librarian, Validator, Reviewer, Compliance Officer in audit) must not write outside their declared state files.
