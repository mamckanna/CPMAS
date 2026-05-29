---
id: responsible-ai-principles
name: Responsible AI principles (industry-consensus)
category: governance
authority: community
url: https://oecd.ai/en/ai-principles
covers: [responsible-ai, fairness, accountability, transparency, privacy, safety, inclusiveness, reliability]
agent_use: Cite when authoring or reviewing an AI feature's design for ethical posture, when writing a brief Responsible AI Impact Assessment, or when explaining RAI vocabulary to a user.
volatility: low
licensing: open
last_verified: 2026-05-25
---

# Responsible AI principles

The set of ethics-of-AI principles that have converged across the OECD AI Principles, the EU's High-Level Expert Group guidelines, Microsoft's Responsible AI Standard, Google's AI Principles, and ISO/IEC 42001. The vocabulary every RAI conversation pulls from.

## Key requirements

For any AI feature, the project must address each of these and document its position. "Not applicable" is a valid position; "didn't consider" is not.

- **Fairness.** The system treats users and groups equitably. Identify protected attributes; test for disparate performance.
- **Reliability and safety.** The system performs reliably under normal conditions and degrades gracefully under abnormal ones. Define operating envelope and failure modes.
- **Privacy and security.** Personal data is collected, used, and stored lawfully and minimally. Pair with `owasp-llm-top10` for the security side.
- **Inclusiveness.** The system is usable by the full range of intended users, including those with disabilities. Pair with accessibility standards.
- **Transparency.** Users understand they are interacting with AI; system behavior and limitations are documented and discoverable.
- **Accountability.** A human is responsible for the system. Escalation paths are documented. Decisions are auditable.

Some frameworks add:

- **Human oversight.** Critical decisions retain human review.
- **Robustness.** The system resists adversarial input within its threat model.
- **Environmental impact.** Resource consumption is justified and minimized where feasible.

## Common misuses

- Treating RAI principles as a marketing checklist. They are design requirements; each requires a concrete position in the design document.
- Equating Responsible AI with bias testing. Bias is one principle; transparency, accountability, and human oversight are equally weighted.
- Citing "RAI compliance" without citing a specific framework. RAI is a principle space; specific compliance is against a specific framework (Microsoft RAI Standard, EU AI Act, ISO 42001, etc.).

## Notes

- For Microsoft-owned projects, the project-level RAI authority is Microsoft's Responsible AI Standard. Cite that (in the `microsoft/` folder when present) for Microsoft work; cite this entry for the general industry-consensus vocabulary.
- Pairs with `nist-ai-rmf` for risk-management framing and `owasp-llm-top10` for the security subset.
- Pairs with [`validation-and-recovery`](../core/validation-and-recovery.md) for the **Reliability and safety**, **Transparency**, and **Accountability** principles as they apply to agent-written state. Reliability: the system detects state-file corruption in seconds and degrades to a one-word `unhealthy` verdict instead of silently building on bad data. Transparency: every scan appends a hash manifest and per-check result to an append-only log that any reviewer can audit offline. Accountability: recovery actions are operator-driven (the `/recover` prompt prints commands, never executes them), so a named human stays in the loop for every rollback.
