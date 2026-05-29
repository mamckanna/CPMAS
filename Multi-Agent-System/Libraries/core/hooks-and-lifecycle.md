# Copilot Hooks and Lifecycle Events

This document describes the six Copilot lifecycle hook events and maps each to Stage-2 enforcement and validation roles for this project. It serves as the authoritative reference for hook-driven enforcement, validation, and attestation in the Multi-Agent System.

---

## Copilot Lifecycle Events

1. **sessionStart**
   - **Description:** Triggered when a new agent session begins.
   - **Stage-2 Role:**
     - Initialize session-level durability and integrity state
     - Log session metadata for attestation

2. **sessionEnd**
   - **Description:** Triggered when an agent session ends.
   - **Stage-2 Role:**
     - Finalize and persist session logs
     - Perform end-of-session attestation and integrity checks

3. **userPromptSubmitted**
   - **Description:** Triggered when a user submits a prompt.
   - **Stage-2 Role:**
     - Validate prompt for policy compliance
     - Log prompt for traceability and audit

4. **preToolUse**
   - **Description:** Triggered before a tool is invoked.
   - **Stage-2 Role:**
     - Enforce tool usage policies
     - Validate tool input integrity
     - Optionally block or mutate tool invocation

5. **postToolUse**
   - **Description:** Triggered after a tool completes.
   - **Stage-2 Role:**
     - Log tool output and side effects
     - Validate output integrity and truthfulness
     - Update attestation and recovery logs

6. **errorOccurred**
   - **Description:** Triggered when an error occurs during agent operation.
   - **Stage-2 Role:**
     - Log error details for recovery and audit
     - Trigger integrity and durability recovery mechanisms

---

## Stage-2 Enforcement and Validation Mapping

| Event               | Durability | Integrity | Attestation | Recovery |
|---------------------|:----------:|:---------:|:-----------:|:--------:|
| sessionStart        |    ✔️      |    ✔️     |     ✔️      |          |
| sessionEnd          |    ✔️      |    ✔️     |     ✔️      |    ✔️    |
| userPromptSubmitted |            |    ✔️     |     ✔️      |          |
| preToolUse          |            |    ✔️     |     ✔️      |          |
| postToolUse         |    ✔️      |    ✔️     |     ✔️      |    ✔️    |
| errorOccurred       |    ✔️      |    ✔️     |     ✔️      |    ✔️    |

---

## Implementation Notes

- Each hook receives event context as JSON and may enforce, log, validate, or recover as needed.
- PowerShell ports of reference hooks will be implemented in tools/multi-agent-system/hooks/.
- Threat pattern catalog and JSON schema validation will be integrated where applicable.

---

> For the full Copilot hooks spec, see Libraries/_prior-art/copilot-hooks.md.
> For Stage-2 validation and recovery details, see Libraries/core/validation-and-recovery.md.
