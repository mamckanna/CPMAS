---
id: aks
name: Azure Kubernetes Service
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/aks/
covers: [kubernetes, container-orchestration, node-pools, networking, rbac, upgrades]
agent_use: Cite when the workload runs on AKS; when reviewing cluster topology, networking (Azure CNI vs Overlay), node-pool design, identity (workload identity), or upgrade strategy; or when justifying AKS vs Container Apps vs App Service for a workload.
volatility: medium
licensing: proprietary (Azure consumption); upstream is Kubernetes (open source)
last_verified: 2026-05-26
---

# Azure Kubernetes Service

Microsoft's managed Kubernetes offering. The right choice when the workload genuinely needs Kubernetes — multi-container pods, complex network policies, custom controllers, or an existing Kubernetes operations practice. For simpler container workloads, Azure Container Apps is the lower-overhead default.

## Key requirements

- **Workload identity, not pod-mounted service principals.** Pods authenticate to Azure services via AKS workload identity (`entra-id` federated credential + `managed-identity`); AAD Pod Identity (legacy) is end-of-life.
- **Azure CNI Overlay or Azure CNI for new clusters.** Kubenet is legacy. Overlay is the default for IP-conservation in large clusters; standard Azure CNI when every pod needs a routable VNet IP.
- **Private cluster + private endpoints in production.** API server is private (no public endpoint); ingress goes through Application Gateway for Containers, AGIC, or a managed nginx ingress controller terminating inside the VNet.
- **System and user node pools separated.** System node pool runs `kube-system`; user workloads run on dedicated user pools sized for the workload class. Taints/tolerations enforce the separation.
- **Cluster autoscaler + Karpenter / Node Auto-Provisioning where supported.** Autoscale parameters and pod-disruption budgets are documented; HPA on each Deployment based on CPU / memory / custom metrics.
- **Upgrades follow the AKS support policy.** Cluster + node-pool Kubernetes versions are within N-2 of the latest GA; auto-upgrade channel (`patch` or `stable`) is on; planned-maintenance windows declared.
- **Defender for Containers enabled.** `defender-for-cloud` Defender for Containers plan is on; runtime threat detection, vulnerability scanning of registry images, and admission control are active.
- **Diagnostic settings stream to Log Analytics (`log-analytics`).** Control-plane logs (`kube-apiserver`, `kube-audit`, `kube-audit-admin`) and container insights are wired; retention named in artifact manifest.

## Common misuses

- Picking AKS because "Kubernetes is the standard," then operating a single-replica Deployment with no HPA and no PDB. If the workload doesn't need K8s primitives, the right answer is Container Apps or `app-service`.
- Storing kubeconfig credentials in CI rather than using federated workload identity from `gh-actions` / `azure-pipelines` for cluster access.
- Skipping admission-control policies (Azure Policy add-on, OPA Gatekeeper, or Kyverno) — production clusters enforce baseline pod security and image-source controls.

## Notes

- Pairs with `waf` (Reliability + Operational Excellence), `azure-architecture-center` (AKS reference architectures), `caf` (landing-zone subscription patterns for AKS), `managed-identity` + `entra-id`, `defender-for-cloud`, `application-insights`, `log-analytics`, `bicep` / `avm` for cluster provisioning.
- Compute-platform siblings: `app-service` (PaaS HTTP), Container Apps (serverless containers — no dedicated entry yet), Azure Functions (event-driven).
