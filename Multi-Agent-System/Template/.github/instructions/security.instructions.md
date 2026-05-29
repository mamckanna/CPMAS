---
applyTo: "**"
description: "Security baseline applied to all files. Microsoft-first."
---

# Security instructions

## Baseline mandates (Microsoft-first)

These apply to every change, every file:

1. **SFI / SDL alignment** (refs: `sfi`, `sdl`). All new code must be secure-by-design and secure-by-default. Code that violates an SFI principle is a Reviewer **blocker**, not a comment.
2. **No secrets in source.** Use Managed Identity / Workload Identity Federation (ref: `managed-identity`) or Key Vault (ref: `key-vault`). Hardcoded keys, connection strings, or tokens are blockers.
3. **Least privilege.** RBAC and Azure Policy assignments must follow least-privilege patterns (refs: `entra-id`, `mcsb`).
4. **Threat modeling at design phase.** Any new external interface, identity boundary, or persisted-data store requires a STRIDE pass (ref: `sdl`) appended to `decisions.md`.
5. **Content Safety** is required around any user-supplied content fed into a generative model (refs: `azure-ai-foundry`, `ai-red-teaming`).

## What the Reviewer blocks

- Hardcoded credentials of any form.
- Public network exposure without an explicit decision entry.
- Disabled TLS / weak crypto.
- Untrusted deserialization paths.
- New PII collection without a `decisions.md` entry citing `ms-privacy-standard`.
- New AI features without an RAI Impact Assessment reference (ref: `ms-rai-standard`).
- Dependencies on packages with known critical CVEs.

## What the Reviewer warns (not blocks)

- Style violations from MCSB controls (ref: `mcsb`) that are recommended but not required.
- Missing telemetry / observability hooks.
- Tests with weak assertions.

## Internal MS guidance

Internal-only sources (e.g., 1ES pipeline mandates, internal SDL portal) live in the reference library under id `ms-internal-sec`. Until those URLs are wired in for this repo, the Reviewer must surface a **warning** on any change that touches identity, networking, or persisted secrets, noting that internal review may be required.
