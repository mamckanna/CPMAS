---
id: foundry-agent-service
name: Azure AI Foundry Agent Service
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/ai-foundry/agents/
covers: [agents, threads, tools, runs, knowledge, function-calling]
agent_use: Cite when proposing or reviewing the agent runtime for an MS-stack workload — agent definition, thread/run lifecycle, tool wiring, knowledge sources, and the choice between Foundry Agent Service vs MAF/SK in-process.
volatility: high
licensing: proprietary (Azure consumption)
last_verified: 2026-05-25
---

# Azure AI Foundry Agent Service

The managed agent runtime inside Azure AI Foundry. Provides server-side agent definitions, threads, runs, tool invocation, and knowledge connections — the Azure-native equivalent of OpenAI's Assistants API, integrated with Foundry projects, Content Safety, and managed identity.

## Key requirements

- **Agent definition lives in the service**, not in client code. An agent has a name, instructions (system prompt), model deployment, tool list, knowledge sources, and metadata; it is versioned and addressable by id.
- **Threads + Runs are the conversation model.** A thread holds messages for one user/session; a run executes the agent against a thread and produces tool calls, intermediate steps, and a final assistant message. Clients poll runs or subscribe to streamed events; they do not manage chat history themselves.
- **Tools are declared, not improvised.** Function tools (OpenAPI / JSON-schema), built-in tools (Code Interpreter, File Search, browsing where enabled), and connected tools (Logic Apps, Azure Functions) are registered on the agent. The agent cannot call anything outside its declared toolset.
- **Knowledge via AI Search + File Search** with vector + hybrid retrieval; the retrieval connection authenticates via managed identity and respects the source index's security trimming.
- **Choose runtime deliberately**: Foundry Agent Service for hosted, multi-tenant agents with shared knowledge and centralized policy; in-process MAF or SK (`agent-framework`, `semantic-kernel` in `frameworks/`) when latency, custom orchestration, or single-process state is the constraint. The decision is recorded.
- **Content Safety and evaluations apply per agent** (`azure-ai-foundry`). Jailbreak and protected-material checks run on every run; safety verdicts appear in the run trace.
- **Auth + isolation**: agents are scoped to a Foundry project; cross-project access goes through explicit connections. Callers authenticate with Entra (`entra-id`), and agents call downstream resources via the project's managed identity.
- **Observability**: every run emits a trace (App Insights + Foundry) with tool calls, token usage, latency, and safety verdicts; PII redaction is configured before traces leave the project.

## Common misuses

- Re-implementing thread state in client storage and sending the whole history each turn — defeats the service's caching and exceeds context windows.
- Granting a single agent every tool "to keep it flexible" — expands the attack surface for prompt injection; scope agents narrowly and compose.
- Picking Foundry Agent Service when the workload is one user-facing in-process turn with a custom orchestration graph; MAF or SK is the better fit there.

## Notes

- Pairs with `azure-ai-foundry` (platform), `agent-framework` and `semantic-kernel` (in-process alternatives), `entra-id` + `managed-identity` (auth), `ai-red-teaming` (prompt-injection + tool-misuse testing), `copilot-studio` (low-code surface that can call Foundry agents as skills).
- High volatility: surface area, tool names, and run-event schema are still evolving — re-verify SDK examples at every workload review.
