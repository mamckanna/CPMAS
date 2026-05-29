---
id: bicep
name: Bicep
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/
covers: [iac, arm, modules, what-if, deployment-stacks, avm]
agent_use: Cite when authoring Azure IaC; when reviewing module structure, parameter design, or deployment safety; or when the Architect / Builder selects an IaC language for an MS-stack project.
volatility: medium
licensing: open (MIT for tooling; Azure resources are consumption)
last_verified: 2026-05-25
---

# Bicep

Microsoft's domain-specific language for Azure Resource Manager templates. Bicep compiles to ARM JSON, executes via the ARM control plane, and is the first-party IaC language for Azure. Pairs with Azure Verified Modules (`avm`) which publishes opinionated, WAF-aligned Bicep modules. For MS-stack greenfield, Bicep is the default; Terraform is the alternative when multi-cloud or operator preference dictates.

## Key requirements

- **Modules from AVM by default.** New Azure resources use the matching AVM module (`avm`); custom modules require a `decisions.md` entry naming the AVM gap.
- **`.bicep` at the source of truth, ARM JSON never edited by hand.** Generated ARM is build output, not source. Repos commit `.bicep` files and optionally compiled JSON for change visibility, but `.bicep` is authoritative.
- **Parameter files per environment.** `main.bicep` + `main.parameters.<env>.json` (or `.bicepparam`) per environment. Hardcoded environment values in `main.bicep` are a finding.
- **`what-if` before every production deploy.** `az deployment group what-if` (or `New-AzDeployment -WhatIf`) preview is captured and reviewed; "deploy and hope" is forbidden.
- **Deployment Stacks for grouped resources** with deny-settings to prevent out-of-band changes. Loose `az deployment` for production landing-zone changes is discouraged in favor of stacks.
- **Linter clean.** `bicep build` and `bicep lint` produce zero warnings on committed source; suppressions are explicit (`#disable-next-line`) with rationale.
- **Outputs do not expose secrets.** `output` declarations are not encrypted; secrets returned from a deployment are written to Key Vault (`key-vault`) inside the module, not surfaced as outputs.
- **Resource names follow the CAF naming convention** or a project-specific override declared in `decisions.md`. Random-suffix patterns are used where required for global uniqueness.
- **PSRule for Azure** (or `psrule`) runs in CI against Bicep to validate against WAF + MCSB recommendations before merge.

## Common misuses

- Re-implementing AVM modules locally "to add one parameter." The AVM contribution path is faster than long-term maintenance of a fork.
- Treating compiled ARM JSON as the source. Editing JSON breaks the round-trip and the Bicep tooling.
- Using `existing` references across deployment scopes without checking RBAC. The deployer's identity needs read on the referenced resource at deploy time.

## Notes

- Pairs with `avm` (the module library), `azure-landing-zones` (the substrate IaC targets), `psrule` (policy-as-code validation; live elsewhere in Libraries), `mcsb` (control validation), `azure-pipelines` / `gh-actions` (CI surface).
- Bicep is feature-equivalent to ARM but more ergonomic; new ARM features land in Bicep before they become ergonomic in JSON.
