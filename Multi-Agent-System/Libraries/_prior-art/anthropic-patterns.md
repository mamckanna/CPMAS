# Prior Art: Anthropic Multi-Agent Patterns

## What it is

Two interlocking bodies of work from Anthropic:

1. **"Building Effective Agents"** (Anthropic engineering blog, Dec 2024) — a taxonomy of agentic patterns ordered from simplest to most autonomous.
2. **Claude Code sub-agents** (Anthropic docs) — operational guidance on splitting work across specialist sub-agents with isolated context windows.

Together these are the most-cited reference for "how to actually structure a multi-agent system" at the design level (as opposed to the framework level, which is LangGraph/AutoGen/Agents SDK).

## The pattern taxonomy (loosely)

| Pattern | Shape | When to use |
|---|---|---|
| **Augmented LLM** | One LLM + tools + memory + retrieval | Most tasks. Start here. |
| **Prompt chaining** | Sequence: A → B → C, each step's output is next step's input | Decomposable tasks with clear stages |
| **Routing** | Classifier picks one of N specialist prompts | Mixed-input task streams |
| **Parallelization** | Same task fanned out (voting) or different sub-tasks fanned out (sectioning) | Independent sub-work or robustness via voting |
| **Orchestrator-workers** | A planner LLM dispatches to dynamically-chosen workers | Tasks where sub-tasks aren't known up front |
| **Evaluator-optimizer** | Generator + critic loop until critic passes | Tasks with checkable quality criteria |
| **Autonomous agent** | LLM in a loop with tools, environment, and feedback | Open-ended work; use sparingly |

## Sub-agent guidance (from Claude Code docs)

- Each sub-agent has its **own system prompt** and **its own tool allow-list**.
- Each sub-agent has an **isolated context window** — the parent doesn't share its full context, just a task brief.
- Sub-agents are **stateless** between invocations.
- The parent orchestrator owns the plan and the merging of results.

## What we adopted

- The **orchestrator-workers** pattern as the default topology.
- **Isolated context per role** (Orchestrator / Architect / Builder / Reviewer each have their own chat-mode system prompt).
- **Tool allow-lists per role** (each `.chatmode.md` has a `tools:` field).
- **Stateless sub-tasks** via `.github/prompts/*.prompt.md`.
- **Evaluator-optimizer** as the local pattern inside the Build phase (Builder produces; Reviewer evaluates; loop until pass).

The citable distillation lives in [`../core/multi-agent-patterns.md`](../core/multi-agent-patterns.md).

## What we did not adopt (yet)

- **Autonomous-agent-in-a-loop** at the top level. Our default keeps a human at phase gates. The Anthropic guidance explicitly says to use autonomous loops sparingly; we agree.
- **Programmatic sub-agent dispatch.** Claude Code supports it natively; VS Code Copilot doesn't (as of mid-2026) for user-authored chat modes. We approximate via mode-switching + stateless prompts.

## Cautions

- Patterns are not frameworks. A pattern tells you the shape; you still need a framework (or hand-rolled code, or a host like VS Code Copilot) to run it.
- "More agents" is rarely the answer. The Anthropic guidance is explicit: start with augmented-LLM, only add complexity when measurably needed.
