---
id: mcsb
name: Microsoft Cloud Security Benchmark
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/security/benchmark/azure/
covers: [azure-security, baseline, controls, compliance, defender-for-cloud, policy]
agent_use: Cite when reviewing an Azure workload's security configuration; when mapping organizational controls to Azure services; or when justifying which Azure Policy initiatives must apply.
volatility: medium
licensing: proprietary (Microsoft Learn ToU)
last_verified: 2026-05-25
---

# Microsoft Cloud Security Benchmark

The normative security control framework for Azure (and, increasingly, multi-cloud). MCSB maps industry controls (NIST 800-53, CIS, PCI) to Azure-specific implementations. It is the "Secure" methodology output of CAF (`caf`) and the control catalog enforced by `defender-for-cloud`.

## Key requirements

- **Eleven control domains**: Network Security, Identity Management, Privileged Access, Data Protection, Asset Management, Logging & Threat Detection, Incident Response, Posture & Vulnerability Management, Endpoint Security, Backup & Recovery, DevOps Security, Governance & Strategy. Workloads address each domain or document N/A.
- **Per-service baselines**: every major Azure service has a published MCSB baseline (e.g., App Service security baseline, Key Vault security baseline). The Security Engineer cites the per-service baseline for each resource type in the workload.
- **Policy initiative implementation**: MCSB controls are operationalized as a built-in Azure Policy initiative (`Microsoft cloud security benchmark`). Landing zones assign this initiative at the management-group level; workload IaC must comply.
- **Defender for Cloud as the assessment engine**: MCSB compliance is measured by Defender for Cloud's regulatory-compliance dashboard. A "Reviewer pass: security" result references the current Defender score and any failing controls.
- **Control IDs are stable** (e.g., NS-1, IM-3): cite by control ID in any security pass; do not paraphrase.
- **Mapping to external frameworks** is published: MCSB → NIST 800-53 rev 5, MCSB → CIS, MCSB → PCI-DSS, etc. Compliance officers cite both the MCSB ID and the external framework ID.
- **Recommendations have severity and remediation steps**: high/critical recommendations are blocking for production; remediation steps in the recommendation are authoritative.

## Common misuses

- Mapping organizational controls to Azure services manually when MCSB already publishes the mapping. Don't reinvent.
- Treating MCSB as a one-time configuration. It is a continuous control set; Defender for Cloud's score is the operational signal.
- Disabling Defender plans to save money. Without Defender's assessment, MCSB compliance has no measurement; the compliance claim becomes unverifiable.

## Notes

- Pairs with `caf` (Secure methodology parent), `defender-for-cloud` (assessment engine), `azure-landing-zones` (where the policy initiative is assigned), `entra-id` + `key-vault` + `managed-identity` (Identity Management + Data Protection domains).
- Volatility is `medium`: control IDs are stable; per-service baselines update as services evolve. Re-verify every 6 months.
