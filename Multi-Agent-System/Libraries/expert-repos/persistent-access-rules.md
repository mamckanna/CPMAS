# Persistent Access Rules for Expert Repos

## Purpose
Ensure all agents always have live, protocol-compliant access to every expert repo URL provided by the user, for code extraction, review, and curation—never summaries only.

## Rules
1. The file `Libraries/expert-repos/README-urls.md` is the canonical, persistent source of all expert repo URLs.
2. All agents must reference this file for every curation, extraction, or review task.
3. If a repo is not locally cloned, agents must use the live URL for code search, extraction, and validation.
4. Summaries, markdowns, or compactions are never a substitute for live repo access.
5. If a repo cannot be accessed, the agent must:
   - Log the failure and the attempted URL
   - Notify the user immediately
   - Attempt to restore access or request user action
6. These rules are enforced for all 61+ expert repos, including Drew’s Copilot and all others listed in `README-urls.md`.
7. Any agent or process that violates these rules must be flagged for correction and cannot proceed with curation.

## Implementation
- All curation, extraction, and review workflows must begin by reading `README-urls.md`.
- Agents must log the URL and access method used for every extraction.
- If a repo is updated, agents must always use the latest version from the live URL.
- These rules are to be treated as hardcoded and non-optional for all future sessions.

---

_Last updated: 2026-05-27_
