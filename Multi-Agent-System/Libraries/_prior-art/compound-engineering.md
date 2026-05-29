# Prior Art: Compound Engineering

## What it is

Compound Engineering ("CE") is an opinionated agentic engineering pipeline distributed as a Claude Code / VS Code plugin. It packages skills, agents, and personas for the full software lifecycle: brainstorm → ideate → plan → work → review → commit → PR → CI watch. Loaded as a plugin in the user's environment; see the loaded skill list under `c:\Users\mmcka\.copilot\installed-plugins\compound-engineering-plugin\`.

## Why it matters

CE is the most fully-realized example of an agentic lifecycle pipeline running on a real coding host. It's a working proof that:

- Phase-gated workflows (brainstorm → plan → work → review → ship) can be packaged as a coherent agent suite.
- Persona-based review (adversarial reviewer, correctness reviewer, security reviewer, etc.) outperforms a single "review" pass.
- Stateless sub-agents (e.g., `ce-best-practices-researcher`, `ce-git-history-analyzer`) compose into useful pipelines.
- Skills (markdown files with a `description` frontmatter) are a workable unit of agentic capability.

## What we adopted

- The **phase-gated lifecycle** shape: Concept → Architecture → Design → Plan → Build → Audit. CE's flow is brainstorm-heavy and ship-oriented; ours is concept-heavy and audit-oriented. Different defaults, same skeleton.
- The **persona-as-reviewer** idea: cross-cutting reviewers are a distinct tier (CE has `ce-correctness-reviewer`, `ce-security-reviewer`, `ce-architecture-strategist`, etc.; we collapse those to one Reviewer mode by default and document the expansion path).
- The **stateless prompt as sub-task** pattern: CE invokes named sub-agents; we invoke `.prompt.md` files.
- The **decision-log discipline**: CE records learnings under `docs/solutions/`; we record decisions under `.agents/state/decisions.md`.

## What we did not adopt

- CE's framework lock-in (Claude Code-first; VS Code plugin is a port). Our template is VS Code Copilot-native.
- CE's heavy persona count by default. Real projects benefit from 1–3 reviewers, not 9. We start small and expand on evidence.
- CE's auto-PR-and-CI-watch as a default. We require human gates at major phases.

## Cautions

- CE is a product, not a standard. Its surface evolves; what we adopted is the **shape**, not the specific commands.
- CE-specific commands (`ce-brainstorm`, `ce-plan`, etc.) only work where the plugin is installed. Don't bake those into the template; rely on the underlying patterns.
