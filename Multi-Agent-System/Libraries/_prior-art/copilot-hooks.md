# Copilot Hooks Spec (Official)

> This file contains the official Copilot hooks specification, as referenced in the awesome-copilot repository. It is intended as a reference for implementing hook-driven enforcement and lifecycle event handling in this project.

---

<!--
This file should be updated with the verbatim content of the Copilot hooks spec from the authoritative source (e.g., awesome-copilot/docs/README.hooks.md or equivalent).
-->

## Copilot Lifecycle Hook Events

Copilot supports six lifecycle hook events:

1. **sessionStart**
2. **sessionEnd**
3. **userPromptSubmitted**
4. **preToolUse**
5. **postToolUse**
6. **errorOccurred**

Each event allows custom scripts (hooks) to be executed at key points in the agent’s lifecycle. Hooks can be used for governance, logging, validation, attestation, and more.

### Event Descriptions

- **sessionStart**: Triggered when a new agent session begins.
- **sessionEnd**: Triggered when an agent session ends.
- **userPromptSubmitted**: Triggered when a user submits a prompt.
- **preToolUse**: Triggered before a tool is invoked.
- **postToolUse**: Triggered after a tool completes.
- **errorOccurred**: Triggered when an error occurs during agent operation.

### Hook Implementation

Hooks are typically implemented as executable scripts (e.g., Bash, PowerShell) that receive event context as JSON via stdin or environment variables. They can:
- Enforce policies
- Log actions
- Validate or mutate event data
- Block or allow actions

### Example Hook Schema

```json
{
  "event": "preToolUse",
  "sessionId": "...",
  "tool": "...",
  "input": { ... },
  "user": "...",
  "timestamp": "..."
}
```

### Reference
- [awesome-copilot/docs/README.hooks.md](https://github.com/drewolson/awesome-copilot/blob/main/docs/README.hooks.md)
- [awesome-copilot/tools/hooks/](https://github.com/drewolson/awesome-copilot/tree/main/tools/hooks)

---

> Replace this stub with the full, verbatim Copilot hooks spec content as needed for implementation or compliance.
