---
id: service-bus
name: Azure Service Bus
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/service-bus-messaging/
covers: [messaging, queues, topics, sessions, dead-letter, transactions]
agent_use: Cite when the workload uses Azure Service Bus for asynchronous messaging; when reviewing queue-vs-topic choice, session ordering, dead-letter handling, or duplicate detection; or when justifying Service Bus vs Event Hubs vs Event Grid vs Storage Queue.
volatility: medium
licensing: proprietary (Azure consumption)
last_verified: 2026-05-26
---

# Azure Service Bus

Enterprise messaging broker with queues (point-to-point) and topics + subscriptions (pub/sub). The right Azure messaging choice for transactional workflows, ordered processing within a session, and at-least-once delivery with explicit lock/complete semantics. Event Hubs is the choice for high-throughput telemetry; Event Grid is the choice for reactive eventing; Storage Queue is the lowest-cost option without advanced features.

## Key requirements

- **Microsoft Entra authentication, not SAS keys.** Workload identities use `managed-identity` + Service Bus RBAC roles (`Azure Service Bus Data Sender` / `Receiver` / `Owner`); SAS policies are limited to legacy clients and rotated on a documented cadence.
- **Queues for point-to-point, topics + subscriptions for fan-out.** A single subscriber → queue; multiple subscribers with independent filtering → topic. The choice is named in `decisions.md`, not implicit.
- **Sessions when order matters within a partition key.** Without sessions, ordering across messages is not guaranteed at scale. Sessions add latency overhead and reduce parallelism — used only when the consumer requires order.
- **Dead-letter queue (DLQ) consumed, not ignored.** Every queue and subscription has an associated DLQ; a documented operator process drains and triages dead-lettered messages on a defined cadence, not "when someone notices."
- **Lock duration matches processing time + buffer.** Default 60s; explicitly tuned for the consumer's longest expected message handling. Auto-renew is preferred over a long fixed lock.
- **Duplicate detection enabled for idempotency-sensitive flows.** Duplicate-detection window matches the upstream retry window; consumers still designed idempotent where possible.
- **Private endpoint + IP filter for production.** Public network access disabled; namespace reached via Private Endpoint in the workload's VNet.
- **Diagnostic settings to Log Analytics (`log-analytics`).** Operational logs + metrics streamed; key alerts on active-message-count, DLQ depth, and throttling events.

## Common misuses

- Treating Service Bus as a high-throughput telemetry pipe. Above ~2000 msg/s sustained per entity it gets expensive and contended — that workload belongs on Event Hubs.
- Auto-complete on the consumer with no exception handling — a thrown exception silently completes the message and the work is lost. Use peek-lock with explicit complete/abandon.
- Ignoring DLQ growth. A monotonically increasing DLQ is a latent incident.

## Notes

- Pairs with `waf` (Reliability), `azure-architecture-center` (messaging reference architectures and choice guidance Event Grid vs Event Hubs vs Service Bus), `managed-identity`, `entra-id`, `application-insights`, `log-analytics`.
- Messaging-platform siblings: Event Hubs (high-throughput telemetry), Event Grid (reactive event routing), Storage Queue (cheap simple FIFO). The architecture-center decision tree resolves the right one.
