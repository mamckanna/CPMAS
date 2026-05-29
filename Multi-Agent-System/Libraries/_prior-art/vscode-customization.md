# Prior Art: VS Code Agent Customization

## What it is

VS Code's first-party surface for customizing GitHub Copilot Chat agent behavior at the repository level. Four file types, plus MCP config:

| File / pattern | Purpose |
|---|---|
| `.github/copilot-instructions.md` | Repo-wide rules. Loaded on every Copilot turn. |
| `.github/instructions/*.instructions.md` | Scoped rules with `applyTo:` glob frontmatter. |
| `.github/chatmodes/*.chatmode.md` | Custom chat modes with system prompt + `tools:` allow-list. |
| `.github/prompts/*.prompt.md` | Reusable user prompts surfaced in the chat picker. |
| `.vscode/mcp.json` | MCP server registration for the workspace. |

Canonical docs: [code.visualstudio.com/docs/copilot/copilot-customization](https://code.visualstudio.com/docs/copilot/copilot-customization).

## Why it matters

This is the actual runtime our multi-agent system deploys onto. Any role separation we want (Orchestrator vs Builder vs Reviewer) has to map to a `.chatmode.md` file. Any sub-agent we want to invoke as a stateless task has to map to a `.prompt.md`. Any tool we want to surface has to be either a VS Code built-in or an MCP server.

## Surface details

### Chat modes (`.chatmode.md`)

```yaml
---
description: <short string>
tools: [<tool-name>, <tool-name>]
---

# Body is the system prompt for this mode.
```

- `tools:` is an allow-list. Tools not in this list are not available to the mode.
- Tool names are VS Code-native (`codebase`, `search`, `editFiles`, `runCommands`, `runTasks`, `runTests`, `fetch`) plus any MCP-published tools.
- The user switches modes via the picker in Copilot Chat.

### Instruction files (`.instructions.md`)

```yaml
---
applyTo: "**/*.ts"
description: <short string>
---

# Body is appended to system prompt when applyTo matches.
```

- `applyTo:` is a glob. Multiple matching files concatenate.
- `**` matches everywhere; use it for repo-wide rules layered on top of `copilot-instructions.md`.

### Prompts (`.prompt.md`)

```yaml
---
description: <short string>
mode: agent
---

# Body is the user-facing prompt template, surfaced via slash command.
```

- File name becomes the slash command (`kickoff.prompt.md` → `/kickoff`).
- `mode: agent` runs as an autonomous agent step.

## What we adopted

- All four file types, with strict role separation: chat modes per role, prompts per stateless task, instructions for cross-cutting rules.
- A `tools:` allow-list per chat mode to enforce role boundaries.
- An `applyTo: "**"` security instruction file that fires on every turn.
- `.vscode/mcp.json` registering filesystem + git as the baseline tool surface.

The citable distillation lives in [`../core/vscode-chat-modes.md`](../core/vscode-chat-modes.md).

## Cautions

- This surface is **vendor-specific** and **volatile**. Frontmatter field names and discovery paths have changed between VS Code versions and may change again. The multi-agent template is designed to be portable, so this is the layer most likely to need version-pinned adjustments.
- Cross-tool: `AGENTS.md` and the `.github/copilot-instructions.md` file overlap. Both get read by VS Code Copilot. The convention is: `AGENTS.md` for the cross-tool surface, `copilot-instructions.md` for VS-Code-specific rules.
- No native programmatic sub-agent dispatch (as of mid-2026) for user-authored chat modes. Mode switching is user-driven.
