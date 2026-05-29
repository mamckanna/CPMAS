---
id: azure-architecture-center
name: Azure Architecture Center
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/architecture/
covers: [reference-architectures, design-patterns, application-architectures, scenarios]
agent_use: Cite when selecting or justifying a reference architecture; when matching a workload to an established pattern; or when authoring a `docs/architecture.md` that needs a precedent.
volatility: medium
licensing: proprietary (Microsoft Learn ToU)
last_verified: 2026-05-25
---

# Azure Architecture Center

Microsoft's catalog of reference architectures, design patterns, and architectural decision guides for Azure. The first-stop search when a workload's shape resembles a known pattern.

## Key requirements

- **Prefer a published reference architecture over a bespoke one.** When the workload matches an Architecture Center reference (microservices, event-driven, multi-region web app, AI chatbot, etc.), the Architect cites it and lists deltas in `docs/architecture.md`. Greenfield bespoke architectures require a `decisions.md` entry justifying the divergence.
- **Reference architectures are versioned and dated**: cite the version/date in the Architect's design doc. Reference architectures evolve; a 2-year-old reference is not authoritative.
- **Cloud design patterns are first-class**: Retry, Circuit Breaker, Saga, CQRS, Sidecar, Strangler Fig, etc. Each pattern in the catalog has a "when to use" and "issues and considerations" block. Cite the pattern when implementing it; do not re-derive trade-offs.
- **Decision trees and comparison guides**: the Center publishes "Choose a..." guides (compute, data store, messaging, AI service). The Architect cites the matching guide when picking a service category.
- **AI/ML reference architectures** include baseline OpenAI end-to-end, AKS-hosted chat, baseline RAG with Azure AI Search, agent-orchestration baseline. Use these as the starting point for `project-profile.ai_features != none` workloads.
- **Solution ideas vs reference architectures**: solution ideas are illustrative (architecture diagrams + descriptions); reference architectures are deployable (include IaC, often AVM-based). Cite the more concrete one when available.

## Common misuses

- Citing a "solution idea" as if it were deployable. Solution ideas are starting points; they are not validated for production.
- Mixing patterns from multiple references without naming the composition. Each reference architecture has internal coherence; cherry-picking pieces breaks assumptions.
- Treating reference architectures as immutable. They are starting points; the Architect documents every divergence.

## Notes

- Pairs with `waf` (the design principles applied to references), `avm` (the IaC building blocks references compose), `caf` (the enterprise substrate references deploy into).
- For the AI agent pattern specifically, see the agent-orchestration baseline and pair with `azure-ai-foundry` + `foundry-agent-service`.
