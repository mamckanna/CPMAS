---
id: owasp-llm-top10
name: OWASP Top 10 for LLM Applications
category: governance
authority: standard
url: https://owasp.org/www-project-top-10-for-large-language-model-applications/
covers: [llm-security, prompt-injection, supply-chain, output-handling, model-dos]
agent_use: Cite when reviewing any LLM-touching surface for security; when writing a Reviewer security pass; or when justifying input/output guardrails.
volatility: medium
licensing: open (CC-BY-SA)
last_verified: 2026-05-25
---

# OWASP Top 10 for LLM Applications

The OWASP project's consensus list of the most critical security risks in LLM applications. The standard reference for "is this LLM feature reviewed for security."

## Key requirements

The 2025 list (re-verify the URL for the current numbering):

- **LLM01: Prompt Injection.** Treat all model input (including retrieved documents and tool outputs) as untrusted. Never let model output directly trigger high-privilege actions without a confirmation step or output schema validation.
- **LLM02: Sensitive Information Disclosure.** Filter PII, secrets, and proprietary data out of prompts and out of model outputs. Apply both pre-prompt and post-response checks.
- **LLM03: Supply Chain.** Pin model versions, plugin versions, and dataset sources. Verify provenance for any open-weight model or community plugin.
- **LLM04: Data and Model Poisoning.** Validate training and fine-tuning data sources. For RAG, validate the corpus and the indexing pipeline.
- **LLM05: Improper Output Handling.** Never pass model output directly to a shell, SQL executor, code interpreter, or system command without schema validation and sanitization.
- **LLM06: Excessive Agency.** Apply least privilege to agent tools. An agent should not have access to a tool just because the model "might want" it.
- **LLM07: System Prompt Leakage.** Assume the system prompt will leak. Do not put secrets, keys, or proprietary logic in it.
- **LLM08: Vector and Embedding Weaknesses.** Validate inputs to embedding pipelines. Watch for embedding inversion and cross-tenant leakage in shared vector stores.
- **LLM09: Misinformation / Hallucination.** For high-stakes outputs, require citation, grounding, or human review.
- **LLM10: Unbounded Consumption.** Apply rate limits, token caps, and cost ceilings. Long-running agent loops without budgets are an availability and cost risk.

## Common misuses

- Treating LLM01 (prompt injection) as solvable by prompt engineering alone. It is not; you also need output schema validation, least-privilege tools, and post-response filters.
- Ignoring LLM10 (unbounded consumption) for internal tools. Internal LLM features have wrecked bills and triggered outages too.
- Applying these only to user-facing chatbots. Every LLM call in a pipeline is in scope.

## Notes

- The list is versioned (2023, 2025, ...); cite the current version explicitly in any Reviewer pass.
- Pairs with NIST AI RMF (`nist-ai-rmf`) for risk-management framing.
- Pairs with [`validation-and-recovery`](../core/validation-and-recovery.md) for the agent-state-integrity surface: LLM05 (Improper Output Handling) and LLM06 (Excessive Agency) both assume the agent's written state is the state the runtime sees. The Stage-1 manifest + `git fsck` + remote-sync checks are the smallest credible evidence that an agent's "I saved your changes" is true byte-for-byte; without them, LLM05/LLM06 controls are trusting an unverified persistence layer.
