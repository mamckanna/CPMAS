# Prior Art: BMAD-METHOD

## What it is

BMAD-METHOD ("Breakthrough Method of Agile AI-driven Development") is a community-maintained multi-agent workflow for software engineering, distributed as a set of agent role definitions and templates. Repository: [github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD).

## Why it matters

BMAD is the most-cited community example of an explicit **role roster** in agent-driven development. Where Anthropic's patterns describe topologies abstractly, BMAD names the seats at the table (Analyst, PM, Architect, Scrum Master, Developer, QA, etc.) and prescribes the artifacts each owns.

## Role taxonomy (loosely)

| Role | Owns |
|---|---|
| Analyst | Brief, problem framing |
| Product Manager | PRD, prioritization |
| Architect | Technical architecture |
| Scrum Master / PO | Backlog, story decomposition |
| Developer | Implementation |
| QA | Tests, verification |

## What we adopted

- **Named roles, not abstract agents.** Our chat modes (Orchestrator / Architect / Builder / Reviewer) follow BMAD's premise that a role with a clear charter outperforms a "general assistant." We collapse BMAD's six-plus seats into four for sanity.
- **Per-role artifact ownership.** Each of our chat modes lists exactly which paths it writes to. BMAD's per-role artifact templates were the strongest influence here.

## What we did not adopt

- BMAD's full six-plus role count. Most teams don't need a discrete Analyst and a discrete PM; the Architect can do both in a multi-agent system context.
- BMAD's framework choice. BMAD is largely Cline / Claude Code-flavored; our template is VS Code Copilot-native and framework-agnostic at the runtime layer.
- BMAD's heavy templating. We keep templates small and let the chat modes produce the long-form content.

## Cautions

- BMAD is community-maintained; versions move fast and not everything in the repo is canonical.
- The role taxonomy is opinionated. It mirrors a Scrum / Agile shop; teams outside that shape may want a different roster.
