---
id: microsoft-agent-framework
name: Microsoft Agent Framework
category: framework
authority: vendor
url: https://learn.microsoft.com/agent-framework/
covers: [workflow-agents, dotnet, python, durable-agents, multi-agent-orchestration]
agent_use: Cite when a Microsoft-stack project picks Microsoft Agent Framework as its agent runtime, particularly .NET-native services that need durable multi-agent orchestration.
volatility: high
licensing: open (MIT) where source-available
last_verified: 2026-05-25
---

# Microsoft Agent Framework (MAF)

Microsoft's first-party framework for building agent-based applications, focused on .NET (with Python support). Designed for durable, observable, enterprise-grade multi-agent systems. The recommended path for new Microsoft-internal agent work as of mid-2026.

## Key requirements

- Define agents with an **agent type** (chat-completion, workflow, or composite) and a system prompt. The framework provides base implementations.
- Compose agents into **workflows** when the coordination is graph-shaped. Workflows are durable: state survives process restarts.
- Use **agent threads** for conversational state and **workflow state** for orchestration state. Don't conflate them.
- Plug into Microsoft observability: OpenTelemetry traces, Azure Monitor / Application Insights. Production MAF without instrumentation is a misuse.
- For tool integration, use **AI Functions** (.NET) or MCP (`mcp`). MAF supports both; pick MCP for cross-host portability.
- For identity, use **Managed Identity** via `DefaultAzureCredential`. Never embed keys.
- For state persistence, use the framework's durable-workflow store (Azure-backed in production; in-memory in dev).
- Apply **cost budgets** at the workflow level. Long-running multi-agent workflows are a cost risk.

## Common misuses

- Treating MAF as a SK replacement. They overlap but target different shapes; MAF for agent-first systems, SK for LLM features inside existing apps (`semantic-kernel`).
- Using MAF outside the Microsoft stack. It's portable in principle but the value-add is the Microsoft integration; if you're not on Azure / .NET / Entra, the value proposition is weaker.
- Skipping durability "because we don't need it yet." Adding durability after the fact is painful; design for it from the start.

## Notes

- High volatility: MAF is newer than SK and the API surface continues to evolve. Pin versions and re-verify quarterly.
- Cross-linked from `microsoft/microsoft-agent-framework.md` (placeholder when populated) for Microsoft-first navigation.
- See [`../_prior-art/frameworks-survey.md`](../_prior-art/frameworks-survey.md) for the side-by-side with non-Microsoft frameworks.
