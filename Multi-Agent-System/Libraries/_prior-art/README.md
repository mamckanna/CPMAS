# Prior Art

Research-only surveys of templates, conventions, and frameworks the multi-agent system stands on. **Not citable** as standards in a Reviewer pass — the citable distillation of any of these lives in `core/`, `governance/`, `microsoft/`, or `frameworks/`.

## Why this folder exists

When designing the multi-agent system, we surveyed real-world prior art and adopted a subset. Keeping the surveys separate from the citable entries does two things:

1. Lets the citable library stay terse and normative.
2. Prevents agents from "citing" a survey or a community pattern as if it were a standard.

## What's in here

| File | What it surveys | What we adopted |
|---|---|---|
| `agents-md.md` | The `AGENTS.md` cross-tool convention | Root entry file; see `core/agents-md.md` |
| `mcp.md` | Model Context Protocol | Tool/resource layer; see `core/mcp.md` |
| `anthropic-patterns.md` | "Building Effective Agents" + Claude sub-agent patterns | Topology taxonomy; see `core/multi-agent-patterns.md` |
| `vscode-customization.md` | VS Code Copilot `.chatmode.md` / `.prompt.md` / `.instructions.md` | Chat-mode roles; see `core/vscode-chat-modes.md` |
| `compound-engineering.md` | The Compound Engineering skill/agent pipeline | Phase-gated flow concept; see `core/multi-agent-patterns.md` |
| `spec-kit.md` | GitHub Spec-Kit | Spec-first kickoff influence |
| `bmad-method.md` | BMAD-METHOD community workflow | Agent role taxonomy influence |
| `frameworks-survey.md` | LangGraph, AutoGen / AG2, OpenAI Agents SDK, CrewAI, Semantic Kernel, Microsoft Agent Framework | Each gets its own citable entry in `frameworks/` |

## How to use

- Designing or revising the multi-agent system itself? Read these.
- Citing a normative requirement in a Reviewer pass? Use a `core/`, `governance/`, `microsoft/`, or `frameworks/` entry instead.
- Found a new pattern worth surveying? Add a file here, then decide whether to promote any of its content into a citable entry.
