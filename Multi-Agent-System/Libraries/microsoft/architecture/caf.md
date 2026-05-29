---
id: caf
name: Microsoft Cloud Adoption Framework for Azure
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/
covers: [cloud-adoption, governance, landing-zones, strategy, operations, migration]
agent_use: Cite when establishing enterprise cloud posture, organizing subscriptions/management groups, defining cloud governance, or planning migration to Azure at scale.
volatility: medium
licensing: proprietary (Microsoft Learn ToU)
last_verified: 2026-05-25
---

# Microsoft Cloud Adoption Framework for Azure

Microsoft's enterprise-scale framework for adopting Azure. The canonical "how does an organization use Azure" reference. Complements WAF (`waf`) which addresses individual workloads.

## Key requirements

- **Eight methodologies**: Strategy, Plan, Ready, Adopt (Migrate + Innovate), Govern, Manage, Secure, Organize. A CAF-aligned project names which methodologies apply and which are out of scope.
- **Landing zones come before workloads**: Azure landing zones (`azure-landing-zones`) are the substrate. Production workloads do not deploy into a subscription that has not gone through the Ready methodology.
- **Governance disciplines**: Cost Management, Security Baseline, Resource Consistency, Identity Baseline, Deployment Acceleration. Each discipline requires policy + monitoring + remediation — policy alone is insufficient.
- **Hierarchy of management groups**: top-down management-group structure (root → intermediate → landing zones → subscriptions). Flat structures (all subscriptions at root) are a finding.
- **Naming and tagging conventions**: Microsoft publishes recommended naming/tagging standards. Adopt them as-is or document the deviation in `decisions.md`.
- **Migration methodology**: Assess → Migrate → Optimize → Secure & Manage. Lift-and-shift is acceptable as an interim; "optimize" must follow within a declared timeline.
- **Innovate methodology** (for AI-first or net-new work): build → measure → learn loop with hypothesis-driven scoping. The Architect cites this when the workload is greenfield rather than migration.
- **Secure methodology** = MCSB (`mcsb`). CAF's "secure" pillar normatively references MCSB; do not reinvent.

## Common misuses

- Treating CAF as a one-time exercise. The framework is continuous; Govern and Manage are ongoing methodologies, not phases.
- Implementing Azure features (Policy, Defender, etc.) without the CAF organizational substrate. Tools without governance produce noise, not control.
- Confusing CAF with WAF. WAF = per-workload architecture; CAF = enterprise cloud adoption. Both are needed; neither replaces the other.

## Notes

- Pairs with `waf` (workloads), `azure-landing-zones` (Ready methodology output), `mcsb` (Secure methodology), `bicep` + `avm` (Deployment Acceleration discipline).
- For multi-team projects (`project-profile.multi_team == yes`), CAF's organizational guidance is mandatory reading for Orchestrator and Compliance Officer.
