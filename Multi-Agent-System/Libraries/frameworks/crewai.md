---
id: crewai
name: CrewAI
category: framework
authority: vendor
url: https://docs.crewai.com/
covers: [role-based-agents, crew, task-decomposition, python]
agent_use: Cite when a project picks CrewAI as its agent runtime, or when modeling a small, role-clear team of agents.
volatility: high
licensing: open (MIT) with paid hosted offering
last_verified: 2026-05-25
---

# CrewAI

A Python framework for modeling agentic work as a **crew** of role-based agents working through a list of tasks. Opinionated toward small crews (3–7 agents) with clear roles and a designated process (sequential or hierarchical).

## Key requirements

- Define each agent with a **role**, a **goal**, and a **backstory**. Roles drive the crew's coordination; goals drive task selection; backstories shape voice.
- Define **tasks** with explicit inputs, expected outputs, and the agent responsible. Tasks are first-class; agents are second-class.
- Pick a **process**: `sequential` for ordered task lists, `hierarchical` for a manager-agent dispatching to workers. Default to sequential.
- Cap **max iterations per agent** explicitly; CrewAI's agents will retry by default and can loop.
- Use the framework's **memory** modules (short-term, long-term, entity) rather than hand-rolled persistence.
- Apply tool allow-lists at the agent level. Do not share tool sets indiscriminately across the crew.
- For production, instrument with the framework's telemetry hooks; do not run blind.

## Common misuses

- Modeling 15-agent crews. CrewAI works best at the 3–7 scale; larger crews lose the role clarity that makes the framework useful.
- Skipping `max_iter` because the default "feels fine." Defaults vary by version; pin explicitly.
- Treating CrewAI as a graph framework. It isn't — for state-graph shapes, use LangGraph.

## Notes

- CrewAI ships a paid hosted platform (CrewAI+); the open-source library is independent of it. Pick one explicitly.
- Best fit: small, role-clear, task-decomposable workflows. Poor fit: state-heavy graphs, deep handoff chains, large-scale production multi-agent.
