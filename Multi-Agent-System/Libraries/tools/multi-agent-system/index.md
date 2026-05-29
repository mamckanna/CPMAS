# tools/multi-agent-system

Curated `id` subset cited by the multi-agent system template itself. This is the index a project uses when it adopts the template without picking up any product-specific libraries.

A project that adopts the template **must** have these entries available; everything else is optional.

## Required ids (cited by chat modes, prompts, instructions, and state templates)

### Core (from `core/`)

| id | Cited by | Purpose |
|---|---|---|
| `agents-md` | `AGENTS.md`, copilot-instructions | Cross-tool entry-file convention |
| `mcp` | `.vscode/mcp.json`, chat modes | Tool/resource protocol |
| `multi-agent-patterns` | All chat modes, `Design/SYSTEM-DESIGN.md` §6 | Topology taxonomy (orchestrator-worker, supervisor, handoff, etc.) |
| `vscode-chat-modes` | All chat modes, `Setup/SETUP.md` | Reference host surface |
| `state-and-handoffs` | All chat modes, state README, `handoff.prompt.md` | State discipline (append-only logs, overwriting payloads, locked manifests) |
| `compaction-and-recovery` | `recover.prompt.md`, `health-check.prompt.md`, every chat mode pre-flight | `checkpoint.md` integrity model |

### Governance (from `governance/`)

| id | Cited by | Purpose |
|---|---|---|
| `owasp-llm-top10` | `security.instructions.md`, Security Engineer, Reviewer | LLM-specific security baseline |
| `nist-ai-rmf` | Compliance Officer (Audit gate), RAI | Risk-management framing |
| `responsible-ai-principles` | Architect (Design phase), RAI | RAI vocabulary and posture |
| `prompt-injection-defenses` | `security.instructions.md`, Security Engineer | Defense-in-depth for LLM input |

## Optional ids (cited only if the project opts in)

### Frameworks (from `frameworks/`)

A project picks **zero or one** runtime framework. Cite only the chosen one.

| id | When to include |
|---|---|
| `langgraph` | Python project, state-graph topology |
| `autogen` | Python project, conversational multi-agent |
| `openai-agents-sdk` | OpenAI-stack project, handoff topology |
| `crewai` | Python project, small role-based crew |
| `anthropic-subagents` | Claude Code-hosted project |
| `semantic-kernel` | .NET/Python project, LLM features in existing app |
| `microsoft-agent-framework` | New MS-stack .NET agent-first project |

### Microsoft (from `microsoft/`)

Included only when the project is Microsoft-owned or Microsoft-targeted (`project-profile.ms_stack in {preferred, required}`). A project picks the entries it actually needs — not all 37. The framework choice (`microsoft-agent-framework` or `semantic-kernel`) is made in **Frameworks** above and is not duplicated here.

#### Architecture (`microsoft/architecture/`)

Frameworks (cross-cutting):

| id | When to include |
|---|---|
| `waf` | Any Azure workload — pillar trade-offs and WAF Review at design gates |
| `caf` | Greenfield Azure adoption, landing zones, governance baseline |
| `avm` | Any IaC work targeting Azure — AVM-Res / AVM-Ptn as default modules |
| `azure-architecture-center` | Reference architecture, cloud design patterns, decision trees |
| `azure-landing-zones` | Platform team or first workload landing in a tenant |

Workload services (cite when the workload actually uses them):

| id | When to include |
|---|---|
| `azure-sql-best-practices` | Workload uses Azure SQL Database / Managed Instance |
| `postgres-flex` | Workload uses Azure Database for PostgreSQL Flexible Server |
| `cosmos-db` | Workload uses Azure Cosmos DB — partition-key, RU, consistency design |
| `app-service` | Workload hosted on Azure App Service (Linux or Windows) |
| `aks` | Workload hosted on Azure Kubernetes Service |
| `service-bus` | Workload uses Azure Service Bus for queues / topics messaging |
| `application-insights` | Any Azure workload — APM, distributed tracing, alerts |
| `log-analytics` | Any Azure workload — diagnostic logs destination, KQL, Sentinel pairing |

