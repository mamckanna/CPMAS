---
id: azure-devops
name: Azure DevOps Services
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/devops/
covers: [boards, repos, pipelines, artifacts, test-plans, advanced-security]
agent_use: Cite when the project uses Azure DevOps for any of Boards / Repos / Pipelines / Artifacts / Test Plans; when defining work-item / branch / pipeline conventions; or when the Release Manager designs the release pipeline on Azure DevOps.
volatility: medium
licensing: proprietary (per-user license; some features per-pipeline)
last_verified: 2026-05-25
---

# Azure DevOps Services

Microsoft's hosted devops suite: Boards (work tracking), Repos (Git), Pipelines (CI/CD), Artifacts (package feeds), Test Plans, plus Advanced Security for Azure DevOps. For MS-stack projects with enterprise procurement constraints or deep on-prem integration, Azure DevOps is the alternative to GitHub; for greenfield public-cloud work, GitHub (`gh-actions` + `gh-advanced-security`) is usually preferred. The Architect cites which platform the project uses and any cross-platform integration.

## Key requirements

- **One platform decision per project.** Mixing GitHub and Azure DevOps for the same workload (code in one, CI in the other) requires a `decisions.md` entry justifying the split.
- **Boards: hierarchical work tracking.** Epics → Features → User Stories / Product Backlog Items → Tasks. Process templates (Agile, Scrum, CMMI, Basic) are chosen at project creation; switching processes mid-project is expensive.
- **Repos: Git with branch policies.** Required reviewers, build validation, work-item linking, and comment resolution before completion. `main` requires PR; direct push is blocked.
- **Pipelines: YAML-first.** Classic (visual) pipelines are deprecated for new work. Pipelines use `azure-pipelines.yml` at the repo root or in `.azure-pipelines/`. Templates and extends-templates compose shared logic.
- **Service connections (not stored credentials).** Azure deployments use workload-identity federation (preferred) or service principals with certificate credentials. Username/password service connections are forbidden for production.
- **Approvals and checks gate environments.** Production deploys require an approval check or an automated quality gate; "auto-deploy on push to main" requires explicit `decisions.md` justification.
- **Artifacts feeds for internal packages.** NuGet, npm, Maven, Python, and Universal feeds with upstream sources for public registries. Direct consumption of public registries from build agents requires justification (supply-chain risk).
- **Advanced Security for Azure DevOps** is the equivalent of `gh-advanced-security` on the Azure DevOps surface; same SAST + secret scanning + dependency scanning expectations.
- **Auditing**: organization audit log + project audit logs stream to Log Analytics or a SIEM for retention beyond the in-product window.

## Common misuses

- Storing build secrets in pipeline variables instead of Key Vault (`key-vault`) connected via service connection. Variables marked "secret" are obscured in UI but are not vault-grade.
- Long-lived service principals for service connections. Federated credentials (workload identity federation) supersede secret-based service connections for production.
- Branching strategies copied from another team without revisiting. The branching model (trunk-based, GitFlow, release-branch) is a project decision recorded in `docs/release.md`.

## Notes

- Pairs with `azure-pipelines` (the CI/CD component), `gh-actions` (alternative), `gh-advanced-security` (GitHub-side counterpart), `entra-id` (identity for service connections), `bicep` (IaC commonly built and deployed via Pipelines).
- For new MS-stack greenfield projects, GitHub is the default unless procurement, sovereignty, or process-template requirements drive Azure DevOps.
