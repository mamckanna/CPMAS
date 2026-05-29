---
id: managed-identity
name: Azure Managed Identity
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview
covers: [workload-identity, secretless, system-assigned, user-assigned, federated-credentials]
agent_use: Cite when a workload needs to call an Azure resource without storing a credential; when justifying the absence of a client secret; or when reviewing identity for any compute resource (App Service, Functions, AKS, Container Apps, VMs).
volatility: medium
licensing: proprietary (free; included with Azure resources)
last_verified: 2026-05-25
---

# Azure Managed Identity

Workload identity for Azure compute resources. The resource gets an Entra identity that Azure manages — no client secret, no rotation, no storage. The default authentication mechanism for any Azure-resource-to-Azure-resource call.

## Key requirements

- **Default workload identity for any Azure compute calling any Azure resource.** App Service, Functions, AKS workloads (via Workload Identity), Container Apps, VMs, Logic Apps, Container Instances, and Data Factory all support managed identity. Using a service principal with a client secret instead is a finding requiring a `decisions.md` exception.
- **User-assigned over system-assigned for shared identities.** System-assigned MI is tied to a single resource's lifecycle (deleted with the resource); user-assigned MI is a standalone Entra object that can be assigned to many resources and survives resource recreation. Production workloads default to user-assigned.
- **One identity per trust boundary.** A workload that calls Key Vault and a Storage account uses one MI; a different workload uses a different MI. Sharing one MI across unrelated workloads breaks least-privilege.
- **RBAC role assignments are how MI gets permissions.** The MI is granted Azure RBAC roles on the target resource at the narrowest scope possible (resource > resource group > subscription). Roles at subscription scope require justification.
- **Federated identity credentials for cross-cloud and CI.** For workloads running outside Azure (GitHub Actions, AWS, GCP, Kubernetes elsewhere) that need to call Azure, Workload Identity Federation issues short-lived tokens via OIDC trust. Service principals with secrets are deprecated for CI/CD.
- **Token acquisition via DefaultAzureCredential or equivalent.** Application code uses the Azure SDK's credential chain (Java, .NET, Python, JS, Go); never roll OAuth manually against the IMDS endpoint.
- **Tokens are cached by the SDK** with automatic refresh. Application code does not cache tokens itself.
- **Audit via Entra sign-in logs.** Managed identity sign-ins appear in the Entra sign-in logs (Workload Identity sign-ins blade). Stream to Log Analytics for retention.

## Common misuses

- Using a service principal "because we always have." If the calling resource is in Azure, MI is the right answer; service principals are for non-Azure callers (and Workload Identity Federation usually beats them there too).
- Assigning Owner or Contributor to a workload MI. The roles required are almost always more specific (e.g., `Key Vault Secrets User`, `Storage Blob Data Reader`).
- System-assigned MI on a resource that gets re-created by IaC. Every deploy mints a new principal ID; downstream RBAC assignments break. User-assigned MI survives.

## Notes

- Pairs with `entra-id` (the directory the MI lives in), `key-vault` (most common target), `mcsb` (Identity Management domain), `sfi` (identity pillar).
- For AKS, "managed identity" historically meant `aad-pod-identity` (deprecated). The current pattern is **Workload Identity** (federated credentials on a Kubernetes service account). The Architect names which model the cluster uses.
