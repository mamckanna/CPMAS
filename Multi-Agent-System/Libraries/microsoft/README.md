# Microsoft

First-party Microsoft references. **Opt-in**: include this folder's entries only when `project-profile.ms_stack in {preferred, required}`.

For an MS-owned project, entries here take precedence over external sources covering the same topic, per the Microsoft-first rule in `Template/AGENTS.md`.

## Layout

Organized into 6 subdomains. 37 entries total.

```
microsoft/
├── README.md                ← you are here
├── architecture/            ← cloud architecture frameworks + workload services (13)
├── security/                ← identity, secrets, baselines, defense (8)
├── governance/              ← RAI, privacy, accessibility, red-team, OSS (6)
├── build/                   ← CI/CD, IaC, supply-chain (5)
├── docs/                    ← writing style + docs platform (2)
└── agents/                  ← AI/agent platforms (3)
```

## Index

### architecture/

Frameworks (cross-cutting):

| id | Name | Authority | Volatility |
|---|---|---|---|
| `waf` | Azure Well-Architected Framework | vendor | medium |
| `caf` | Cloud Adoption Framework | vendor | medium |
| `avm` | Azure Verified Modules | vendor | high |
| `azure-architecture-center` | Azure Architecture Center | vendor | medium |
| `azure-landing-zones` | Azure Landing Zones | vendor | medium |

Workload services (data, compute, messaging, observability):

| id | Name | Authority | Volatility |
|---|---|---|---|
| `azure-sql-best-practices` | Azure SQL Best Practices | vendor | medium |
| `postgres-flex` | Azure Database for PostgreSQL — Flexible Server | vendor | medium |
| `cosmos-db` | Azure Cosmos DB | vendor | medium |
| `app-service` | Azure App Service | vendor | medium |
| `aks` | Azure Kubernetes Service | vendor | medium |
| `service-bus` | Azure Service Bus | vendor | medium |
| `application-insights` | Azure Monitor Application Insights | vendor | medium |
| `log-analytics` | Azure Monitor Log Analytics | vendor | medium |

### security/

| id | Name | Authority | Volatility |
|---|---|---|---|
| `sfi` | Secure Future Initiative | vendor | medium |
| `sdl` | Security Development Lifecycle | vendor | low |
| `mcsb` | Microsoft Cloud Security Benchmark | vendor | medium |
| `entra-id` | Microsoft Entra ID | vendor | medium |
| `key-vault` | Azure Key Vault | vendor | medium |
| `managed-identity` | Azure Managed Identity | vendor | medium |
| `zero-trust` | Microsoft Zero Trust | vendor | medium |
| `defender-for-cloud` | Microsoft Defender for Cloud | vendor | medium |

### governance/

| id | Name | Authority | Volatility |
|---|---|---|---|
| `ms-rai-standard` | Microsoft Responsible AI Standard v2 | vendor | medium |
| `ms-privacy-standard` | Microsoft Privacy Standard | vendor | medium |
| `rai-toolbox` | Responsible AI Toolbox | vendor | high |
| `ai-red-teaming` | AI Red Teaming (PyRIT) | vendor | high |
| `ms-accessibility` | Microsoft Accessibility Standards | vendor | medium |
| `ms-oss-policy` | Microsoft Open Source Policy | vendor | low |

### build/

| id | Name | Authority | Volatility |
|---|---|---|---|
| `gh-advanced-security` | GitHub Advanced Security | vendor | medium |
| `azure-devops` | Azure DevOps Services | vendor | medium |
| `bicep` | Bicep | vendor | medium |
| `azure-pipelines` | Azure Pipelines | vendor | medium |
| `gh-actions` | GitHub Actions | vendor | medium |

### docs/

| id | Name | Authority | Volatility |
|---|---|---|---|
| `ms-style-guide` | Microsoft Writing Style Guide | vendor | low |
| `ms-learn` | Microsoft Learn authoring conventions | vendor | medium |

### agents/

| id | Name | Authority | Volatility |
|---|---|---|---|
| `azure-ai-foundry` | Azure AI Foundry | vendor | high |
| `foundry-agent-service` | Foundry Agent Service | vendor | high |
| `copilot-studio` | Microsoft Copilot Studio | vendor | high |

## Cross-references to other Libraries folders

The following MS-owned entries live elsewhere because a more specific folder applies (per `_schema/conventions.md`):

- `microsoft-agent-framework` — in `frameworks/` (a project picks zero or one runtime framework).
- `semantic-kernel` — in `frameworks/` (same reason).

Cite by `id` regardless of folder.

## Renewal cadence

This folder has heavier `high`-volatility content (Foundry, Copilot Studio, AVM, RAI Toolbox, PyRIT). The Librarian's reference-phase pass re-verifies `high` entries every 3 months and `medium` entries every 6 months per `_schema/conventions.md`.
