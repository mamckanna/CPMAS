---
id: gh-actions
name: GitHub Actions
category: microsoft
authority: vendor
url: https://docs.github.com/en/actions
covers: [ci-cd, workflows, environments, oidc, reusable-workflows, runners]
agent_use: Cite when authoring CI/CD workflows on GitHub; when reviewing workflow structure, environment gating, OIDC federation to Azure, or reusable workflow design; or when the Release Manager designs the release path on GitHub.
volatility: medium
licensing: proprietary (per-minute / per-storage; free tier for public repos)
last_verified: 2026-05-25
---

# GitHub Actions

GitHub's workflow automation engine. For MS-stack projects hosted on GitHub, Actions is the default CI/CD surface; Azure Pipelines (`azure-pipelines`) is the equivalent on Azure DevOps. Actions integrates natively with `gh-advanced-security` and supports OIDC federation to Azure for secretless deploys.

## Key requirements

- **Workflows in `.github/workflows/*.yml`.** One workflow per concern (CI, release, scheduled scans, dependency updates). Mega-workflows that branch on event type are a maintainability finding.
- **Environments for deployment targets.** GitHub Environments hold protection rules (required reviewers, wait timer, allowed branches), environment-scoped secrets, and deployment history. Production deploys target a protected environment.
- **OIDC federation to Azure, not stored credentials.** The `azure/login@v2` action with `federated-credential` on an Entra app or a user-assigned managed identity (`managed-identity`). `AZURE_CREDENTIALS` JSON with a client secret is forbidden for production.
- **Third-party actions pinned to commit SHA.** Tags (`@v3`) can be moved by the action owner; SHAs are immutable. Dependabot keeps SHA pins fresh.
- **`permissions:` declared at workflow or job level.** Default `GITHUB_TOKEN` permissions are restricted to `contents: read` at the org level; jobs requesting more (e.g., `id-token: write` for OIDC, `pull-requests: write` for bots) declare it explicitly.
- **Reusable workflows + composite actions for shared logic.** `uses: <org>/<repo>/.github/workflows/<file>.yml@<sha>` for cross-repo reuse. Inline duplication is a finding.
- **Concurrency control** on deploy workflows: `concurrency: group: deploy-${{ github.ref }}, cancel-in-progress: false`. Prevents overlapping deploys; preserves in-flight deploys when a new push arrives.
- **Self-hosted runners are hardened.** Ephemeral runners (created and destroyed per job) preferred over persistent runners; runners run in isolated subscriptions; secrets do not leak across jobs.
- **Workflow runs are auditable.** Logs retained per org policy; failed deploys produce alerts in the team's incident channel; deployment status is reflected in the Environment view.

## Common misuses

- Using `pull_request_target` without understanding the security implications (PR code runs with target-branch token). Cite the GitHub security docs before adopting.
- Storing Azure deployment secrets in repo secrets instead of using OIDC. OIDC is the production answer; secret-based auth is a finding.
- Skipping environment protection on production. Without environment protection rules, anyone with `write` to `main` can trigger a production deploy.

## Notes

- Pairs with `gh-advanced-security` (security gates: CodeQL, secret scanning, dependency review), `entra-id` + `managed-identity` (OIDC federation target), `key-vault` (secret retrieval at runtime via `azure/cli@v2`), `bicep` (typical deploy target), `mcsb` (DevOps Security control validation).
- Microsoft owns GitHub; Actions is a Microsoft-stack first-party surface despite the github.com URL.
