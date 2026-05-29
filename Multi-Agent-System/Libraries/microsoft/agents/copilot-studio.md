---
id: copilot-studio
name: Microsoft Copilot Studio
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/microsoft-copilot-studio/
covers: [low-code-agents, topics, knowledge, actions, channels, governance]
agent_use: Cite when proposing or reviewing a low-code / business-user agent surface in the MS stack — Teams/Microsoft 365 copilots, customer-facing chat over Dataverse/SharePoint/web knowledge, and the boundary between Copilot Studio and pro-code (Foundry / MAF / SK).
volatility: high
licensing: proprietary (per-message / SKU)
last_verified: 2026-05-25
---

# Microsoft Copilot Studio

Microsoft's low-code platform for building and publishing copilots / agents that integrate with Microsoft 365, Teams, Dynamics 365, and external channels. Built on the Power Platform; the default surface when business users own the agent and the orchestration is conversational rather than programmatic.

## Key requirements

- **Pick Copilot Studio when the owner is a business user**, the knowledge is in Microsoft 365 / Dataverse / SharePoint / a web source, and channels are Teams, Microsoft 365 Copilot, or a hosted web chat. Pick pro-code (`foundry-agent-service`, `agent-framework`, `semantic-kernel`) when the orchestration is non-trivial, latency-sensitive, or part of a larger application.
- **Topics + generative orchestration** are the authoring model. Topics are dialog flows with triggers (utterances or events); generative orchestration lets the copilot pick a topic or action per turn. Disabling generative orchestration is a deliberate downgrade, not a default.
- **Knowledge sources are explicit and governed**: SharePoint sites, Dataverse tables, public websites, uploaded files, or connected enterprise search. Each source has a name, owner, and refresh cadence; ungoverned web URLs in production are findings.
- **Actions are Power Platform connectors, Power Automate flows, or REST endpoints.** Custom REST actions use OAuth (Entra) where possible; static API keys belong in environment variables managed by an admin, not in the action definition.
- **Authentication uses Entra by default** for Teams and M365 channels; security trimming on knowledge sources (SharePoint, Dataverse) must be honored — the copilot answers only with content the calling user can already see.
- **Environments + ALM**: dev, test, prod environments in the Power Platform admin center; solutions package topics, actions, and knowledge for promotion via Power Platform Pipelines or Azure DevOps. Direct editing in prod is a finding.
- **DLP policies enforced at tenant level** (Power Platform Data Loss Prevention). Connectors are classified Business / Non-Business / Blocked; a copilot cannot bridge a connector across classifications. Tenant admin owns the policy; the agent design respects it.
- **Analytics + transcripts** are reviewed weekly: session counts, deflection / escalation rate, top unanswered utterances, citation coverage. Topics with low containment are revised, not abandoned.

## Common misuses

- Building "one big copilot" with every knowledge source and connector — destroys DLP boundaries and makes prompt-injection from one source affect every other.
- Treating Copilot Studio as a thin wrapper over Azure OpenAI when the workload actually wants Foundry Agent Service — loses the Power Platform governance and channel integration that justify the SKU.
- Skipping security trimming on SharePoint or Dataverse sources because "everyone in the company can see it anyway"; the copilot must inherit the source's ACL model, not flatten it.

## Notes

- Pairs with `foundry-agent-service` (pro-code alternative; Copilot Studio can call Foundry agents as skills), `entra-id` (channel auth), `ms-rai-standard` + `ai-red-teaming` (RAI review and red-team apply equally to low-code agents), `ms-privacy-standard` (DLP + data residency in Power Platform), `ms-accessibility` (channel UI accessibility).
- High volatility: SKUs, message metering, and the generative-orchestration feature set shift frequently — re-verify pricing and feature availability at every workload review.
