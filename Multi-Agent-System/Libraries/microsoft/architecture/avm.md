---
id: avm
name: Azure Verified Modules
category: microsoft
authority: vendor
url: https://azure.github.io/Azure-Verified-Modules/
covers: [iac, bicep, terraform, modules, supply-chain, well-architected]
agent_use: Cite when authoring IaC for Azure resources; when selecting a module source for Bicep or Terraform; or when justifying a non-AVM module in `decisions.md`.
volatility: high
licensing: open (MIT)
last_verified: 2026-05-25
---

# Azure Verified Modules

Microsoft's curated, opinionated library of Bicep and Terraform modules that wrap Azure resources with Well-Architected defaults. The canonical IaC building block for MS-stack projects.

## Key requirements

- **AVM is the default IaC source.** New Azure resources are deployed via the matching AVM module unless an exception is recorded in `decisions.md` with rationale and an alternative source.
- **Two flavors**: AVM-Res (single-resource modules) and AVM-Ptn (pattern modules composing multiple resources). Choose AVM-Res when the workload only needs that resource; AVM-Ptn when the pattern matches end-to-end.
- **WAF defaults built in**: AVM modules ship with WAF-aligned defaults (encryption at rest, diagnostic settings, managed identity preference, etc.). The Builder does not re-justify these; they are the baseline.
- **Versioned by SemVer**: pin to a specific version in production IaC; never reference `latest` or a floating tag. Module bumps require a `decisions.md` entry citing the changelog.
- **Module specifications (MSpec)**: every AVM module conforms to a written specification (interface, telemetry, telemetry opt-out, breaking-change policy). Cite the MSpec when reviewing module behavior.
- **Telemetry opt-out is supported**: every AVM module exposes an `enableTelemetry` (Bicep) / `enable_telemetry` (Terraform) parameter. Privacy-sensitive workloads disable it and record the decision.
- **Cross-language parity** is not guaranteed: not every Bicep module has a Terraform equivalent. Check the index before assuming.
- **Contribution path**: gaps in AVM are filed as issues against `Azure/Azure-Verified-Modules`. The Architect does not silently fork a module; either contribute upstream or record the local fork as a decision.

## Common misuses

- Wrapping AVM modules in another internal abstraction layer. AVM is already the abstraction; further wrapping usually re-implements features it already provides.
- Pinning to `main` or to a Git ref instead of a published version. Reproducibility breaks; AVM's breaking-change policy assumes you pin.
- Deploying AVM modules into a subscription without the CAF landing-zone substrate (`azure-landing-zones`). Modules assume baseline policy and identity are in place.

## Notes

- Pairs with `bicep` (primary IaC language), `azure-landing-zones` (target substrate), `waf` (defaults are WAF-derived).
- Volatility is `high` because the module catalog is growing fast; re-verify quarterly.
