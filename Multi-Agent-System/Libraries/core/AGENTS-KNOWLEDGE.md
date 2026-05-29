# MAS Agent Knowledge Base Integration

All MAS agents are required to automatically leverage the following resources for code generation, review, planning, and debugging:

- Libraries/expert-repos/PowerShell-best-practices.md
- Libraries/expert-repos/debug-checklist.md
- Libraries/expert-repos/index.md (all expert repo summaries)
- Libraries/expert-repos/README-urls.md (for navigation)
- Libraries/expert-repos/curation-checklist.md (for curation standards)
- Libraries/core/validation-and-recovery.md (core MAS patterns)
- Libraries/frameworks/ (for agent, orchestration, and workflow patterns)
- Libraries/microsoft/ (for Microsoft-specific architecture, security, and build standards)
- [Libraries/expert-repos/automation.md](../expert-repos/automation.md) — Automation: PowerShell, Python, Azure, CI/CD, IaC, SOAR, workflow

Agents must:
- Always consult curated requirements and patterns before generating or reviewing code.
- Use cross-links to pull in all relevant context automatically.
- Prefer curated requirements over raw URLs or external docs.
- Update curated files when new patterns or lessons are learned.

This ensures all agents operate at the highest standard and avoid repeated errors or missed best practices.
