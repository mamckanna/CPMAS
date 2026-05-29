---
id: cosmos-db
name: Azure Cosmos DB
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/cosmos-db/
covers: [nosql, global-distribution, partition-key, consistency, ru, change-feed]
agent_use: Cite when the workload uses Azure Cosmos DB (NoSQL, MongoDB, Cassandra, Gremlin, or Table API); when reviewing partition-key design, RU sizing, consistency level, multi-region writes, or change-feed integration; or when justifying Cosmos DB vs a relational store.
volatility: medium
licensing: proprietary (Azure consumption)
last_verified: 2026-05-26
---

# Azure Cosmos DB

Globally distributed, multi-model NoSQL database with tunable consistency, SLA-backed latency, and per-container scaling. The default Azure choice when the access pattern is point-lookup or range-on-partition-key at high RPS with strict latency budgets; relational stores (`azure-sql-best-practices`, `postgres-flex`) win when joins or strong-consistency transactions dominate.

## Key requirements

- **Partition-key design is a Day-1 decision, not a Day-30 one.** Bad partition keys (low cardinality, hot tenant) require container rebuilds. The chosen key, its expected distribution, and a sample queries-by-partition section live in `decisions.md` before architecture is locked.
- **Request Unit (RU) sizing matches workload pattern.** Provisioned throughput for steady load; autoscale for bursty (max RU/s set with a documented ceiling); serverless for dev/test or sparse workloads.
- **Consistency level chosen, not left at default.** Session is the default; Bounded Staleness or Strong only when the data model requires it (each step up costs RU and latency); Eventual when the read pattern tolerates it.
- **Multi-region writes ("multi-master") only when conflict resolution is designed.** Last-write-wins is the default; custom resolution via stored procedure when the conflict shape matters. Multi-region writes change application semantics — they are not a magic HA switch.
- **Microsoft Entra authentication, not primary keys.** Workloads use `managed-identity` + RBAC; primary/secondary keys are limited to admin tools and rotated on a documented cadence.
- **Customer-managed key (CMK) for encryption-at-rest.** Production accounts use CMK stored in `key-vault`; key rotation policy documented.
- **Change feed for downstream integration.** Change feed via Azure Functions trigger or pull model is the supported way to propagate writes to search, cache, or analytics — not custom polling.
- **Defender for Cosmos DB enabled.** `defender-for-cloud` Defender for Azure Cosmos DB plan is on for production.

## Common misuses

- Designing as if it were SQL — cross-partition queries at high RPS will exhaust RU and surprise the bill. Model for the access path, not the entity.
- Treating Cosmos as a session store without TTL — items must have a TTL or the container grows unbounded.
- Picking Strong consistency reflexively. Most read paths are fine at Session; Strong cuts available throughput nearly in half and adds cross-region latency.

## Notes

- Pairs with `waf` (Performance + Reliability), `azure-architecture-center` (Cosmos reference architectures and partitioning guidance), `mcsb` (Data Protection), `key-vault`, `managed-identity`, `entra-id`, `defender-for-cloud`, `application-insights`.
- For relational workloads, see `azure-sql-best-practices` or `postgres-flex` instead.
