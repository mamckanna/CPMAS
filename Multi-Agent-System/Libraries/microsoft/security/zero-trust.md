---
id: zero-trust
name: Microsoft Zero Trust
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/security/zero-trust/
covers: [zero-trust, verify-explicitly, least-privilege, assume-breach, identity, network]
agent_use: Cite when establishing the workload's security architecture posture; when justifying decisions about implicit trust boundaries, network segmentation, or conditional access; or when writing a top-level Security Engineer review.
volatility: medium
licensing: proprietary (Microsoft public guidance)
last_verified: 2026-05-25
---

# Microsoft Zero Trust

Microsoft's adaptation of the NIST Zero Trust architecture (NIST SP 800-207) for the Microsoft ecosystem. Zero Trust is not a product; it is the assumption model under which every other Microsoft security product operates. Cited as the architectural stance for any MS-stack workload's security design.

## Key requirements

- **Three principles** govern every security decision: **Verify Explicitly** (authenticate and authorize every request based on all available signals); **Use Least-Privilege Access** (just-in-time, just-enough-access, risk-based adaptive policies); **Assume Breach** (segment access, minimize blast radius, verify end-to-end encryption, drive analytics).
- **Six pillars** for implementation: Identity, Endpoints, Applications, Data, Infrastructure, Network. The Architect maps every workload component to one or more pillars and cites the relevant controls.
- **Identity is the new perimeter.** Network location is not a trust signal by itself. Conditional Access (`entra-id`) evaluates user, device, location, app, and risk on every authentication.
- **No implicit trust between services.** Even inside a VNet, service-to-service calls authenticate (typically via managed identity, `managed-identity`) and authorize (RBAC). "It's behind the firewall" is not authorization.
- **Network microsegmentation.** Hub-and-spoke or vWAN with NSGs / Application Security Groups / Azure Firewall enforces east-west controls. Flat networks are a finding.
- **End-to-end encryption.** TLS for data in transit, customer-managed keys (via `key-vault`) for data at rest where regulatory or business sensitivity requires.
- **Continuous validation, not session-based trust.** Conditional Access re-evaluates on risk events; tokens are short-lived; Privileged Identity Management activates roles just-in-time.
- **Assume-breach drives detection investment.** Defender for Cloud (`defender-for-cloud`), Sentinel, and Entra ID Protection feed a SIEM with the assumption that the perimeter is already breached.

## Common misuses

- Treating Zero Trust as a procurement checklist ("we bought Defender, we're Zero Trust"). Zero Trust is an architectural stance the products implement; a product purchase without the principles is just a product purchase.
- Applying Zero Trust only to user-facing surfaces while keeping service-to-service trust flat. Lateral movement is the highest-impact attack path; service authentication is non-negotiable.
- Equating Zero Trust with "VPN-less." Removing VPN without adding identity-based authorization is regression, not progress.

## Notes

- Pairs with `sfi` (Microsoft's program-level umbrella), `entra-id` (Identity pillar), `managed-identity` (service identity), `mcsb` (control catalog), `azure-landing-zones` (network and identity substrate).
- Microsoft publishes a Zero Trust Maturity Model with traditional/advanced/optimal tiers per pillar. The Compliance Officer cites the target tier per pillar; production workloads aim for advanced or optimal on Identity and Endpoints at minimum.
