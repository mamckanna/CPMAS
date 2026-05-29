---
id: key-vault
name: Azure Key Vault
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/key-vault/general/
covers: [secrets, keys, certificates, hsm, rotation, rbac]
agent_use: Cite when storing secrets, keys, or certificates for an Azure workload; when justifying that a credential is not in code or config; or when reviewing rotation, access-policy, or network-isolation decisions.
volatility: medium
licensing: proprietary (Azure consumption)
last_verified: 2026-05-25
---

# Azure Key Vault

Azure's managed service for secrets, cryptographic keys, and certificates. The default destination for any value that should not live in source, config files, or pipeline variables. Pairs with managed identity (`managed-identity`) so workloads authenticate to the vault without their own secret.

## Key requirements

- **Default storage for all secrets, keys, and certificates** in MS-stack workloads. Storing secrets in app settings, environment variables, or pipeline variables (other than as Key Vault references) is a finding.
- **Access via managed identity, not access keys.** Workloads authenticate as their managed identity; the identity is granted RBAC roles on the vault. Vault access keys do not exist; access policies / RBAC are the model.
- **RBAC authorization is the current default** (not legacy access policies). The two modes are exclusive per vault; pick RBAC for new vaults and document any deviation.
- **Least-privilege roles**: `Key Vault Secrets User` (read), `Key Vault Secrets Officer` (read/write/delete), `Key Vault Administrator` (full). Workload identities get the narrowest role they need; admin role goes through PIM (`entra-id`).
- **Soft-delete and purge protection are enabled.** Soft-delete is on by default and cannot be disabled; purge protection is opt-in and required for production. Without purge protection, a deleted vault or secret is unrecoverable to a malicious or accidental purge.
- **Private endpoint for production vaults.** Public network access is disabled; the vault is reached via a Private Endpoint inside the workload's VNet. Firewall rules with trusted services are the fallback for managed-service callers that don't yet support private endpoints.
- **Rotation policy for secrets and certificates.** Auto-rotation for supported secret types (e.g., storage account keys, certificates from integrated CAs); event-grid notifications drive rotation for the rest. Rotation cadence is named in `decisions.md`.
- **HSM-backed keys for high-assurance scenarios.** Standard vaults use software-protected keys; Premium vaults and Managed HSM (`azure-managed-hsm`) provide FIPS 140-2 Level 2/3 hardware-backed keys. The Compliance Officer cites the tier required.
- **Diagnostic logs to Log Analytics.** Every vault access is logged; production vaults stream `AuditEvent` and `AzurePolicyEvaluationDetails` to a workspace retained per compliance window.

## Common misuses

- Reading secrets at startup and caching forever. A rotated secret never reaches the running app. Use refresh-on-401, Key Vault references, or a short cache TTL.
- Granting `Key Vault Administrator` to workload identities "to keep things simple." That role can read every secret in the vault and modify access policy.
- One shared vault per environment for unrelated workloads. Vaults are cheap; isolate by workload to bound blast radius.

## Notes

- Pairs with `managed-identity` (auth without a credential), `entra-id` (RBAC + PIM for admins), `mcsb` (Data Protection domain), `bicep` / `avm` (vault provisioning).
- The Bring-Your-Own-Key (BYOK) story for Storage, SQL, and Cosmos resolves to Key Vault keys; encryption-at-rest with customer-managed keys (CMK) requires a Key Vault.
