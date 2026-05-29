---
id: autogen
name: AutoGen / AG2
category: framework
authority: vendor
url: https://microsoft.github.io/autogen/
covers: [conversational-multi-agent, group-chat, agent-roles, python]
agent_use: Cite when a project picks AutoGen (or the AG2 community fork) as its agent runtime, or when designing conversational multi-agent flows.
volatility: high
licensing: open (CC-BY-4.0 / MIT for code)
last_verified: 2026-05-25
---

# AutoGen / AG2

A multi-agent framework originally from Microsoft Research that models multi-agent systems as **conversations** between named agents. AG2 is the community-led fork; both retain the conversational model. Python is the primary language.

## Key requirements

- Model agents as named **roles with system prompts**. Each role has a clear charter.
- For multi-agent coordination, use **group chat** with a designated speaker selection strategy (round-robin, manager-selected, or LLM-selected). Avoid free-for-all selection in production.
- Cap conversation turns. Conversational frameworks can loop indefinitely; set a `max_turns` and a termination condition.
- Use **tool agents** (agents that exist purely to run a tool) rather than embedding tools directly in conversational agents when the tool's role is well-scoped.
- For human-in-the-loop, use the framework's `UserProxyAgent` pattern explicitly; do not fake it with custom polling.
- Persist conversation transcripts. Without them, debugging a multi-agent disagreement is impossible.
- Watch the **token budget** carefully — conversational multi-agent can burn tokens fast when agents quote each other.

## Common misuses

- Using AutoGen for tasks an augmented LLM would do fine. Conversational multi-agent is overkill for most workflows.
- Letting the speaker-selection LLM pick freely. Production runs benefit from rule-based selection.
- Skipping `max_turns`. Conversational loops without bounds are a cost and reliability risk.

## Notes

- AutoGen and AG2 have diverged somewhat since the community fork. Pick one explicitly per project.
- Microsoft's broader agent investment is moving toward Microsoft Agent Framework (`microsoft-agent-framework`); AutoGen remains useful for research and conversational scenarios but is not the recommended path for new MS-internal .NET projects.
