---
id: sfi
name: Microsoft Secure Future Initiative
category: microsoft
authority: vendor
url: https://www.microsoft.com/en-us/trust-center/security/secure-future-initiative
covers: [security-culture, secure-by-design, secure-by-default, secure-operations, identity, telemetry]
agent_use: Cite when establishing security posture for a Microsoft-stack project; when justifying secure-by-default decisions; or when the Security Engineer or Compliance Officer writes a top-level security stance.
volatility: medium
licensing: proprietary (Microsoft public commitments)
last_verified: 2026-05-25
---

# Microsoft Secure Future Initiative

Microsoft's company-wide security program launched in 2023 and expanded in 2024–2025. SFI is the top-level statement of Microsoft's security commitments and the umbrella under which SDL (`sdl`), MCSB (`mcsb`), Zero Trust (`zero-trust`), and product-level hardening sit. For MS-stack projects, SFI is the "north star" the Security Engineer cites; product-specific controls trace back to one of its pillars.

## Key requirements

- **Three principles**: Secure by Design, Secure by Default, Secure Operations. Every security decision in `decisions.md` maps to one of these.
- **Six pillars** (post-2024 expansion): Protect identities and secrets; Protect tenants and isolate production systems; Protect networks; Protect engineering systems; Monitor and detect threats; Accelerate response and remediation. Security reviews enumerate which pillars apply.
- **Identity is pillar one**: phishing-resistant MFA for all human and service identities; no long-lived credentials in code, config, or pipelines. Managed identity (`managed-identity`) is the default; secrets in Key Vault (`key-vault`) are the exception.
- **Production isolation**: production tenants/subscriptions are separate from build, test, and admin tenants. Cross-environment standing access is forbidden.
- **Engineering system integrity**: source, build, and release systems are themselves treated as production. GitHub Advanced Security (`gh-advanced-security`) and signed builds are baseline.
- **Telemetry by default**: security-relevant logs are retained centrally with tamper-evident storage. "We don't log that" is a finding.
- **Security culture metric**: SFI is reviewed at executive level with measurable progress. Projects citing SFI must also produce measurable evidence (coverage %, MTTR, etc.), not narrative-only claims.

## Common misuses

- Citing SFI as if it were a technical control. SFI is the program; the controls live in SDL, MCSB, Zero Trust, and product docs. Always pair an SFI citation with a control-level citation.
- Treating SFI's commitments as aspirational. They are the baseline for any Microsoft-aligned project; deviations require explicit `decisions.md` entries.

## Notes

- Pairs with `sdl` (engineering practice), `mcsb` (Azure control mapping), `zero-trust` (architecture model), `entra-id` + `managed-identity` + `key-vault` (identity & secrets pillar implementation).
- Volatility is `medium` because pillar definitions and public commitments are refined periodically; re-verify every 6 months.
