# Prior Art: Agentic Frameworks Survey

A side-by-side survey of the runtime frameworks an agentic project might pick. Each gets its own citable entry in `frameworks/` — this file is the **comparison**, not the citation source.

## Frameworks in scope

| Framework | Owner | Primary language | Topology bias | Maturity |
|---|---|---|---|---|
| **LangGraph** | LangChain | Python / JS | Explicit state graph | Mature |
| **AutoGen / AG2** | Microsoft Research / community fork | Python | Conversational multi-agent | Mature; AG2 is the community-led fork |
| **OpenAI Agents SDK** | OpenAI | Python (TS in preview) | Handoffs-as-tool | Mature |
| **CrewAI** | crewAI Inc. | Python | Role-based "crew" | Mature |
| **Semantic Kernel** | Microsoft | C# / Python / Java | Plugin + planner | Mature; first-party MS |
| **Microsoft Agent Framework (MAF)** | Microsoft | C# / Python | Workflow + agent composition | Newer; first-party MS, .NET-native focus |
| **Anthropic sub-agents (Claude Code)** | Anthropic | n/a (host feature) | Orchestrator + isolated sub-agents | Mature for Claude Code |

## Side-by-side

| Concern | LangGraph | AutoGen | Agents SDK | CrewAI | SK | MAF | Claude sub-agents |
|---|---|---|---|---|---|---|---|
| State model | Explicit graph state | Conversational thread | Run state object | Crew memory | Memory store + plan state | Workflow state | Per-sub-agent context |
| Sub-agent dispatch | Edges + tool calls | Agent-to-agent messages | Tool-form handoffs | Crew config | Function calls | Workflow steps | Parent invokes sub-agent |
| Tool integration | Any callable | Any callable | OpenAI tool schema + MCP | Any callable | Plugins + MCP | Plugins + MCP | Claude tools + MCP |
| Long-running | Persistable checkpointer | Group chats | Sessions | Crew runs | Persistable | Durable workflows | Conversation threads |
| Eval hooks | LangSmith integration | Built-in agentchat eval | Built-in tracing | Crew telemetry | Telemetry + eval | Built-in eval | Claude evals |
| First-class for | Complex stateful flows | Conversational research/dev | Production-grade tools + handoffs | Role-based small crews | Enterprise .NET + Python | Enterprise .NET-native | Claude Code projects |

## Picking one

The multi-agent system template is **framework-agnostic** by design — the chat modes, prompts, and state files don't require any of these. A project picks a framework only when it needs to run agents programmatically outside a chat host. Rough guidance:

| If your project... | Lean toward |
|---|---|
| Is .NET-first / Microsoft-internal | Microsoft Agent Framework, then Semantic Kernel |
| Needs explicit, debuggable state machines | LangGraph |
| Needs conversational research/exploration agents | AutoGen / AG2 |
| Is OpenAI-stack and wants the simplest production path | OpenAI Agents SDK |
| Is small, role-clear, crew-shaped | CrewAI |
| Lives entirely inside Claude Code | Claude sub-agents |
| Lives entirely inside VS Code Copilot Chat | None — the chat modes are your runtime |

## Cautions

- "Framework choice" is high-volatility. The space is moving fast; what's mature today may be superseded in 6 months.
- A framework is not a multi-agent system. It's plumbing. You still need the role definitions, state model, and gates the template provides.
- Don't pick more than one. Mixing frameworks in the same project produces brittle integrations and confused agents.
