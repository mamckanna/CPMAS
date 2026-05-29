---
id: ms-rai-standard
name: Microsoft Responsible AI Standard v2
category: microsoft
authority: vendor
url: https://www.microsoft.com/en-us/ai/responsible-ai
covers: [responsible-ai, fairness, reliability, safety, privacy, inclusiveness, transparency, accountability]
agent_use: Cite when defining responsible-AI requirements for any AI/LLM feature in an MS-stack project; when justifying impact-assessment and oversight decisions; or when the RAI / Compliance Officer reviews an AI release.
volatility: medium
licensing: proprietary (Microsoft public framework)
last_verified: 2026-05-25
---

# Microsoft Responsible AI Standard v2

Microsoft's internal operating standard for building AI systems, made public in 2022 and refined since. The canonical "what does Microsoft mean by Responsible AI" reference, organized around six principles operationalized into goals and requirements. For MS-stack AI projects, RAI v2 is the framework cited by the `rai` conditional role and by the Compliance Officer's AI release gate.

## Key requirements

- **Six principles**: Fairness, Reliability & Safety, Privacy & Security, Inclusiveness, Transparency, Accountability. Every AI feature is assessed against all six; "N/A" requires written rationale.
- **Impact Assessment is mandatory before development.** Document intended uses, stakeholders, potential harms, deployment context, and known limitations. The IA is updated when intended uses or context change.
- **Fit-for-purpose review.** The deployment context determines the bar. A consumer chatbot, a clinical decision-support tool, and an internal summarization aid are not held to the same evidence standard.
- **Sensitive Uses review path.** Use cases that implicate consequential decisions about people (employment, finance, housing, criminal justice, biometric identification, etc.) trigger an internal Sensitive Uses review and require sign-off beyond the project team.
- **Transparency notes for foundation models / systems.** Each system has a published transparency note covering capabilities, limitations, intended uses, and evaluation methodology. The Documenter produces this artifact.
- **Human oversight is named.** For any AI output that can affect a person materially, the responsible human role and escalation path are named in `docs/operations.md`. "AI auto-decides" is not an acceptable answer.
- **Measurement before launch.** Quantitative evaluation against fairness, safety, groundedness, and other applicable metrics is required pre-launch and re-run on material changes.
- **Ongoing monitoring.** Post-launch metrics, incident channels, and red-team retests are scheduled; "we tested it once" is a finding.

## Common misuses

- Treating the principles as marketing language and skipping the operationalization (Goals → Requirements → Documentation). The standard's value is the operational layer.
- Confusing Microsoft's RAI principles with the company-wide `responsible-ai-principles` entry. The principles are public commitments; the **Standard** is the implementation framework that operationalizes them.
- Running an IA only at kickoff. The IA is a living artifact; the project's `docs/rai/` folder versions it.

## Notes

- Pairs with `responsible-ai-principles` (the public principles this standard implements), `nist-ai-rmf` (cross-framework alignment), `ms-privacy-standard` (Privacy & Security principle), `ms-accessibility` (Inclusiveness principle), `rai-toolbox` (operationalization tooling), `ai-red-teaming` (Reliability & Safety evidence).
- The Sensitive Uses categories evolve with deployment experience; the RAI lead re-verifies categories every 6 months.
