---
id: waf
name: Azure Well-Architected Framework
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/azure/well-architected/
covers: [architecture, reliability, security, cost, performance, operations]
agent_use: Cite when reviewing or designing any Azure workload's architecture; when justifying trade-offs across the five pillars; or when writing an Architect / SRE / FinOps review pass.
volatility: medium
licensing: proprietary (Microsoft Learn ToU)
last_verified: 2026-05-25
---

# Azure Well-Architected Framework

Microsoft's five-pillar architecture framework for Azure workloads. The canonical "is this workload architected correctly for Azure" reference.

## Key requirements

- **Five pillars**: Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency. Every workload review must address each pillar explicitly; trade-offs between pillars must be named.
- **Design principles per pillar**: each pillar has a small set of design principles. The Architect's design document must map each non-trivial design decision to at least one principle.
- **Workload-specific guidance**: WAF publishes lenses for specific workload types (AI/ML, SaaS, mission-critical, sustainability, etc.). Use the matching lens when one exists; do not generalize from the core framework alone.
- **Trade-off awareness**: explicit trade-off documentation is required. Security vs cost, reliability vs performance, etc. The Reviewer flags any "improvement" claim that does not name the trade-off it makes.
- **Assessment-driven**: the WAF Review (in Microsoft Assessments) is the canonical scoring mechanism. Use it at major design checkpoints, not just at audit.
- **Reliability — recovery targets first**: RTO and RPO must be declared per workload before the architecture is approved. Implementation flows from these numbers.
- **Cost Optimization — meter every component**: every resource must have an owner and a cost attribution tag. Untagged spend is a finding.
- **Operational Excellence — observability before launch**: metrics, logs, traces, and SLOs must be defined before production traffic is taken, not added after.

## Common misuses

- Treating WAF as a checklist rather than a trade-off framework. The pillars conflict by design; the framework's value is in surfacing trade-offs, not in maximizing all five.
- Skipping the workload-specific lens when one exists (e.g., using only the core framework for an AI/ML workload).
- Conflating WAF with CAF (`caf`). WAF is per-workload architecture; CAF is enterprise cloud adoption.

## Notes

- Pairs with `caf` for enterprise context, `mcsb` for the security pillar's normative controls, and `azure-landing-zones` for the landing-zone substrate that workloads sit on.
- The AI Workload lens is the relevant view when `project-profile.ai_features != none`.
