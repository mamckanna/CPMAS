---
id: ai-red-teaming
name: Microsoft AI Red Teaming (PyRIT)
category: microsoft
authority: vendor
url: https://github.com/Azure/PyRIT
covers: [red-teaming, adversarial-testing, prompt-injection, jailbreak, harmful-content, pyrit]
agent_use: Cite when planning or executing adversarial evaluation of a generative-AI feature; when producing safety evidence for the `ms-rai-standard` Reliability & Safety requirement; or when the Security Engineer + RAI role design a pre-release red-team plan.
volatility: high
licensing: open (MIT)
last_verified: 2026-05-25
---

# Microsoft AI Red Teaming (PyRIT)

Microsoft's open-source framework for adversarial evaluation of generative-AI systems, plus the published methodology Microsoft uses internally for AI red-teaming. PyRIT (Python Risk Identification Tool) automates the orchestrator + scorer + memory loop that human red-teamers run; the methodology gives the structure around it. For MS-stack generative-AI features, this is the canonical safety-evaluation framework.

## Key requirements

- **Red-team plan is required before release for any generative-AI feature with external-facing surface or consequential internal use.** The plan covers harm categories, attack techniques, success criteria, and exit conditions.
- **Eight harm categories** (Microsoft taxonomy): violence, hate / unfairness, sexual, self-harm, jailbreaks, copyrighted content leakage, ungrounded outputs (hallucination), and code/security vulnerabilities. The plan names which categories apply.
- **Attack techniques are catalogued.** Direct prompt injection, indirect (via retrieved content), encoding/obfuscation, multi-turn manipulation, role-play, payload smuggling. PyRIT's converters and orchestrators cover the catalog; new techniques are added as the threat landscape evolves.
- **PyRIT components: orchestrators, prompt converters, targets, scorers, memory.** The orchestrator drives the attack; converters transform seed prompts; targets are the system under test; scorers classify responses; memory persists the run for audit and replay.
- **Both single-turn and multi-turn attacks.** Multi-turn jailbreaks and crescendo-style attacks require multi-turn orchestrators; single-turn-only testing misses the dominant real-world failure modes.
- **Scorers must be validated.** Auto-scorers (LLM-as-judge, classifier-based) need a human-labeled sample to estimate precision/recall before they drive release decisions.
- **Findings feed mitigations and evaluation set.** Every successful attack becomes either (a) a mitigation in system prompt, content filter, or RAG/grounding, plus (b) a regression test in the evaluation set. Findings without one of these are unresolved.
- **Documentation is non-negotiable.** PyRIT memory + a written red-team report (scope, methodology, findings, mitigations, residual risk) are required artifacts. The report is cited at the Release gate.
- **Red-team is iterative, not one-shot.** Material model, prompt, or RAG-source changes re-trigger red-teaming on impacted categories.

## Common misuses

- Treating red-team as a checklist of canned prompts. Canned-prompt corpora are a starting point; novel attacks targeting this system's affordances are the value.
- Running red-team only against the model. The feature is the model + system prompt + retrieval + tools + filters; red-team the composite system, not just the LLM call.
- Failing scorer validation. An unvalidated auto-scorer can declare safety where there is none.

## Notes

- Pairs with `ms-rai-standard` (Reliability & Safety evidence), `azure-ai-foundry` (Foundry's safety evaluations integrate similar concepts and consume PyRIT outputs), `owasp-llm-top10` (the standard harm taxonomy intersection), `sdl` (red-team is the AI-era extension of fuzzing).
- Volatility is `high`: the technique catalog and PyRIT API evolve frequently; re-verify quarterly.
