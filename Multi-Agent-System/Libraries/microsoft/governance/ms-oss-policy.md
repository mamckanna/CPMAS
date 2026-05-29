---
id: ms-oss-policy
name: Microsoft Open Source Policy
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/developer/intro/microsoft-open-source-developer-resources
covers: [oss-licensing, cla, dco, third-party-components, distribution, contribution]
agent_use: Cite when project_profile.distribution is ms-oss (or mixed including ms-oss); when reviewing license-compatibility for distributed binaries; when an artifact has third-party OSS dependencies; or when contribution / CLA mechanics are in scope.
volatility: low
licensing: documentation under Creative Commons; policy itself proprietary to Microsoft
last_verified: 2026-05-26
---

# Microsoft Open Source Policy

Microsoft's internal policy framework for open-source software — what licenses are approved for distribution, how third-party OSS is consumed, how contributions are accepted (CLA / DCO), and the obligations attached to publishing OSS under a Microsoft org or product. The Legal role cites this when `project_profile.distribution in [ms-oss, mixed]`.

## Key requirements

- **Approved-license list governs outbound distribution.** Source-distributed components must carry an approved permissive or copyleft license (MIT, Apache-2.0, BSD-2/3-Clause, MS-PL most commonly). Strong-copyleft licenses (GPL family) on distributed code require explicit legal review and are typically refused for MS-owned products that ship binaries.
- **Inbound third-party OSS is scanned and tracked.** Every third-party component is enumerated with name + version + license + source URL in the artifact's bill-of-materials (SBOM). `gh-advanced-security` dependency scanning is the default tooling on GitHub-hosted code.
- **CLA or DCO is required for external contributions.** Microsoft repos use a Contributor License Agreement bot (CLA assistant) by default; some projects use DCO sign-off instead. The mechanism is named in the repo's CONTRIBUTING.md.
- **Notice file accompanies every release.** Distributions include a `THIRD-PARTY-NOTICES` or `NOTICE` file enumerating all bundled OSS components and their license texts as required by their licenses.
- **No copyleft contamination of proprietary code.** GPL/LGPL/AGPL components are not linked into proprietary binaries; where used, they are isolated via process boundary (separate executable) and the linkage is documented.
- **OSS releases under a Microsoft org follow the publishing checklist.** Repo gets the standard SECURITY.md, CODE_OF_CONDUCT.md, LICENSE, and a designated maintainer. The checklist is enforced before a repo can be made public.
- **Trademark and naming review** for repos that use Microsoft, Azure, .NET, or product brand names. Brand-bearing repos go through additional review.

## Common misuses

- Treating "open source" as license-blind. Distributing a binary that statically links a GPL component without legal review is a finding.
- Adding a license file without scanning transitive dependencies. The SBOM is the source of truth, not the top-level LICENSE.
- Bypassing the CLA bot for "small" external PRs. The mechanism is binary; either it's required for all external contributions or none.

## Notes

- Pairs with `gh-advanced-security` (dependency + secret scanning), `sdl` (overall SDL umbrella that references OSS hygiene), `ms-rai-standard` and `ms-privacy-standard` (when distributed code processes personal data or AI workloads).
- The public-facing version of the policy lives on Microsoft Learn; the internal version (with the exhaustive approved-license matrix) is on Microsoft's intranet. The agent cites the public URL and notes that internal review may impose additional constraints.
- Counterpart for non-MS distribution: standard license compatibility analysis (OSI-approved licenses, no Microsoft-specific layer). The Legal role flips citations off `ms-oss-policy` when `distribution: external-commercial` or `internal`.
