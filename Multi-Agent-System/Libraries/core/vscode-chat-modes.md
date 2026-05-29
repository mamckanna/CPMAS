---
id: vscode-chat-modes
name: VS Code agent customization
category: core
authority: vendor
url: https://code.visualstudio.com/docs/copilot/copilot-customization
covers: [chatmodes, prompts, instructions, applyto-globs, mcp-config]
agent_use: Cite when authoring or reviewing .chatmode.md, .prompt.md, .instructions.md, copilot-instructions.md, or .vscode/mcp.json; when scoping agent tool allow-lists; or when explaining VS Code agent surface to a user.
volatility: high
licensing: vendor docs
last_verified: 2026-05-25
---

# VS Code agent customization

First-party surface for customizing GitHub Copilot Chat at the repository level. The runtime that the multi-agent system template deploys onto.

## Key requirements

- Repo-wide rules go in **`.github/copilot-instructions.md`**. Loaded on every Copilot turn. Keep short.
- Scoped rules go in **`.github/instructions/*.instructions.md`** with `applyTo:` glob frontmatter. Multiple matches concatenate.
- Custom chat modes go in **`.github/chatmodes/*.chatmode.md`** with `description:` and `tools:` frontmatter. The body is the system prompt for that mode.
- Reusable prompts go in **`.github/prompts/*.prompt.md`** with `description:` and `mode:` frontmatter. File name (minus `.prompt.md`) becomes the slash command.
- MCP server registration goes in **`.vscode/mcp.json`** at the workspace root.
- `tools:` in a chat mode is an **allow-list**. Tools not listed are not available to that mode.
- Tool names are VS Code-native (`codebase`, `search`, `editFiles`, `runCommands`, `runTasks`, `runTests`, `fetch`) plus any tools published by registered MCP servers.
- The user switches chat modes via the Copilot Chat picker; modes do not switch programmatically (no user-authored mode-to-mode dispatch as of mid-2026).
- `applyTo: "**"` makes an instruction file fire on every turn — use sparingly and keep those files short.
- Frontmatter field names and discovery paths are versioned with VS Code; re-verify on VS Code major updates.

## Common misuses

- Stuffing all rules into `copilot-instructions.md`. That file is loaded every turn — long content slows the agent and pollutes context. Split into `applyTo`-scoped instruction files.
- Granting all tools to every chat mode. The allow-list is a real boundary; use it to enforce role separation.
- Encoding sub-agent dispatch in chat-mode bodies. VS Code Copilot does not support programmatic mode-to-mode handoff for user-authored modes; design around mode-switching + stateless prompts.
- Putting prompts in `.prompt.md` files that are actually long-running multi-task pipelines. Prompts should be one task, one answer.

## Notes

- High volatility: this surface is the most likely layer to change between VS Code releases. The template is designed to be portable, so this is where version-pinned adjustments will land first.
- Cross-tool: `AGENTS.md` (read by all agents) and `.github/copilot-instructions.md` (read by Copilot) overlap. Convention: cross-tool rules in `AGENTS.md`, VS Code-specific rules only in the Copilot file.
- See [`../_prior-art/vscode-customization.md`](../_prior-art/vscode-customization.md) for the broader survey.
