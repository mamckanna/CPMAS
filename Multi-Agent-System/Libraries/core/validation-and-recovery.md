---
id: validation-and-recovery
name: Persistence, integrity, and recovery validation
category: core
authority: standard
url: https://git-scm.com/docs/git-fsck
covers: [persistence, integrity, fsync, git-fsck, sha256-readback, trust-domain, recovery]
agent_use: Cite when designing or running `/health-check`'s persistence-integrity checks (checks 7–11), when configuring the `integrity:` block of project-profile.md at kickoff, or when investigating a suspected disk/agent truthfulness failure.
volatility: low
licensing: convention (this library)
last_verified: 2026-05-26
---

# Persistence, integrity, and recovery validation

A normative model for the three layers of validation that sit **below** content correctness: did the bytes land on disk, are they unaltered, and can we independently confirm both without trusting the agent that wrote them. Pairs with [compaction-and-recovery](compaction-and-recovery.md) (which covers context-side recovery) and [state-and-handoffs](state-and-handoffs.md) (which defines the state files being validated).

## Stage-2: Hook-Driven Enforcement

All Stage-2 validation and recovery enforcement is now driven by Copilot lifecycle hooks. Each validation layer—durability, integrity, and truthfulness—is mapped to one or more Copilot hook events, ensuring that checks, logging, and recovery actions are triggered at the correct points in the agent lifecycle.

- **Lifecycle mapping:** See [hooks-and-lifecycle.md](hooks-and-lifecycle.md) for the authoritative mapping of Copilot events to validation and recovery roles.
- **Enforcement:** Hooks invoke the relevant checks (fsync, hash, readback, etc.), log results, and update the integrity log as part of their event handling.
- **Recovery:** On error or unhealthy verdicts, hooks trigger recovery routines and surface rollback candidates as described below.

### Mapping of Validation Layers to Copilot Events

| Validation Layer | Copilot Events                |
|------------------|-------------------------------|
| Durability       | sessionStart, sessionEnd, postToolUse, errorOccurred |
| Integrity        | sessionStart, sessionEnd, userPromptSubmitted, preToolUse, postToolUse, errorOccurred |
| Truthfulness     | sessionEnd, postToolUse, errorOccurred |

This mapping ensures that all critical state transitions and error conditions are covered by explicit, auditable enforcement logic.

## Why this entry exists

An agent reporting "file written" is not the same as a file existing on disk. A file existing on disk is not the same as the file's bytes being correct. Correct bytes today are not the same as correct bytes after a crash, a backup-restore, or a malicious edit. These are three distinct failure modes — durability, integrity, truthfulness — and each has its own industry-standard mitigation. Without explicit checks, an agent loop can run for hours on a corrupted or fabricated state and produce a report that looks healthy.

This entry codifies the checks `/health-check` runs (checks 7–11), the `integrity:` profile block that gates them, and the bootstrap requirements that have to be in place before any of it works.

## Key requirements


## Common misuses


---

## Stage-2 Enhancements: References and Validation

All Stage-2 validation, durability, and recovery enforcement is implemented via PowerShell Copilot lifecycle hooks and validated by comprehensive test scripts. Each validation layer—durability, integrity, and truthfulness—is mapped to one or more Copilot hook events, ensuring that checks, logging, backup, and recovery actions are triggered at the correct points in the agent lifecycle.

- **Lifecycle mapping:** See [hooks-and-lifecycle.md](hooks-and-lifecycle.md) for the authoritative mapping of Copilot events to validation and recovery roles.
- **Enforcement:** Hooks invoke the relevant checks (fsync, hash, backup, independent readback, etc.), log results, and update the integrity log as part of their event handling. All logic is refactored for reuse across hooks.
- **Backup and attestation:** Every log or state write is followed by a timestamped backup and hash attestation, with verification against the integrity log.
- **Independent readback:** After every write, an independent-process readback (e.g., PowerShell `Get-FileHash`) confirms the on-disk state matches the agent's claim, closing the trust gap.
- **Automated handoff/resume:** On session start or error, hooks check for handoff files and auto-resume the session, ensuring seamless continuity.
- **Operator summary:** On session start, an operator summary report is generated, highlighting recent events, warnings, and the current integrity state.
- **Edge and stress testing:** Dedicated test scripts cover normal, missing, empty, corrupted, locked, and large file scenarios, as well as rapid-fire and permission error cases.
- **Recovery:** On error or unhealthy verdicts, hooks trigger recovery routines and surface rollback candidates as described above.

### References

- PowerShell hooks: `tools/multi-agent-system/hooks/sessionStart.ps1`, `postToolUse.ps1`, `errorOccurred.ps1`
- Test scripts: `tests/hooks/test-sessionStart.ps1`, `test-postToolUse.ps1`, `test-errorOccurred.ps1`, `test-stress.ps1`

All features and requirements are validated by these scripts. Operator summary and handoff/resume logic are included in the enforcement model.

## Notes

- The `Libraries/_prior-art/` folder contains research links underpinning each layer; the canonical pointers are: Postgres durability docs (fsync), git docs on `core.fsync` and `git fsck`, restic design notes (content-addressed backups), and the ZFS/Btrfs/ReFS filesystem-checksum papers.
- This entry is **layered above** [compaction-and-recovery](compaction-and-recovery.md). Compaction recovery rebuilds in-context state from state files; persistence validation guarantees those state files are themselves trustworthy. Without persistence validation, compaction recovery is rebuilding from possibly-corrupted ground truth.
- The `integrity:` profile block is the single source of truth for what runs. Chat modes and prompts must not introduce their own integrity checks outside this gate — that fragments the trust model and makes the IL log incomplete.
- The `/recover` prompt consults `integrity-log.md` to classify the breach (context vs. integrity) and, when the most recent IL `Verdict` is `warn`/`unhealthy`, surfaces the last-known-good `git_head` plus up to two alternates as rollback candidates. `/recover` prints the rollback commands; the operator runs them and then re-runs `/health-check` to close the loop with a new IL entry.
- **Governance mapping.** This entry is the evidence layer for three governance authorities. [`owasp-llm-top10`](../governance/owasp-llm-top10.md) — LLM05 (Improper Output Handling) and LLM06 (Excessive Agency) assume the agent's written state matches the state the runtime sees; the Stage-1 manifest + `git fsck` + remote-sync checks are the smallest credible proof of that assumption. [`nist-ai-rmf`](../governance/nist-ai-rmf.md) — the IL log is the artifact that satisfies the Measure and Manage functions for agent state, and maps to the GenAI Profile's **Information Integrity** and **Information Security** categories. [`responsible-ai-principles`](../governance/responsible-ai-principles.md) — Reliability, Transparency, and Accountability are demonstrated by the one-word verdict, the append-only hash manifest, and the operator-driven (never auto-executed) recovery path respectively.
