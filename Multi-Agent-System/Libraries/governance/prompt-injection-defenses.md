---
id: prompt-injection-defenses
name: Prompt injection defenses (layered)
category: governance
authority: community
url: https://owasp.org/www-project-top-10-for-large-language-model-applications/
covers: [prompt-injection, indirect-prompt-injection, output-validation, tool-allow-listing, content-filtering]
agent_use: Cite when designing or reviewing any feature where untrusted content (user input, retrieved documents, tool output, web content) enters a model prompt.
volatility: medium
licensing: open
last_verified: 2026-05-25
---

# Prompt injection defenses (layered)

Prompt injection is the unsolved problem of LLM security. There is no single defense; the working approach is **defense in depth**: multiple imperfect controls layered so that a single bypass does not become a full compromise.

This entry consolidates the practical layered model used in OWASP LLM Top 10 (LLM01), Anthropic / OpenAI / Microsoft guidance, and the published academic work as of mid-2026.

## Key requirements

Apply **all** of the layers below for any LLM feature that ingests untrusted content:

- **Treat all model input as untrusted.** Including: user input, retrieved documents (RAG), web fetches, tool outputs, file contents, MCP resource reads. The model is not a trust boundary.
- **Apply input filtering before the prompt.** Strip or escape known injection markers; flag suspicious patterns. This catches the easy cases.
- **Use a structured prompt boundary.** Mark untrusted content with delimiters and explicit instructions to the model that content inside the delimiters is data, not instructions. Imperfect but cheap.
- **Apply least privilege at the tool layer.** The model should not have access to high-impact tools when processing untrusted content. The orchestrator decides what tools are available based on the source of the content.
- **Validate model output against a schema** before any side-effecting action. Free-text output that triggers shell, SQL, or HTTP calls is the failure mode; schema-validated output that triggers a typed action is safer.
- **Require explicit human confirmation for high-impact actions.** Send-money, delete-data, send-email, deploy-to-prod operations get a human in the loop regardless of model confidence.
- **Apply post-response content filtering.** A content-safety filter on the response catches some classes of leaked secrets and policy violations.
- **Log everything.** Inputs, prompts, outputs, tool calls. Without logs, incident response is impossible.
- **Assume eventual bypass.** Design so that a successful injection at one layer does not yield a high-impact outcome — that's the point of the layering.

## Common misuses

- "We told the model to ignore instructions in user input." Useless on its own. The model is not the trust boundary.
- Schema validation on output but no human gate on high-impact actions. Schemas catch shape, not intent.
- Allowing the same agent to read untrusted content AND have access to high-privilege tools. Split into two agents with isolated context if you must do both in the same workflow.
- Logging only when something goes wrong. Logs after the fact don't help if you don't have them before.

## Notes

- Indirect prompt injection (where the malicious content arrives via retrieval or tool output, not direct user input) is the harder case. Most published bypasses are indirect.
- Pairs with `owasp-llm-top10` (LLM01 in particular) and with content-safety services for the filtering layer.
- This is an active research area. Re-verify defenses against current literature annually.
