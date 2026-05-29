# Prior Art: agents.md

## What it is

The `AGENTS.md` convention is a cross-tool agreement on a single root-level markdown file that any AI coding agent reads first when entering a repository. Originated by community contributors and adopted by Cursor, OpenAI Codex CLI, Aider, Claude Code, and others. Canonical site: [agents.md](https://agents.md).

## Why it matters

Before `AGENTS.md`, every agentic tool invented its own root file (`CLAUDE.md`, `.cursorrules`, `.aider.conf.yml`, `.github/copilot-instructions.md`). Cross-tool projects ended up with three or four overlapping files. `AGENTS.md` is the lowest-common-denominator entry point: one file every tool agrees to read.

## What it specifies (loosely)

- A single root `AGENTS.md` file.
- Free-form markdown content; no schema is enforced.
- Suggested sections: project facts, build/test commands, conventions, do-not-do list.
- Tool-specific files (`CLAUDE.md`, `.github/copilot-instructions.md`) remain valid and are layered on top.

## What it does **not** specify

- A schema for the body.
- A frontmatter format.
- Multi-agent role definitions.
- State, handoff, or memory conventions.

## What we adopted

- A root `AGENTS.md` per project — the cross-tool entry.
- Microsoft-first roster table inside it.
- Pointer to `.agents/state/` for shared state.

The citable distillation lives in [`../core/agents-md.md`](../core/agents-md.md).

## What we did not adopt

- The convention's silence on multi-agent topology — we layered our own four-role model on top.
- The convention's silence on state — we added `.agents/state/` as a project-local convention, not part of the spec.

## Cautions

- `AGENTS.md` is convention, not standard. Adoption is broad but informal.
- Tools differ on precedence when both `AGENTS.md` and tool-specific files exist. Treat tool-specific files as overrides.
