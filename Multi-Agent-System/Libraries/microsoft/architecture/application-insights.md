---
id: application-insights
name: Azure Monitor Application Insights
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview
covers: [apm, distributed-tracing, opentelemetry, sampling, live-metrics, alerts]
agent_use: Cite when the workload uses Application Insights for APM; when reviewing instrumentation (auto-instrumentation vs OpenTelemetry distro), sampling, custom dimensions, or alert design; or when defining the SLI/SLO observability story for an Azure workload.
volatility: medium
licensing: proprietary (Azure consumption — billed via Log Analytics workspace ingestion)
last_verified: 2026-05-26
---

# Azure Monitor Application Insights

Microsoft's APM feature within Azure Monitor: request, dependency, exception, and custom-event telemetry with distributed tracing and Live Metrics. Production-grade Application Insights resources are **workspace-based** — they store data in a `log-analytics` workspace and inherit its retention, RBAC, and export rules.

## Key requirements

- **Workspace-based resources only.** Classic (standalone) Application Insights is end-of-life; every resource is workspace-based and bound to a `log-analytics` workspace named in `decisions.md`.
- **OpenTelemetry distro for new instrumentation.** New .NET / Java / Python / Node.js workloads use the Azure Monitor OpenTelemetry distro (or vendor-neutral OTel + Azure Monitor exporter); the legacy classic SDK is maintenance-only.
- **Sampling is explicit, not "default and hope."** Ingestion sampling target or adaptive sampling rate is set on the resource; sampled-out telemetry is acknowledged in the SLI definition (e.g., "p99 latency from a 5% sample"). Always-emit critical operations via `SetSampling`.
- **Trace context propagated end-to-end.** W3C `traceparent` (and `tracestate` where applicable) propagated through HTTP, queue (`service-bus`), and Cosmos / SQL clients; distributed-trace continuity verified in the End-to-end transaction view.
- **Custom dimensions for business-relevant signals.** Tenant id, feature flag, model version, etc., attached as custom dimensions (cardinality bounded; never PII) so KQL queries can slice without re-instrumenting.
- **Alerts on SLOs, not on raw counts.** Alert rules attached to request-success-rate, p95 latency, and exception-rate burn-rate windows; static-threshold alerts only where a SLO is genuinely fixed.
- **Live Metrics restricted in production.** Live Metrics stream is gated by RBAC (it shows un-sampled telemetry including potentially sensitive data); reserved for incident response.
- **Diagnostic logs join the platform.** Resource is in the same subscription as `log-analytics`; access is by `entra-id` RBAC, not access keys.

## Common misuses

- Leaving the default ingestion-sampling on and then asking why "p99 latency from App Insights doesn't match production." It's a sample — say so in the SLI.
- Storing high-cardinality customer ids in custom dimensions without a retention/PII review. Custom dimensions are searchable; treat them like log fields under `ms-privacy-standard`.
- One Application Insights resource per microservice with no naming or workspace strategy. Group by application boundary, share a workspace per environment.

## Notes

- Pairs with `log-analytics` (mandatory backing store), `waf` (Operational Excellence), `azure-architecture-center` (observability reference architectures), `mcsb` (Logging and Threat Detection controls), `entra-id`.
- For infrastructure metrics (VM, AKS node, Service Bus throttling), Azure Monitor Metrics + Container Insights cover what Application Insights does not.
