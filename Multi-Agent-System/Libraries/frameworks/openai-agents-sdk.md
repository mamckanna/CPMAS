---
id: openai-agents-sdk
name: OpenAI Agents SDK
category: framework
authority: vendor
url: https://openai.github.io/openai-agents-python/
covers: [handoffs, guardrails, sessions, tracing, python, typescript]
agent_use: Cite when a project picks the OpenAI Agents SDK as its agent runtime, or when designing handoff-based multi-agent flows.
volatility: high
licensing: open (MIT)
last_verified: 2026-05-25
---

# OpenAI Agents SDK

OpenAI's official framework for building multi-agent systems on top of the OpenAI Responses API (and compatible providers). Python is GA; TypeScript is in active development. The recommended runtime when the team is OpenAI-stack and wants the simplest production path.

## Key requirements

- Model multi-agent coordination as **handoffs**: an agent can hand control to another agent via a tool-form handoff. The receiving agent gets a fresh context (with optional input filter).
- Define each agent with a **system prompt**, a **tool list**, and an optional **handoff list**. Keep agent definitions terse.
- Use **guardrails** for input/output validation. Guardrails run in parallel with the main agent and can short-circuit a run.
- Use **sessions** for memory across runs; do not hand-roll conversation state.
- Use the SDK's built-in **tracing** in development. Disable or scope it carefully in production for privacy.
- Apply **input filters** on handoffs when the receiving agent should not see the sender's full context (the default is to pass it).
- Schema-validate tool arguments — the SDK enforces this; do not subvert it.

## Common misuses

- Building deep handoff chains. Handoffs are cheap to declare but expensive to debug at depth — keep chains short and prefer orchestrator-worker shapes.
- Reusing one agent definition for multiple purposes by toggling tools. Define separate agents; clarity beats cleverness.
- Skipping guardrails on user-facing agents. The SDK's guardrail surface is the cheapest way to add a safety check.

## Notes

- The SDK supports non-OpenAI models via the Responses API's compatible-provider story, but feature coverage varies. Test on your target provider.
- For .NET-native projects, prefer Microsoft Agent Framework (`microsoft-agent-framework`).
- For graph-shaped flows (not handoff-shaped), prefer LangGraph (`langgraph`).
