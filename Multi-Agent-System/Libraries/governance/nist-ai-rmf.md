---
id: nist-ai-rmf
name: NIST AI Risk Management Framework
category: governance
authority: standard
url: https://www.nist.gov/itl/ai-risk-management-framework
covers: [ai-risk-management, govern-map-measure-manage, ai-trustworthiness, ai-governance]
agent_use: Cite when establishing or reviewing AI governance posture, when writing a project's AI risk assessment, or when justifying RAI checkpoints.
volatility: low
licensing: open (US government work)
last_verified: 2026-05-25
---

# NIST AI Risk Management Framework

The US National Institute of Standards and Technology's voluntary framework (AI RMF 1.0, released January 2023, with a Generative AI Profile published 2024) for managing risks of AI systems. The most-cited neutral standard for AI risk management.

## Key requirements

The framework has four functions; treat each as a capability the project must demonstrate, not a phase:

- **Govern.** Establish AI risk governance: roles, responsibilities, policies, accountability. For a project, this means a documented owner, a documented escalation path, and a decision log for AI choices.
- **Map.** Identify and characterize the context of the AI system: purpose, users, data, downstream impacts, intended and foreseeable misuse. The Concept and Architecture phases of the multi-agent system map directly onto this.
- **Measure.** Quantify the risks identified in Map: accuracy, fairness, robustness, privacy, security, transparency. Requires explicit metrics and evaluation methodology, not impression.
- **Manage.** Apply controls proportional to risk: mitigation, monitoring, response. Track residual risk.

The Generative AI Profile (NIST AI 600-1, 2024) adds twelve generative-AI-specific risk categories:

- CBRN information / capabilities
- Confabulation (hallucination)
- Dangerous, violent, or hateful content
- Data privacy
- Environmental impacts
- Harmful bias / homogenization
- Human-AI configuration (over-reliance, anthropomorphism)
- Information integrity (mis/disinformation)
- Information security
- Intellectual property
- Obscene, degrading, abusive content
- Value chain and component integration

A project's risk register should explicitly address whichever of these twelve apply.

## Common misuses

- Treating AI RMF as a checklist to "pass." It is a continuous practice. A one-time risk assessment does not satisfy Govern/Manage.
- Skipping Measure because metrics are hard. The framework is explicit that risks you cannot measure should still be managed conservatively — but unmeasured risks must be acknowledged, not ignored.
- Citing AI RMF as authority for a specific control. The framework specifies what to do, not exactly how; pair with concrete control catalogs (e.g., MCSB for Azure deployments).

## Notes

- Low volatility for the core framework; the Generative AI Profile and accompanying guidance evolve faster — re-verify the Profile annually.
- Pairs with OWASP LLM Top 10 (`owasp-llm-top10`) for technical controls and with `responsible-ai-principles` for ethics framing.
- Pairs with [`validation-and-recovery`](../core/validation-and-recovery.md) for the Measure and Manage functions applied to agent state. The integrity log (`integrity-log.md`) is the audit artifact that satisfies Govern (documented decisions), Measure (per-scan SHA-256 baseline + per-check pass/fail/warn), and Manage (operator-runnable recovery path via `/recover`). For the GenAI Profile, this entry maps directly to **Information Integrity** and **Information Security** — it is how the project demonstrates those risks are continuously measured, not just acknowledged.
