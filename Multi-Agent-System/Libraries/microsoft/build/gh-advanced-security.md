---
id: gh-advanced-security
name: GitHub Advanced Security
category: microsoft
authority: vendor
url: https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security
covers: [sast, secret-scanning, dependency-review, supply-chain, codeql, dependabot]
agent_use: Cite when defining the project's code-security toolchain; when reviewing pipeline gates for SAST, secret scanning, or dependency hygiene; or when the Security Engineer enforces SDL practices on a GitHub-hosted repo.
volatility: medium
licensing: proprietary (per-committer license; included with GHEC certain tiers)
last_verified: 2026-05-25
---

# GitHub Advanced Security

GitHub's bundle of code-security features (now sold as GHAS, partially unbundled into GHAS Secret Protection and Code Security as of 2025). The default code-security toolchain for MS-stack repos hosted on GitHub. Implements the SDL (`sdl`) practice set's code-security and supply-chain practices.

## Key requirements

- **CodeQL SAST on every PR.** CodeQL is the default static analyzer for supported languages (C/C++, C#, Go, Java/Kotlin, JavaScript/TypeScript, Python, Ruby, Swift). Custom queries and the security-extended query suite are enabled for production repos.
- **Secret scanning + push protection on by default.** Secret scanning detects committed secrets in history; push protection blocks the push that would commit one. Both are non-negotiable for any repo touching production.
- **Dependency review on PRs.** New or changed dependencies are scanned against the GitHub Advisory Database; high/critical vulnerabilities block the PR.
- **Dependabot alerts + version updates.** Dependabot raises PRs for vulnerable or out-of-date dependencies on a schedule. Auto-merge is configured for low-risk updates with passing tests.
- **Security advisories for the repo's own published artifacts.** When the repo ships a package or image, security advisories are filed via GitHub's draft-advisory flow with a CVE coordinated where applicable.
- **Branch protection enforces gates.** Required status checks include CodeQL, secret-scanning, dependency-review, and the test suite. Direct push to `main` is forbidden; PRs require review.
- **Custom autofix and copilot-assisted remediation** (where licensed) propose fixes for CodeQL findings; the developer reviews and merges. Auto-applying autofix without review is not a substitute for review.
- **Findings have owners and SLAs.** Critical: 7 days; High: 30 days; Medium: 90 days (or per organizational policy). Past-SLA findings are escalated.
- **SARIF outputs are archived.** CodeQL and third-party SARIF results are stored alongside release artifacts for audit.

## Common misuses

- Enabling alerts without enforcing them in branch protection. Alerts without enforcement become a backlog, not a control.
- Allowing PR authors to dismiss their own security findings without secondary review. Dismissals require Security Engineer (or equivalent) sign-off.
- Treating Dependabot PRs as noise to batch-close. Vulnerable-dependency PRs are the primary supply-chain control; close-without-merge requires a documented exception.

## Notes

- Pairs with `sdl` (parent practice set), `gh-actions` (CI surface), `azure-devops` (alternative platform; comparable features under the Azure DevOps brand), `mcsb` (DevOps Security control domain), `defender-for-cloud` (the DevOps security view consolidates GHAS findings with Azure runtime findings).
- For Azure DevOps repos, the equivalent feature set is "Advanced Security for Azure DevOps"; cite that and this entry together when the project uses both platforms.
