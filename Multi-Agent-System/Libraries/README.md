# Libraries

Curated reference library for the multi-agent system template and any tools built on top of it.

This directory is **research and references only**. No code, no builds. Entries here are cited by id from the multi-agent system template (`Project Research/multi-agent-system/template/`) and from any downstream tool.

## How to consume

1. **Find an entry.** Browse by domain folder, or search by `id` across files.
2. **Cite by id.** Agents and humans cite by entry `id` (e.g., `mcsb`, `agents-md`), never by raw URL. The id is stable; the URL may not be.
3. **Read `key_requirements`.** Every entry has a curated `key_requirements:` block with the normative bullets agents should treat as authoritative. If a behavior isn't in `key_requirements`, fetch the source URL or flag uncertainty.
4. **Check `last_verified`.** Entries past their `volatility` renewal cadence (see `_schema/conventions.md`) need re-verification before being cited in a Reviewer pass.

## Directory layout

```
Libraries/
3. **Read `key_requirements`.** Every entry has a curated `key_requirements:` block with the normative bullets agents should treat as authoritative. If a behavior isn't in `key_requirements`, fetch the source URL or flag uncertainty. For validation and recovery, cite the relevant PowerShell hook or test script by file name (e.g., `hooks/sessionStart.ps1`, `test-stress.ps1`).
4. **Check `last_verified`.** Entries past their `volatility` renewal cadence (see `_schema/conventions.md`) need re-verification before being cited in a Reviewer pass.
├── _prior-art/                ← research surveys (not citable as standards)
├── core/                      ← every multi-agent project needs these
├── governance/                ← AI/LLM governance, used by most projects
A Reviewer `pass` verdict requires at least one citation per check pass, including for validation, durability, and recovery logic.
- Cite by `id` for library entries, and by file name for PowerShell hooks and test scripts (e.g., `hooks/postToolUse.ps1`, `test-errorOccurred.ps1`). Never invent URLs.
- A Reviewer `pass` verdict requires at least one citation per check pass, including for validation, durability, and recovery logic.
- A `key_requirements` bullet trumps the agent's training. If the two disagree, the bullet wins.
- If `last_verified` is past cadence, the citation is downgraded to a `warn`, not a `pass`.
- `_prior-art/` content is **research only** and is not a valid citation in a Reviewer pass.
- Cite by `id`. Never invent URLs.
- A Reviewer `pass` verdict requires at least one citation per check pass.
- A `key_requirements` bullet trumps the agent's training. If the two disagree, the bullet wins.
- If `last_verified` is past cadence, the citation is downgraded to a `warn`, not a `pass`.
- `_prior-art/` content is **research only** and is not a valid citation in a Reviewer pass.

## Index

| Folder | Purpose | Citable? |
|---|---|---|
| `_schema/` | Entry shape, naming conventions, renewal cadence | no |
| `_prior-art/` | Surveys of templates and patterns we drew from | no |
| `core/` | MCP, agents.md, multi-agent patterns, VS Code surface, state & handoffs, compaction & recovery, validation & recovery | yes |
| `governance/` | OWASP LLM Top 10, NIST AI RMF, RAI principles, prompt-injection defenses | yes |
| `microsoft/` | 37 entries across architecture (WAF, CAF, AVM, AAC, ALZ + Azure SQL, PostgreSQL Flex, Cosmos DB, App Service, AKS, Service Bus, App Insights, Log Analytics), security (SFI, SDL, MCSB, Entra, Key Vault, MI, Zero Trust, Defender), governance (MS RAI, MS Privacy, RAI Toolbox, AI Red-Teaming, MS Accessibility, MS OSS Policy), build (GH Adv Sec, ADO, Bicep, Pipelines, Actions), docs (MS Style, MS Learn), agents (Foundry, Foundry Agent Service, Copilot Studio) | yes |
| `frameworks/` | LangGraph, AutoGen, OpenAI Agents SDK, CrewAI, Anthropic subagents, SK, MAF | yes |
| `tools/<tool>/index.md` | Curated id subsets per consumer | no (it's a list of ids) |
| `expert-repos/` | Curated expert coding repositories and patterns | yes |
| `expert-repos/index.md` | Index of expert-level curated repositories by language/domain | yes |
- `tools/multi-agent-system/hooks/sessionStart.ps1`: Enforces fsync durability, backup/attestation, independent-process readback, automated handoff/resume, and operator summary reporting at session start. All logic is refactored for reuse.
- `tools/multi-agent-system/hooks/postToolUse.ps1`: Enforces integrity and truthfulness after tool use, with fsync, backup, and independent readback. Shares reusable logic with sessionStart.
- `tools/multi-agent-system/hooks/errorOccurred.ps1`: Triggers recovery, logs integrity state, and performs backup/readback on error. Shares reusable logic with other hooks.
- `tests/hooks/test-sessionStart.ps1`, `test-postToolUse.ps1`, `test-errorOccurred.ps1`: Edge case and validation tests for each hook, covering normal, missing, empty, corrupted, and locked file scenarios.
- `tests/hooks/test-stress.ps1`: Stress test for large files, rapid-fire runs, and permission errors.

## Provenance

This library was bootstrapped from the working references in `Project Research/references/*.references.md` and from the research embodied in Reports 01–03 in `Project Research/concepts/`. Both remain as historical sources; `Libraries/` supersedes them for citation purposes going forward.
