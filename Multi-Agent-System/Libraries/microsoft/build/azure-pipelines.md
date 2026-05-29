---
id: azure-pipelines
name: Azure Pipelines
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/devops/pipelines/
covers: [ci-cd, yaml-pipelines, environments, approvals, templates, federated-credentials]
agent_use: Cite when authoring CI/CD pipelines in Azure DevOps; when reviewing pipeline structure, environment gating, or approval flows; or when the Release Manager designs the release path on Azure Pipelines.
volatility: medium
licensing: proprietary (per-parallel-job license; some free minutes for public)
last_verified: 2026-05-25
---

# Azure Pipelines

The CI/CD component of Azure DevOps (`azure-devops`). Multi-stage YAML pipelines define build, test, and deploy stages with environment-based approvals and checks. For projects on the Azure DevOps platform, Azure Pipelines is the default; GitHub-hosted projects use `gh-actions`.

## Key requirements

- **YAML pipelines, not Classic.** Classic (visual designer) pipelines are deprecated for new work; existing Classic pipelines are scheduled for migration in `docs/release.md`.
- **Multi-stage pipelines with environments.** Build → Test → Deploy-to-Nonprod → Deploy-to-Prod, each as a stage targeting an Environment. Environments hold approval checks, gates, deployment history, and resource references.
- **Approvals + checks on production environments.** Pre-deployment approval (named reviewers); business-hours window; query-Azure-Monitor gate (no active high-severity alerts); branch control (only deploy from `main` or release branches).
- **Service connections via workload-identity federation.** The pipeline authenticates to Azure via federated credential (OIDC), not a stored service-principal secret. Long-lived secrets in service connections are forbidden for production targets.
- **Pipeline templates for reuse.** Shared `template.yml` files (in the same repo or a shared template repo via `resources: repositories:`) encapsulate steps, jobs, and stages. Inline duplication across pipelines is a finding.
- **Extends templates for governed pipelines.** `extends` templates enforce required steps (SAST, secret scan, image signing) that downstream pipelines cannot remove. Used by platform/security teams.
- **Self-hosted agents for restricted networks; Microsoft-hosted otherwise.** Self-hosted agents are hardened, patched, and run least-privilege workload identities. Mixing dev secrets onto self-hosted agents requires isolation.
- **Artifacts are pinned and provenance-attested.** Build outputs publish to Artifacts (or Container Registry) with SBOM and SLSA-style provenance attestations where the supply-chain bar requires.
- **Failed builds cannot be retried into success without a code change.** Flaky-test retry is permitted with a tracked finding; "rerun until green" on a real failure is a process violation.

## Common misuses

- Putting deployment logic in build stages. Build is reproducible from source; deploy is parameterized by environment. Coupling them blocks deploy-only retries.
- Storing config-as-secret in variable groups instead of Key Vault. Variable groups are convenient but vault-linked groups (variables sourced from Key Vault) are the production pattern.
- Single-stage pipelines for production deploys. Without separate environments, the approval/gating surface is missing.

## Notes

- Pairs with `azure-devops` (parent platform), `bicep` (typical IaC built and deployed here), `entra-id` + `managed-identity` (service connection identity), `key-vault` (variable-group source), `mcsb` (DevOps Security control validation).
- For multi-cloud or multi-repo organizations on GitHub, `gh-actions` is the analog with very similar mental model.
