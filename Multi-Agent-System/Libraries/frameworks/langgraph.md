---
id: langgraph
name: LangGraph
category: framework
authority: vendor
url: https://langchain-ai.github.io/langgraph/
covers: [state-graph, multi-agent-runtime, checkpointing, human-in-the-loop, python, javascript]
agent_use: Cite when a project picks LangGraph as its agent runtime, when designing graph state, or when reviewing checkpointer / persistence choices.
volatility: high
licensing: open (MIT)
last_verified: 2026-05-25
---

# LangGraph

LangChain's framework for building stateful, multi-agent applications as explicit graphs. Python and JavaScript. The most-used framework when the project needs a debuggable, persistable state machine.

## Key requirements

- Model the agent system as a **state graph**: nodes are functions, edges are transitions, state is an explicit typed object that flows between nodes.
- Use the **typed state** pattern (e.g., `TypedDict` in Python). Untyped state defeats the framework's debugging value.
- Use a **checkpointer** for any production graph. Without one, runs are not resumable and human-in-the-loop is impossible. Standard checkpointers: in-memory (dev), SQLite, Postgres.
- For multi-agent, use **subgraphs**, not nested orchestration in node functions. Subgraphs compose; nested orchestration doesn't.
- Use **interrupts** for human-in-the-loop, not custom polling. Interrupts integrate with the checkpointer.
- Stream node outputs to the client; do not buffer multi-step runs into a single response.
- Tools should be standard LangChain `Tool` or MCP-published tools. Avoid hand-rolled tool schemas.
- Long-running graphs need **time-bounded nodes** — no node should be allowed to run indefinitely without a cancellation path.
- Pair with **LangSmith** (or OpenTelemetry) for tracing in production. Trace-less LangGraph is a debugging trap.

## Common misuses

- Using LangGraph for what an augmented LLM would do fine. The framework's value is state and graph debuggability; if you don't need either, you're paying complexity for nothing.
- Skipping the checkpointer in dev "because it's just dev." Then you can't reproduce the bug you're debugging.
- Putting heavy logic inside conditional edges. Edges should be simple predicates; logic belongs in nodes.

## Notes

- High volatility: API surface evolves; pin versions in production.
- For Microsoft-stack .NET projects, prefer Microsoft Agent Framework (`microsoft-agent-framework`) over LangGraph unless the team is already Python-first.
