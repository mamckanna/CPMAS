# Multi-Agent System

A self-contained standard for running multi-agent AI software projects inside VS Code (and any agents.md-compatible host).

This project defines:

1. **The system design** — agent roles, phase gates, state model, recovery protocol, migration workflow.
2. **A curated reference library** — every standard, framework, and convention the system cites, by stable id.
3. **A drop-in template** — copyable scaffold that turns any VS Code workspace into a multi-agent project.

## Layout

```
Multi-Agent System/
├── README.md            ← you are here
├── Design/              ← how the system works
│   └── SYSTEM-DESIGN.md
├── Setup/               ← how to install it into a project
│   ├── SETUP.md
│   └── CHECKLIST.md
├── Template/            ← the drop-in files
│   ├── AGENTS.md
│   ├── .github/         ← chat modes (23), prompts (8), instructions
│   ├── .vscode/         ← MCP config
│   └── .agents/         ← state templates
└── Libraries/           ← curated references the template cites
    ├── README.md
    ├── _schema/
    ├── _prior-art/
    ├── core/
    ├── governance/
    ├── frameworks/
    ├── microsoft/       ← populated per Microsoft-owned project
    └── tools/
```

## Read order

| If you want to... | Start with |
|---|---|
| Understand the system | `Design/SYSTEM-DESIGN.md` |
| Install it into a project | `Setup/SETUP.md` |
| See what's required after install | `Setup/CHECKLIST.md` |
| Look up a reference id | `Libraries/README.md`, then the relevant domain folder |
| Survey the prior art the system stands on | `Libraries/_prior-art/` |
| Author a new reference entry | `Libraries/_schema/entry-schema.md` + `_schema/conventions.md` |

## Core design choices

- **23 chat modes**: 14 baseline (always-on) + 9 conditional (activated by Project Profile). The baseline covers Orchestrator, Architect, Builder, Reviewer, Librarian, Validator, Security Engineer, Privacy Engineer, Compliance Officer, Documenter, Database Engineer, SRE, Release Manager, Maintainer. Conditional roles (RAI, Data Steward, Accessibility, FinOps, Legal, Product, UX Researcher, QA, Support) refuse work unless listed in `role-manifest.conditional_active`.
- **10-phase queue**: References (recurring) → Concept → Architecture → Design → Plan → Build → Operate → Release → Audit, with Maintain as a perpetual sibling phase. Explicit human gates at Concept, Plan, Release, and Audit.
- **File-based state under `.agents/state/`**: 9 markdown files. Append-only logs (decisions, artifacts, validation-log, review-log); locked declarative files (project-profile, role-manifest, artifact-manifest); overwriting handoff payload; integrity-checkpoint header.
- **Artifact Manifest gate**: every Build artifact is declared by path, expected format, must/must-NOT properties, produced_by, validated_by, reviewed_by before Build starts. The Plan gate locks the manifest; the Audit gate compares disk to manifest.
- **Validator three-pass gate**: every artifact passes Validator (existence + format + content checks) and produces a `V-NNN` entry in `validation-log.md` before Reviewer (and domain reviewers per `reviewed_by`) see it.
- **Migration workflow**: projects with `migrating_from != none` (Copilot 365, ChatGPT, Edge Copilot, Claude, Gemini web, ...) follow a 6-phase Inventory → Reconciliation → Plan → Execute → Retire → Audit flow that converts misformed artifacts (e.g., `.docx`) into manifest-compliant ones. Archive, never delete.
- **8 prompt files** under `.github/prompts/`: `/kickoff`, `/handoff`, `/phase-gate`, `/migrate-existing`, `/validate`, `/profile`, `/recover`, `/health-check`.
- **MCP as the canonical tool surface**, registered in `.vscode/mcp.json`.
- **References cited by `id` only**. URLs live in entry frontmatter; agents never invent URLs. Missing citation → routed to Librarian, no exceptions.
- **Microsoft-first when the project is Microsoft-owned**, fully optional otherwise.

## Host requirement

This template assumes an agents.md-compatible host that supports:

- Per-mode chat modes with YAML frontmatter (`description`, `tools` allow-list).
- Per-mode tool allow-lists enforced by the host.
- Slash-prompt files (`*.prompt.md`) discoverable by the chat surface.
- Per-workspace MCP server registration.

VS Code Copilot Chat is the reference host. Any host with equivalent surfaces (chat modes, slash prompts, MCP) can drive this template; agents.md is the cross-host contract.

## Provenance

- Originally researched in `Project Research/` (Reports 01–03 and the working reference files). That directory remains as the historical source; this project is now the authoritative home.
- The template was originally copied from `Project Research/multi-agent-system/template/` and has since been rewritten end-to-end (chatmodes, prompts, state templates, design doc) to enforce the manifest + validation + migration model.

## Status

| Component | State |
|---|---|
| Design doc (`Design/SYSTEM-DESIGN.md`) | Current (v2). Covers 14 baseline + 9 conditional roles, 10-phase queue, Project Profile + Role Manifest + Artifact Manifest, Validator gate, Migration workflow. v1 preserved as `.v1.bak`. |
| Setup docs (`Setup/`) | Current. Reflects expanded scaffold (23 chatmodes, 8 prompts, 9 state files). |
| Template — chat modes | 23 chatmodes (14 baseline + 9 conditional). All have mandatory pre-flight; conditional roles enforce activation-gate. |
| Template — prompts | 8 prompts (`/kickoff`, `/handoff`, `/phase-gate`, `/migrate-existing`, `/validate`, `/profile`, `/recover`, `/health-check`). |
| Template — state templates | 10 files: `checkpoint`, `plan`, `decisions`, `artifacts`, `handoff`, `validation-log`, `project-profile`, `role-manifest`, `artifact-manifest`, plus `README.md` + `review-log.md` initialized by Setup. |
| Libraries — `_schema/`, `_prior-art/`, `core/`, `governance/`, `frameworks/`, `tools/multi-agent-system/` | Done. |
| Libraries — `microsoft/` | Empty by design. Populated per project when an MS-owned project adopts the template. |

## What this project is *not*

- Not a runtime framework. It uses VS Code Copilot Chat (or any agents.md-compatible host) as the runtime, and any of the frameworks listed in `Libraries/frameworks/` for code that runs outside the chat host.
- Not a product. It is a standard + scaffold for use across projects.
- Not Microsoft-exclusive. It supports Microsoft-first when applicable; it is fully usable in non-Microsoft projects by omitting `Libraries/microsoft/` references.