#### Security (`microsoft/security/`)

| id | When to include |
|---|---|
| `sfi` | Any MS-built or MS-targeted workload — Secure Future Initiative posture |
| `sdl` | Engineering process — threat modeling, SAST/DAST/secret scanning gates |
| `mcsb` | Compliance baseline — per-service controls assessed by Defender for Cloud |
| `entra-id` | Any workload with users or workload identities on Azure |
| `key-vault` | Any workload storing secrets, keys, or certificates |
| `managed-identity` | Any Azure workload calling another Azure resource |
| `zero-trust` | Architecture posture — identity perimeter, microsegmentation, assume breach |
| `defender-for-cloud` | CSPM + workload protection across Azure (and multi-cloud) |

#### Governance (`microsoft/governance/`)

| id | When to include |
|---|---|
| `ms-rai-standard` | Any AI/agent workload — Impact Assessment, Sensitive Uses review |
| `ms-privacy-standard` | Any workload handling personal data on Microsoft platforms |
| `rai-toolbox` | Tabular ML models — fairness, interpretability, error analysis, counterfactuals |
| `ai-red-teaming` | Any generative AI workload — PyRIT-based red-team plan before release |
| `ms-accessibility` | Any user-facing surface — WCAG 2.2 AA + ACR/VPAT |
| `ms-oss-policy` | Any OSS adoption, contribution, or release decision in an MS-owned project |

#### Build (`microsoft/build/`)

| id | When to include |
|---|---|
| `gh-advanced-security` | Code hosted in GitHub — CodeQL, secret scanning, Dependabot, push protection |
| `azure-devops` | Code or pipelines hosted in Azure DevOps |
| `bicep` | IaC for Azure — `.bicep` as source of truth with AVM modules |
| `azure-pipelines` | CI/CD on ADO — YAML multi-stage with approvals + federated service connections |
| `gh-actions` | CI/CD on GitHub — OIDC to Azure, SHA-pinned actions, environments |

#### Docs (`microsoft/docs/`)

| id | When to include |
|---|---|
| `ms-style-guide` | Any prose — UI text, error messages, docs, release notes |
| `ms-learn` | Docs that publish to Microsoft Learn, or internal docs that adopt the conventions |

#### Agents (`microsoft/agents/`)

| id | When to include |
|---|---|
| `azure-ai-foundry` | Any AI workload on Azure — platform layer (hub/project, model catalog, evals) |
| `foundry-agent-service` | Hosted multi-tenant agents on Foundry (alternative to in-process MAF/SK) |
| `copilot-studio` | Low-code / business-user agents on M365, Teams, Dynamics, or Power Platform |

## How a project consumes this index

1. Run `/kickoff`. The Project Profile interview determines which optional layers apply.
2. Confirm every **required** id has a corresponding file under `Libraries/`. Librarian's first turn verifies this.
3. Pick **at most one** framework `id` (if any) and confirm its file is present.
4. If Microsoft-owned, add the `microsoft/` ids the project actually needs.
5. Validator + Reviewer + domain reviewers cite only ids from this index (plus the project's framework / microsoft additions).

## How this index relates to the operating model

The 23-mode roster, the 10-phase queue, the 9-file state model, and the 8 slash prompts are described in `Design/SYSTEM-DESIGN.md`. This index lists only the **external** references the template depends on; internal design conventions are not `id`'d here because they live in the design doc itself.

When the design doc cites an external source, it cites by `id` from this index. When a chat mode references a Library entry (e.g., "follow `owasp-llm-top10` for any LLM input handling"), the `id` resolves through this index to the entry file under `Libraries/`.

## How to extend

A downstream tool (e.g., a future MS-built lifecycle tool, or a product-specific extension) creates its own `tools/<tool-name>/index.md` listing the additional `id`s it requires on top of this base. Do not modify this file from a downstream tool — extend it via a new index file.
