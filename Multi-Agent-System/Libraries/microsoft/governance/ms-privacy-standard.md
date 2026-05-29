---
id: ms-privacy-standard
name: Microsoft Privacy Standard
category: microsoft
authority: vendor
url: https://www.microsoft.com/en-us/trust-center/privacy
covers: [privacy, data-minimization, purpose-limitation, consent, dsr, gdpr, residency]
agent_use: Cite when handling personal data in an MS-stack workload; when defining data flows, retention, residency, or consent requirements; or when the Privacy Engineer or Compliance Officer reviews a feature for privacy compliance.
volatility: medium
licensing: proprietary (Microsoft public commitments)
last_verified: 2026-05-25
---

# Microsoft Privacy Standard

Microsoft's privacy operating model: the implementation framework that makes the Microsoft Privacy Statement operational across products. Cited as the project-level privacy bar for any MS-stack workload processing personal data. Maps to GDPR, CCPA, and similar regimes; the Compliance Officer cites both this standard and the specific regulation that applies.

## Key requirements

- **Six foundational commitments**: Control (user controls), Transparency (clear notice), Security (technical safeguards), Strong Legal Protections, No Content-Based Targeting, Benefits to You. Each AI/data feature maps its design to these commitments.
- **Data minimization is the default.** Collect only what the documented purpose requires; default-deny on new fields. Justification is recorded in `docs/data-inventory.md`.
- **Purpose limitation.** Each collected field has a declared purpose; using it for a new purpose requires a documented decision and, where applicable, refreshed consent.
- **Data residency and sovereignty.** For multi-region workloads, residency requirements are named per data class. EU Data Boundary, government clouds (GCC, GCC-High, DoD), and customer-controlled residency requirements drive architecture.
- **Customer Lockbox + Customer-Managed Keys for sensitive workloads.** Microsoft personnel access to customer data requires explicit, audited approval (Lockbox); encryption uses customer-managed keys (CMK) via `key-vault` where regulatory or business sensitivity demands.
- **Data Subject Rights (DSR) are operational.** Access, rectification, erasure, portability, and restriction requests have a documented flow with a target response time. The flow is tested at least annually.
- **Children's data, sensitive categories, and special protections.** Health, biometric, financial, or children's data carry additional controls. The Privacy Engineer enumerates which categories the workload touches.
- **Cross-border transfer mechanisms.** SCCs, adequacy decisions, supplementary measures — named per transfer flow in `docs/privacy.md`.
- **Privacy review at gates.** Privacy review is part of the Build and Release gates; it is not a separate stream that races the release.

## Common misuses

- Treating "we encrypt at rest" as the privacy review. Encryption is one control; minimization, purpose limitation, residency, and DSR support are independent requirements.
- Inferring consent from product use. Consent (where the legal basis) must be specific, informed, and revocable; a tick-box at signup typically doesn't cover later AI features.
- Storing personal data in telemetry / logs by accident. Application Insights and similar tools capture request data by default; the Privacy Engineer reviews telemetry sampling and redaction.

## Notes

- Pairs with `ms-rai-standard` (Privacy & Security principle), `key-vault` (CMK / secrets), `entra-id` (identity protection), `mcsb` (Data Protection control domain), `defender-for-cloud` (data-risk recommendations).
- For AI features specifically, prompt + completion logs are personal data when prompts contain personal data; the Privacy Engineer designs telemetry redaction accordingly.
