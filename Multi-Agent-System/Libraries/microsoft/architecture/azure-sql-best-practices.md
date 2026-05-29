---
id: azure-sql-best-practices
name: Azure SQL Database — Best Practices
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/azure-sql/database/performance-guidance
covers: [azure-sql, performance, ha-dr, security, backup, indexing]
agent_use: Cite when the workload uses Azure SQL Database or Managed Instance; when reviewing tier sizing, HA/DR, backup retention, or query performance decisions; or when justifying connection-pool, retry, and identity choices against Azure SQL.
volatility: medium
licensing: proprietary (Azure consumption)
last_verified: 2026-05-26
---

# Azure SQL Database — Best Practices

Microsoft's consolidated guidance for running Azure SQL Database and Azure SQL Managed Instance — performance tier selection, high-availability and disaster-recovery topology, security baseline, backup and retention, and query-design patterns. The Database Engineer cites this alongside `waf` (Reliability + Performance pillars) and `mcsb` (Data Protection) when `project_profile.ms_stack in [preferred, required]` and the data layer is Azure SQL.

## Key requirements

- **Service tier matches workload pattern.** General Purpose for most OLTP; Business Critical for low-latency + In-Memory OLTP + read-scale replicas; Hyperscale for >4 TB and rapid backup/restore; Serverless for intermittent / dev/test. Tier choice is recorded in `decisions.md`.
- **Connection via Microsoft Entra (managed identity), not SQL auth.** Workload identities authenticate to Azure SQL using `managed-identity` + `entra-id`. SQL-authentication accounts are limited to break-glass and explicitly justified.
- **Geo-redundant backups + PITR retention named.** Point-in-time restore (1–35 days) and long-term retention (weekly/monthly/yearly) configured per RPO requirement. The retention window is recorded in the artifact manifest, not left at default.
- **Active geo-replication or auto-failover groups for HA/DR.** Production workloads define an explicit failover topology — failover-group with read-only listener, secondary region named, and an RTO target validated by `sre`.
- **Transparent Data Encryption (TDE) with customer-managed key (CMK).** TDE is on by default with a service-managed key; production workloads switch to CMK in `key-vault` and document key rotation.
- **Auditing + Defender for SQL enabled.** Server-level auditing streams to Log Analytics; `defender-for-cloud` Defender for SQL plan is on (vulnerability assessment + advanced threat protection).
- **Private endpoint for production.** Public network access disabled; private endpoint inside the workload's VNet; public endpoint only via explicit firewall allow-list when private-link is not feasible.
- **Query patterns favor parameterization, batched writes, and resilient retry.** Transient-fault retry policy is in the data-access layer; bulk operations use `SqlBulkCopy` or `MERGE` rather than row-by-row.

## Common misuses

- Sizing on raw DTU/vCore peak from on-premises SQL Server without re-baselining against Azure SQL's I/O profile (Hyperscale and Business Critical have very different IOPS characteristics).
- Treating elastic pool as a free performance bucket. Pools are for *predictable aggregate* load, not for hiding hot-tenant problems.
- Disabling auditing or sending audit logs to the same storage account they protect (circular trust). Audit goes to a separate, RBAC-restricted destination.

## Notes

- Pairs with `waf` (Reliability and Performance pillars), `azure-architecture-center` (data reference architectures), `mcsb` (Data Protection control domain), `key-vault` (CMK), `managed-identity` + `entra-id` (auth), `defender-for-cloud` (Defender for SQL).
- For PostgreSQL workloads on Azure, see `postgres-flex` instead.
- For NoSQL / globally-distributed scenarios, see `cosmos-db` (when authored). For analytics, the destination is Synapse / Fabric, which are out of scope for this entry.
