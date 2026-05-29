---
id: log-analytics
name: Azure Monitor Log Analytics
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview
covers: [logs, kql, workspace-design, retention, data-export, sentinel]
agent_use: Cite when the workload sends diagnostic logs or metrics to a Log Analytics workspace; when reviewing workspace topology, table-tier choice (Analytics / Basic / Auxiliary / Archive), retention, RBAC, or KQL query design; or when pairing with Microsoft Sentinel.
volatility: medium
licensing: proprietary (Azure consumption — ingestion + retention + query)
last_verified: 2026-05-26
---

# Azure Monitor Log Analytics

Workspace-based log store for Azure Monitor. Backs `application-insights` and is the destination for diagnostic settings across Azure resources. KQL is the query language. The workspace is also the data plane for Microsoft Sentinel when SIEM is in scope.

## Key requirements

- **Workspace topology is a documented decision.** Hub-and-spoke (one shared workspace per environment) or distributed (one per workload) is justified in `decisions.md` against cost, RBAC isolation, and Sentinel coverage; ad-hoc per-resource workspaces are not allowed in production.
- **Table tier matches access pattern.** `Analytics` (default) for hot, frequently queried logs; `Basic`/`Auxiliary` for high-volume low-query logs (e.g., raw network flows) with cheaper ingestion but limited KQL; `Archive` for long-tail retention behind search jobs. The tier per table is named, not implicit.
- **Retention and archive set per table, not globally.** Default workspace retention is the floor; per-table retention overrides it where compliance or cost requires.
- **RBAC via `entra-id`, granular roles.** `Log Analytics Reader` / `Contributor` at workspace scope; resource-context RBAC for tenants that should only see their own resources' logs.
- **Diagnostic settings declared in IaC.** Every production resource has a diagnostic setting wired in `bicep` / `avm` to the workspace; ad-hoc portal-created settings are reconciled or removed.
- **Data export for long-term + non-KQL consumers.** Continuous export to Storage / Event Hub for SIEM, data lake, or compliance archive — not periodic manual exports.
- **KQL queries reviewed for cost.** Queries against large tables use `project` + time-bound filters; saved searches and workbook queries are reviewed against ingestion volume; expensive joins are documented.
- **Microsoft Sentinel onboarded explicitly when SIEM is in scope.** Sentinel runs on the same workspace; data-connector choices, analytic rules, and incident workflows are scoped in a separate Sentinel design — not a side effect of "we have logs."

## Common misuses

- One workspace per resource group "for isolation" — explodes ingestion cost, fragments KQL across workspaces, and makes Sentinel non-viable. Use resource-context RBAC instead.
- Leaving every table at Analytics tier when 80% of volume is one or two high-cardinality tables that nobody queries interactively. Move them to Basic/Auxiliary.
- Treating Log Analytics as a long-term audit archive without enabling data export. Native retention beyond ~2 years gets expensive; Archive + export to immutable storage is the supported pattern.

## Notes

- Pairs with `application-insights` (data plane), `mcsb` (Logging and Threat Detection), `defender-for-cloud` (uses the workspace as its data sink), `waf` (Operational Excellence), `azure-architecture-center` (workspace-design reference architectures), `bicep` + `avm` (diagnostic-settings IaC).
- Microsoft Sentinel sits on top of Log Analytics; it is a separate cost and a separate operational practice — not modeled as its own Library entry yet.
