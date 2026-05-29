---
id: sdl
name: Microsoft Security Development Lifecycle
category: microsoft
authority: vendor
url: https://www.microsoft.com/en-us/securityengineering/sdl/practices
covers: [secure-sdlc, threat-modeling, code-review, fuzzing, supply-chain, incident-response]
agent_use: Cite when defining the project's secure-development practices; when reviewing whether a feature has passed threat modeling, code analysis, and pre-release gates; or when the Builder/Reviewer chain needs an SDL-aligned checklist.
volatility: low
licensing: proprietary (Microsoft public guidance)
last_verified: 2026-05-25
---

# Microsoft Security Development Lifecycle

Microsoft's long-standing secure-development practice set. SDL defines the per-engineer, per-feature, per-release security activities that make code safe to ship. SFI (`sfi`) is the program; SDL is the practice.

## Key requirements

- **Twelve practices** (current iteration): security training, security requirements, security & privacy by design, threat modeling, define security tools, restrict open-source risk, use approved tools, secure coding & code review, security testing (SAST/DAST/IAST), fuzzing, configuration management, incident-response readiness. The project's `docs/security.md` lists how each is satisfied or why it is N/A.
- **Threat modeling is required before code**: every new feature with a trust boundary gets a threat model (STRIDE or equivalent) before implementation. Threat models live in `Libraries/<project>/threat-models/` or `docs/threat-models/` and are revisited when the feature changes.
- **SAST + DAST + secret scanning** are pipeline gates, not optional. GitHub Advanced Security (`gh-advanced-security`) is the default toolchain for MS-stack projects.
- **Approved-tools list**: compilers, linkers, package managers, and image bases come from an approved list. Unmaintained or unsigned tools require an exception decision.
- **Open-source supply-chain controls**: SBOM generation, dependency pinning, known-vulnerability scanning, and license review. `bicep` modules from `avm`, GitHub Actions pinned to commit SHAs, container base images from verified sources.
- **Fuzzing for parsers and protocol code**: any code that parses untrusted input gets a fuzz target. Coverage is tracked.
- **Pre-release gate**: no release proceeds without (a) zero unmitigated SAST high/critical findings, (b) current threat model, (c) SBOM, (d) incident response runbook. The Release Manager enforces.
- **Post-release**: vulnerability disclosure process, security updates within published SLAs, and incident retrospectives feed back into the threat model.

## Common misuses

- Doing threat modeling once at design and never updating it. A stale threat model is worse than none because it gives false assurance.
- Treating SAST findings as the security review. SAST catches known patterns; threat modeling catches design flaws. Both are required.
- Pinning to a tag instead of a SHA for GitHub Actions and external dependencies. Tags move; SHAs do not.

## Notes

- Pairs with `sfi` (parent program), `gh-advanced-security` (toolchain), `owasp-llm-top10` (LLM-specific extension of the secure-coding practice), `mcsb` (deployment-time security controls).
- Volatility is `low` because the practices change slowly; the toolchain underneath changes faster, but the practice set is stable.
