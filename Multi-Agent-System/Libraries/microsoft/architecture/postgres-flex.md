---
id: postgres-flex
name: Azure Database for PostgreSQL — Flexible Server
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/
covers: [postgresql, flexible-server, ha-dr, performance, networking, backup]
agent_use: Cite when the workload uses Azure Database for PostgreSQL — Flexible Server; when reviewing HA mode, networking model (VNet-integrated vs public), backup retention, or extension allow-list; or when justifying connection / identity / pooling choices.
volatility: medium
licensing: proprietary (Azure consumption); engine is PostgreSQL (open source)
last_verified: 2026-05-26
---

# Azure Database for PostgreSQL — Flexible Server

Microsoft's managed PostgreSQL offering with VNet integration, zone-redundant HA, and finer engine-version control than the legacy Single Server SKU. Flexible Server is the *only* recommended deployment model for new workloads — Single Server is on retirement. The Database Engineer cites this when `project_profile.ms_stack in [preferred, required]` and the engine choice is PostgreSQL.

## Key requirements

- **Flexible Server only — not Single Server.** Single Server is in retirement; new workloads provision Flexible Server. Existing Single Server deployments have a documented migration plan in `decisions.md`.
- **VNet-integrated deployment for production.** Production servers use the private-access (VNet-injected) networking model; public-access mode with firewall is acceptable only for dev/test and explicitly named.
- **Zone-redundant HA when zonal SLA matters.** Same-zone HA covers compute failure; zone-redundant HA covers a full zone outage and is the production default for workloads with a multi-zone RTO target.
- **Microsoft Entra authentication enabled.** `managed-identity` + `entra-id` is the workload auth path; PostgreSQL local roles are limited to schema ownership and break-glass.
- **PITR window + geo-restore configured.** Point-in-time restore retention (1–35 days) and, for cross-region DR, geo-redundant backup with geo-restore. The retention window is in the artifact manifest, not at default.
- **Extension allow-list reviewed.** Only extensions on the supported allow-list are installable; the workload's required extensions (`pg_stat_statements`, `pgcrypto`, `pgvector`, etc.) are enumerated in `decisions.md` and confirmed supported before architecture is locked.
- **Server parameters tuned, not left at default.** `max_connections`, `shared_buffers`, `work_mem`, and autovacuum settings reviewed for the workload's connection pattern; PgBouncer enabled when connection counts are bursty.
- **Defender for open-source databases + audit logs.** `defender-for-cloud` Defender for open-source databases plan is on; `pgaudit` extension is enabled with logs streaming to Log Analytics for production.

## Common misuses

- Picking Single Server "because the docs come up first." It's retired; pick Flexible Server.
- Public-access networking in production "because VNet integration is hard." VNet is the production default; document and justify any deviation.
- Installing an extension not on the supported list, then discovering it at migration time. Resolve the extension list before locking architecture.
- Forgetting that Flexible Server's HA failover briefly disconnects clients — application retry logic is required (same as any managed DB).

## Notes

- Pairs with `waf` (Reliability + Performance pillars), `azure-architecture-center`, `mcsb` (Data Protection), `key-vault` (CMK), `managed-identity` + `entra-id`, `defender-for-cloud` (Defender for open-source databases).
- For SQL Server workloads on Azure, see `azure-sql-best-practices`.
- For Azure Database for MySQL — Flexible Server, the patterns are analogous; a dedicated entry is not yet authored.
