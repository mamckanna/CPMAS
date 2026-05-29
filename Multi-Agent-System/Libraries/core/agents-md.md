---
id: agents-md
name: agents.md cross-tool convention
category: core
authority: community
url: https://agents.md
covers: [agent-entry-file, cross-tool-convention, repo-root-config]
agent_use: Cite when authoring or reviewing the root AGENTS.md file or when explaining cross-tool agent configuration to a user.
volatility: medium
licensing: open
last_verified: 2026-05-25
---

# agents.md cross-tool convention

A community convention for a single root-level `AGENTS.md` file read by AI coding agents on entry to a repository. Adopted by Cursor, OpenAI Codex CLI, Aider, Claude Code, and others.

## Key requirements

- Place a single `AGENTS.md` at the repository root. No alternate locations.
- Use plain markdown; no schema is enforced and no frontmatter is required.
- Recommended top-level sections: project facts, build/test commands, conventions, do-not-do list.
- Keep it short. Long instructions belong in tool-specific files (`.github/copilot-instructions.md`, `CLAUDE.md`, etc.).
- Treat `AGENTS.md` as the **lowest common denominator** read by every agent; treat tool-specific files as **overrides** layered on top.
- Do not put secrets, tokens, or environment-specific paths in `AGENTS.md`. It is checked in and read by all tools.
- When `AGENTS.md` and a tool-specific file disagree, the tool-specific file wins for that tool.

## Common misuses

- Treating `AGENTS.md` as a runbook. It is an entry-point summary; long-form runbooks belong in `docs/` and are referenced from `AGENTS.md`.
- Duplicating the same rules in `AGENTS.md` and `.github/copilot-instructions.md`. Use `AGENTS.md` for cross-tool rules; put VS Code-specific rules only in the Copilot file.
- Encoding multi-agent role definitions in `AGENTS.md`. The convention is silent on multi-agent topology; project-specific role rosters belong there only as a brief table pointing at richer chat-mode files.

## Notes

- The convention is widely adopted but **not a formal standard**. Treat it as durable but not versioned. Re-verify on agent host upgrades.
- See [`../_prior-art/agents-md.md`](../_prior-art/agents-md.md) for the broader survey.
