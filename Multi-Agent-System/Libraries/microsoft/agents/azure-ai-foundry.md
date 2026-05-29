---
id: azure-ai-foundry
name: Azure AI Foundry
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/ai-foundry/
covers: [models, projects, hubs, evaluations, deployments, content-safety]
agent_use: Cite when proposing or reviewing the platform layer for an MS-stack AI/agent workload — model catalog choice, hub/project topology, deployment SKUs, evaluation, content safety, and observability for AI workloads on Azure.
volatility: high
licensing: proprietary (Azure consumption)
last_verified: 2026-05-25
---

# Azure AI Foundry

Microsoft's unified platform for building, evaluating, deploying, and operating AI applications on Azure. The default platform layer for MS-stack AI workloads — superset of the former Azure AI Studio + Azure OpenAI portal surfaces, with a model catalog, project workspaces, evaluation tooling, and integrated content safety.

## Key requirements

- **Hub / Project topology is the canonical structure.** A hub holds shared resources (storage, Key Vault, AI Search, connections, compute quota); projects are the per-team or per-workload workspaces inside it. Provision via Bicep / AVM, not click-ops.
- **Use the model catalog, not ad-hoc deployments.** Foundation models are selected from the catalog (OpenAI, Mistral, Meta, Phi, Cohere, etc.); deployment SKU (Standard, Provisioned Throughput Units, Global vs Data Zone) is a deliberate cost + latency + sovereignty decision and is recorded in `decisions.md`.
- **Managed identity for every connection.** Connections from Foundry to Storage, AI Search, Cosmos, Key Vault, and downstream APIs authenticate via managed identity (`managed-identity`); API keys in connections are findings.
- **Content Safety is wired in front of generative endpoints** (input + output filters, jailbreak and protected-material detectors) and tuned per workload risk tier. Disabling filters requires an exception with named approver.
- **Evaluations run before promotion.** Built-in evaluators (groundedness, relevance, fluency, safety) and custom evaluators run against a versioned dataset; results are stored with the model + prompt version. No production promotion without an evaluation run on the candidate.
- **Observability via Application Insights + Foundry tracing.** Every request emits a trace with prompt, tool calls, token counts, latency, and safety verdicts; PII redaction is configured before traces leave the project.
- **Networking matches the host workload.** Private endpoints for the hub, customer-managed VNet for compute, and disable public network access in production. See `azure-landing-zones`.
- **Cost controls per project**: per-deployment quotas, PTU vs Standard chosen for predictability, budgets + alerts on the project's resource group.

## Common misuses

- Treating Foundry as "the OpenAI portal" and provisioning everything in one hub with one project — destroys cost attribution and access boundaries.
- Disabling Content Safety in dev and forgetting to re-enable for production; the filter config must travel with the deployment.
- Hand-rolling evaluation in notebooks instead of using Foundry evaluations, so promotion gates are not reproducible.

## Notes

- Pairs with `foundry-agent-service` (agent runtime that sits on top of Foundry), `entra-id` + `managed-identity` (auth), `key-vault` (secrets for connections), `mcsb` (security baseline), `ai-red-teaming` (PyRIT runs target Foundry deployments), `rai-toolbox` (model-level RAI for tabular adjuncts).
- High volatility: model catalog, SKUs, and feature names shift quarterly — re-verify the model list and pricing at every workload review.
