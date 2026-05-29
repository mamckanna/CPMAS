---
id: azure-landing-zones
name: Azure Landing Zones
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/
covers: [landing-zones, enterprise-scale, subscription-design, governance, network-topology]
agent_use: Cite when establishing a new Azure environment; when designing subscription/management-group hierarchy; or when validating that a workload's target subscription has the required baseline policies and identity foundation.
volatility: medium
licensing: proprietary (Microsoft Learn ToU + open-source IaC on GitHub)
last_verified: 2026-05-25
---

# Azure Landing Zones

The Ready methodology output of CAF (`caf`): an opinionated, deployable substrate of subscriptions, management groups, policies, identity, networking, and monitoring. The Architect targets workloads into a landing zone; the landing zone is not part of the workload.

## Key requirements

- **Landing zones come first.** A workload cannot deploy into a subscription that has not gone through the landing-zone Ready methodology. Skipping this is a finding at the Plan gate.
- **Two flavors**: Application Landing Zone (where workloads run) and Platform Landing Zone (identity, management, connectivity). The Architect names which target their workload uses.
- **Eight design areas**: Azure billing and Entra ID tenant, Identity and access management, Resource organization, Network topology and connectivity, Security, Management, Governance, Platform automation and DevOps. Each design area has decisions that must be made before workload deployment.
- **Management-group hierarchy**: enterprise-scale prescribes a hierarchy (Root → Tenant Root Group → Platform / Landing Zones / Decommissioned / Sandbox → ...). Adopt it or document the deviation.
- **Policy as baseline**: Azure Policy initiatives enforce the security baseline (`mcsb`) at management-group level. Workload IaC must not turn off baseline policies; it must comply with them.
- **Hub-and-spoke or vWAN networking**: pick one as the default network topology. Mixed topologies require explicit decisions.
- **Identity is a tenant decision, not a workload decision**: Entra tenant, federation, conditional access, PIM — set at the platform landing zone, inherited by application landing zones.
- **Reference implementations**: Microsoft publishes Bicep (ALZ-Bicep) and Terraform (Azure/terraform-azurerm-caf-enterprise-scale) implementations. New environments start from one of these; bespoke landing-zone IaC requires a decision entry.

## Common misuses

- Building a workload in an unmanaged subscription "to move fast" with intent to migrate to a landing zone later. The migration is more expensive than starting in the landing zone.
- Customizing the reference implementation extensively before deploying it. Deploy first, customize via tracked changes; otherwise drift from the reference is untrackable.
- Treating the platform landing zone as "someone else's problem" when the workload depends on its identity, networking, and policy. Architect must engage the platform team explicitly.

## Notes

- Pairs with `caf` (parent methodology), `mcsb` (baseline policies), `entra-id` (identity), `bicep` + `avm` (deployment), `azure-devops` or `gh-actions` (platform-automation discipline).
