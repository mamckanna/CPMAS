---
id: anthropic-subagents
name: Anthropic Claude Code sub-agents
category: framework
authority: vendor
url: https://docs.claude.com/en/docs/claude-code/sub-agents
covers: [sub-agents, isolated-context, claude-code, orchestrator-worker]
agent_use: Cite when a project runs in Claude Code and uses programmatic sub-agent dispatch, or when designing a sub-agent-style topology for any host.
volatility: high
licensing: vendor docs
last_verified: 2026-05-25
---

# Anthropic Claude Code sub-agents

The native sub-agent capability in Claude Code. A parent agent invokes a named sub-agent with a task brief; the sub-agent runs in an isolated context window with its own system prompt and tool allow-list, then returns a single result message.

## Key requirements

- Each sub-agent is defined by a markdown file with frontmatter: `name`, `description`, optional `tools`, and an optional `model` override. Body is the sub-agent's system prompt.
- Sub-agents are **invoked by name** from the parent agent. The parent decides when to dispatch; the sub-agent cannot dispatch back or sideways.
- Sub-agents run with an **isolated context window**. The parent passes a task brief; the parent's full context is not shared.
- Sub-agents are **stateless across invocations**. Persistent state lives outside the sub-agent (files, MCP resources, external stores).
- Sub-agents have **their own tool allow-list** in frontmatter. Omitting `tools` inherits the parent's full set — only do this for trusted internal sub-agents.
- Sub-agents return a **single result message** to the parent. They do not stream partial results.
- For parallel work, dispatch multiple sub-agents from the parent. They do not coordinate with each other.
- Sub-agent definitions live in `.claude/agents/` (project-scoped) or `~/.claude/agents/` (user-scoped). Project-scoped wins on name collision.

## Common misuses

- Letting sub-agents inherit the parent's full context. Defeats the isolation benefit and burns tokens.
- Dispatching sub-agents in chains (A → B → C). The pattern is parent-dispatches-leaves; chains belong in a state graph framework.
- Giving every sub-agent every tool. The point of sub-agents is least-privilege per task; respect it.
- Trying to replicate Claude Code sub-agents in VS Code Copilot. The host doesn't support programmatic dispatch for user-authored modes — use mode-switching + stateless prompts instead.

## Notes

- This is the **most directly applicable** reference for the multi-agent system template's sub-agent model. We approximate it in VS Code Copilot via mode-switching + `.prompt.md` files; in Claude Code, native sub-agents are the cleaner fit.
- For cross-host portability, keep sub-agent system prompts host-agnostic (no Claude-Code-specific commands in the prompt body).
