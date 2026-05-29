# Prior Art: Model Context Protocol (MCP)

## What it is

The Model Context Protocol is an open specification, originated by Anthropic in late 2024, for connecting LLM applications to external tools, resources, and prompts via a small JSON-RPC surface. It has since been adopted by VS Code, Cursor, Claude Code, OpenAI products, and a growing set of server implementations. Canonical site: [modelcontextprotocol.io](https://modelcontextprotocol.io).

## Why it matters

Before MCP, every host application invented its own tool-calling shape. Connecting Claude Code to a database, a filesystem, or a Git repo required custom plumbing per host. MCP standardizes:

- The transport (stdio / HTTP+SSE / WebSocket).
- The message shapes (tools, resources, prompts, roots, sampling).
- The discovery flow (a client asks a server what it offers; server returns a typed manifest).

The result is that any MCP-compatible host can talk to any MCP-compatible server.

## Surface (conceptual)

| Primitive | Purpose |
|---|---|
| `tools` | Functions the model can call (with JSON Schema for args). |
| `resources` | Read-only addressable content the model can fetch (files, DB rows, etc.). |
| `prompts` | Server-published prompt templates. |
| `roots` | The set of locations a server is scoped to. |
| `sampling` | Server-initiated LLM calls back through the client. |

## What we adopted

- MCP as the **default tool surface** for the multi-agent system template.
- Two baseline servers in `.vscode/mcp.json`: filesystem and git.
- GitHub MCP server commented out — opt-in per project.

The citable distillation lives in [`../core/mcp.md`](../core/mcp.md).

## What we did not adopt

- `sampling` (server-initiated calls back to the model). Not broadly supported by hosts as of mid-2026; revisit when VS Code Copilot ships stable support.
- Server-published prompts. We keep prompts under `.github/prompts/` for now because that's where VS Code surfaces them in the chat picker.

## Cautions

- High volatility. The spec is on an active version cadence; breaking changes are infrequent but real.
- Host support varies. A server feature may work in Claude Code and not in VS Code (or vice versa).
- Security: an MCP server runs with whatever privileges its process has. Treat the `mcp.json` allow-list as a sensitive file; do not commit secrets into env passthroughs.
