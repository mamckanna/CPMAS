---
id: defender-for-cloud
name: Microsoft Defender for Cloud
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/defender-for-cloud/
covers: [cspm, cwpp, mcsb-assessment, threat-detection, compliance, multi-cloud]
agent_use: Cite when reviewing an Azure subscription's security posture, MCSB compliance score, or runtime threat alerts; when justifying which Defender plans must be enabled; or when defining the Security Engineer's operational dashboard.
volatility: medium
licensing: proprietary (per-plan consumption)
last_verified: 2026-05-25
---

# Microsoft Defender for Cloud

Microsoft's Cloud Security Posture Management (CSPM) and Cloud Workload Protection Platform (CWPP) for Azure, AWS, and GCP. The operational engine that scores MCSB (`mcsb`) compliance and produces threat alerts for workloads. Cited as the measurement layer for any "Reviewer pass: security" verdict on an Azure workload.

## Key requirements

- **Foundational CSPM is free and always-on.** It produces a Secure Score, baseline recommendations, and a regulatory-compliance dashboard mapping MCSB → controls. Disabling it is not a real option.
- **Defender CSPM (paid) adds agentless scanning, attack-path analysis, governance rules, and DevOps posture.** Production subscriptions enable it; "Foundational only" requires a `decisions.md` justification.
- **Per-resource Defender plans** protect specific workload types: Defender for Servers, App Service, Storage, SQL, Containers (AKS), Key Vault, Resource Manager, APIs, DNS, Cosmos DB, Open-Source Relational DBs, AI services. The Security Engineer enumerates which plans are required by the workload's resource inventory.
- **MCSB assessment is the compliance baseline.** The regulatory-compliance dashboard scores the subscription against MCSB out of the box. Additional standards (PCI-DSS, ISO 27001, SOC 2, HIPAA, FedRAMP, etc.) are added per compliance need.
- **Secure Score is the operational KPI.** A target score is set per subscription and tracked over time. Reviewer security passes cite the current score and any failing high-severity recommendations.
- **Alerts route to a SIEM** (Sentinel typically). Defender alerts at high/critical severity are blocking incidents; the response runbook lives in `docs/runbooks/`.
- **DevOps security** (a Defender CSPM feature) connects GitHub and Azure DevOps for code, secret, IaC, and dependency scanning surfaced alongside runtime alerts. Pairs with `gh-advanced-security`.
- **Multi-cloud onboarding** is supported (AWS accounts, GCP projects). The same MCSB-aligned controls apply where mapped; cross-cloud workloads use Defender as the unified pane.
- **Recommendations have explicit remediation steps and "Fix" automation** where available. Remediation outside the tool requires a tracked finding with owner and due date.

## Common misuses

- Looking at the Secure Score once and ignoring drift. The score is a continuous signal; recommendation drift between deploys is the early-warning indicator.
- Suppressing recommendations en masse to clean up the dashboard. Each suppression is a security decision and belongs in `decisions.md` with rationale and expiry.
- Enabling Defender plans only in production. Non-prod subscriptions are common attack vectors (test data, weaker controls); the Compliance Officer typically requires Defender at minimum on the management group covering all environments.

## Notes

- Pairs with `mcsb` (control catalog Defender measures against), `azure-landing-zones` (where Defender is enabled at MG scope), `sfi` ("Monitor and detect threats" pillar), `azure-monitor` (`app-insights` family for non-security telemetry).
- Defender for Servers requires the Azure Monitor Agent + Defender extension; the agentless approach handles posture without the agent but does not replace it for runtime detection on VMs.
