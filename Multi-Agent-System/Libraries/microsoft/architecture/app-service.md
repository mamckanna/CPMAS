---
id: app-service
name: Azure App Service
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/app-service/
covers: [paas, web-apps, api-apps, deployment-slots, scaling, networking]
agent_use: Cite when the workload runs on Azure App Service (Linux or Windows); when reviewing slot-based deployment, autoscale, VNet integration, or identity decisions; or when justifying App Service vs Container Apps vs AKS for a given workload.
volatility: medium
licensing: proprietary (Azure consumption)
last_verified: 2026-05-26
---

# Azure App Service

Managed PaaS for web apps, REST APIs, and mobile back-ends on Linux or Windows. The default Azure compute target for stateful and stateless HTTP workloads that do not need container or Kubernetes-level control. Pairs with deployment slots for zero-downtime release patterns.

## Key requirements

- **Authentication via managed identity, not connection-string secrets.** App settings reference Key Vault (`key-vault`) via `@Microsoft.KeyVault(...)` syntax; the app's system- or user-assigned managed identity (`managed-identity`) authenticates to downstream services.
- **VNet integration for production.** Regional VNet integration enables outbound calls into a private network; inbound traffic on production goes through a Private Endpoint or App Gateway / Front Door, with the public hostname disabled or locked down.
- **Deployment slots for release.** Production releases use slot-swap (typically `staging` → `production`) with warm-up rules; direct deploys to production are limited to dev/test plans.
- **HTTPS-only + minimum TLS 1.2 (1.3 where supported).** HTTP redirected to HTTPS; client-certificate auth or App Gateway termination per the security model.
- **Diagnostic logs to Log Analytics (`log-analytics`).** App-service logs, HTTP logs, and platform logs stream to a workspace; Application Insights (`application-insights`) is wired for request / dependency / exception telemetry.
- **Autoscale rules defined, not left at fixed instance count.** Scale-out rules on CPU / memory / queue depth with a documented floor/ceiling in `decisions.md`; Premium v3 or Isolated SKU for production-scale workloads.
- **Always On enabled for production.** Prevents the app from idling out and incurring cold-start latency; not applicable to Consumption / Free tiers.

## Common misuses

- Storing secrets in app settings as plaintext rather than as Key Vault references.
- Using deployment slots as "long-lived environments" instead of as swap targets — slots share the App Service Plan and contend for resources.
- Picking App Service for a workload that needs sidecars, raw container orchestration, or Pod-level network policies (the right choice is Container Apps or `aks`).

## Notes

- Pairs with `waf` (Reliability + Performance), `azure-architecture-center` (web app reference architectures), `key-vault`, `managed-identity`, `entra-id`, `application-insights`, `log-analytics`.
- Sibling compute platforms: Azure Container Apps (containerized, serverless), `aks` (full Kubernetes), Azure Functions (event-driven serverless). App Service is the default when none of those constraints apply.
