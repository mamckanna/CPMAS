---
id: mcp
name: Model Context Protocol
category: core
authority: standard
url: https://modelcontextprotocol.io
covers: [tool-protocol, agent-tools, resources, prompts, json-rpc]
agent_use: Cite when registering, configuring, or reviewing MCP servers; when designing tool surfaces for agents; or when explaining tool integration to a user.
volatility: high
licensing: open
last_verified: 2026-05-25
---

# Model Context Protocol (MCP)

Open spec for connecting LLM applications to external tools, resources, and prompts via JSON-RPC. Originated by Anthropic; adopted by VS Code, Cursor, Claude Code, OpenAI, and a broad server ecosystem.

## Key requirements

- An MCP server exposes one or more of: **tools**, **resources**, **prompts**, **roots**.
- Transport is one of: stdio, HTTP+SSE, or WebSocket. Stdio is the default for local servers.
- Tools must declare a JSON Schema for their arguments; servers should not accept unschema'd input.
- Resources are read-only and addressable by URI; they must not perform side effects.
- A client discovers a server's capabilities at handshake; clients must not assume capabilities not advertised.
- Servers must declare a protocol version on handshake; clients must reject incompatible versions rather than silently degrade.
- An MCP server runs with its host process's privileges. Treat the server config (e.g., `.vscode/mcp.json`) as security-sensitive.
- Never embed long-lived secrets in server arg lists. Use environment variables passed through host config, and document required env vars.
- Servers should be **idempotent and stateless** where possible. State that must persist belongs in resources or external storage, not in server process memory.
- Servers must handle cancellation; long-running tool calls should support being interrupted by the client.

## Common misuses

- Treating MCP as a generic RPC framework and shoving non-LLM workloads through it. MCP is scoped to LLM-tool integration; use a real RPC stack for anything else.
- Registering an MCP server with broader filesystem or network scope than the agent needs. Apply least privilege; pass explicit roots.
- Assuming feature parity across hosts. A `prompts` or `sampling` capability that works in Claude Code may not work in VS Code Copilot.
- Hand-rolling a server when an existing community server covers the surface (`@modelcontextprotocol/server-filesystem`, `mcp-server-git`, vendor servers).

## Notes

- High volatility. The spec ships breaking-ish changes on a release cadence; pin server versions in production configs.
- A community catalog of servers lives under the `modelcontextprotocol` GitHub org and at community indexes.
- See [`../_prior-art/mcp.md`](../_prior-art/mcp.md) for broader survey context.
