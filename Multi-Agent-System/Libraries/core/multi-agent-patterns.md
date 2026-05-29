---
id: multi-agent-patterns
name: Multi-agent design patterns
category: core
authority: vendor
url: https://www.anthropic.com/research/building-effective-agents
covers: [orchestrator-worker, routing, parallelization, evaluator-optimizer, prompt-chaining, sub-agents]
agent_use: Cite when choosing or justifying a multi-agent topology, when an Architect or Orchestrator proposes adding roles, or when reviewing whether a system's complexity is warranted.
volatility: low
licensing: open (documentation)
last_verified: 2026-05-25
---

# Multi-agent design patterns

Canonical taxonomy from Anthropic's "Building Effective Agents" and Claude sub-agent documentation. The reference taxonomy used by the multi-agent system template.

## Key requirements

- Start with the **augmented LLM** (one model, tools, memory, retrieval). Add complexity only when measurably needed.
- For decomposable tasks with stable stages, use **prompt chaining**: each step's output is next step's input.
- For mixed input streams, use **routing**: a classifier selects one of N specialist prompts.
- For independent sub-work or robustness via voting, use **parallelization** (sectioning or voting).
- For tasks where sub-tasks are not known up front, use **orchestrator-workers**: a planner dispatches to dynamically chosen workers.
- For tasks with checkable quality criteria, use **evaluator-optimizer**: generator + critic loop until the critic passes.
- Reserve **autonomous-agent-in-a-loop** for open-ended work with strong guardrails; prefer human gates at major decisions.
- Sub-agents must have **isolated context windows** (the parent does not share its full context, just a task brief).
- Sub-agents must have **explicit tool allow-lists** (each role gets only the tools it needs).
- Sub-agents are **stateless between invocations**; persistent state lives in shared files or external stores, not in conversation history.
- The orchestrator owns the plan and the merge of results. Workers do not call each other; they return to the orchestrator.
- Keep the agent count low. More agents is rarely the answer; it usually means the role definitions are not crisp.

## Common misuses

- Spawning sub-agents for sub-tasks the augmented-LLM pattern handles fine. Pay the complexity cost only when a single agent demonstrably struggles.
- Letting workers talk to workers. That creates implicit topology that is hard to debug; always go through the orchestrator.
- Sharing the orchestrator's full context with workers. Workers should get a minimal brief, not the whole thread.
- Treating "autonomous agent" as the default. Most production work benefits from human gates between phases.

## Notes

- See [`../_prior-art/anthropic-patterns.md`](../_prior-art/anthropic-patterns.md) for the broader survey.
- The multi-agent system template implements **orchestrator-workers** at the top level (Orchestrator + Architect/Builder/Reviewer) and **evaluator-optimizer** locally inside the Build phase (Builder generates, Reviewer evaluates).
