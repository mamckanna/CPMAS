---
id: semantic-kernel
name: Semantic Kernel
category: framework
authority: vendor
url: https://learn.microsoft.com/semantic-kernel/
covers: [plugins, planners, agents, dotnet, python, java]
agent_use: Cite when a project picks Semantic Kernel as its agent runtime — particularly .NET-first Microsoft projects — or when integrating LLM features into an existing enterprise codebase.
volatility: medium
licensing: open (MIT)
last_verified: 2026-05-25
---

# Semantic Kernel

Microsoft's open-source SDK for integrating LLM features into applications. Supports C#, Python, and Java. Mature, enterprise-oriented, with strong integration into Microsoft's stack (Azure OpenAI, Azure AI Search, Entra, Application Insights).

## Key requirements

- Model LLM-callable capabilities as **plugins** (collections of kernel functions). Each function has a typed signature and a description used by the model.
- Use **automatic function calling** (the kernel decides when to invoke plugins) for most cases. Manual function selection is for narrow cases.
- For multi-agent flows, use the **Agent Framework** module inside SK (note: not the same as the separate Microsoft Agent Framework product — see `microsoft-agent-framework`). The SK Agent Framework provides `ChatCompletionAgent`, group chat, and orchestration.
- Use **prompt templates** with the `{{$variable}}` syntax for parameterized prompts; do not concatenate strings.
- Use SK's **memory** abstractions (semantic memory, vector store connectors) rather than hand-rolled persistence.
- Wire **OpenTelemetry** / Application Insights from the start; SK has first-class instrumentation hooks.
- For Microsoft Entra-protected resources, use Managed Identity through `DefaultAzureCredential`, not connection strings.
- Pin the SK package version explicitly. SK has had breaking changes across major versions; do not float.

## Common misuses

- Hand-rolling prompt assembly when prompt templates exist. Defeats the framework's traceability.
- Using SK as a generic HTTP client to call LLMs. Use the kernel and plugins or you're paying complexity for nothing.
- Mixing SK 1.x and 2.x patterns in the same project. The agent surface changed; pick the current major version.

## Notes

- For new MS-internal .NET projects evaluating between SK and Microsoft Agent Framework (`microsoft-agent-framework`), the rough split is: **MAF** for new agent-first systems, **SK** for adding LLM features to existing enterprise apps. Both can coexist; MAF is built on top of SK abstractions in .NET.
- Microsoft-first projects also see this entry cross-linked from `microsoft/semantic-kernel.md` (placeholder when populated).
