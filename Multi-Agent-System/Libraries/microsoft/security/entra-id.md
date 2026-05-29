---
id: entra-id
name: Microsoft Entra ID
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/entra/identity/
covers: [identity, authentication, authorization, sso, conditional-access, pim, b2b]
agent_use: Cite when designing authentication, authorization, conditional access, or privileged-access flows for an Azure or Microsoft 365 workload; when reviewing identity-related security decisions.
volatility: medium
licensing: proprietary (per-tenant Entra license)
last_verified: 2026-05-25
---

# Microsoft Entra ID

Microsoft's cloud identity platform (formerly Azure Active Directory). The identity foundation for Azure, Microsoft 365, and any application using Microsoft identity. For MS-stack projects, Entra ID is the default identity provider; alternatives require a `decisions.md` exception.

## Key requirements

- **Phishing-resistant MFA for human identities**: FIDO2 keys, Windows Hello for Business, or platform passkeys. SMS and voice are deprecated for privileged access and discouraged elsewhere.
- **Workload identities use managed identity (`managed-identity`) or service principals with certificate credentials**: client-secret credentials are a finding in production. Federated credentials (workload identity federation) preferred for cross-cloud scenarios.
- **Conditional Access policies are the enforcement layer**: MFA, device compliance, location, and risk-based controls are conditional-access policies, not per-app settings. Every production tenant has a baseline policy set; the Security Engineer enumerates which policies apply to the workload.
- **Privileged Identity Management (PIM) for admin roles**: standing assignment of high-privilege roles (Global Admin, Subscription Owner, etc.) is forbidden. PIM eligible assignments with just-in-time activation are the default.
- **Application registrations have least-privilege API permissions**: delegated and application permissions are reviewed; consent grants are auditable. Admin consent is required for application permissions touching organizational data.
- **Tokens are short-lived; refresh is automatic**: access tokens default to 60–90 minutes. Token caching is library-managed (MSAL); do not hand-roll OAuth flows.
- **Audit logs and sign-in logs are retained**: stream to Log Analytics or a SIEM. Default 30-day retention is insufficient for compliance scenarios.
- **B2B vs B2C distinction**: B2B (external collaborators in your tenant) and B2C / Entra External ID (customer-facing app identity) are different products with different threat models. The Architect names which the workload uses.

## Common misuses

- Embedding client secrets in app config when managed identity is available. Always check first whether the resource supports MI; most Azure resources do.
- Granting Global Admin "for convenience." Global Admin is the most-attacked role; PIM-eligible assignment with strict approval is mandatory.
- Conflating Entra ID with on-prem Active Directory. They are different products; sync via Entra Connect bridges them but they have separate trust and protocol surfaces.

## Notes

- Pairs with `managed-identity` (workload identity), `key-vault` (secrets for the rare client-credential case), `zero-trust` (Entra is the identity pillar's primary product), `mcsb` (Identity Management domain).
- Volatility is `medium`: the platform evolves rapidly (e.g., Conditional Access features, External ID rebrand) but the core model is stable.
