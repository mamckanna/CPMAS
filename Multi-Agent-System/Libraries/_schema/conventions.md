# Library Conventions

## ID naming

- Kebab-case, lowercase ASCII.
- Short but unambiguous. Prefer `mcsb` over `microsoft-cloud-security-benchmark` because it's the standard's own acronym.
- No version numbers in ids. Version info goes in `name` and `notes`.
- No vendor prefixes for vendor-owned standards (e.g., `mcsb`, not `ms-mcsb`). Use prefixes only to disambiguate (`ms-style` vs `gh-style`).
- Ids never get renamed once published. Deprecate via `superseded_by`.

## Authority tiers

| Tier | Meaning | Examples |
|---|---|---|
| `standard` | Formal spec, ISO/NIST/IEEE/IETF/OWASP/W3C, or de-facto industry standard | NIST AI RMF, OWASP LLM Top 10, MCP, agents.md |
| `vendor` | First-party documentation from the owner of the product or service | Anthropic docs, Microsoft Learn, VS Code docs |
| `community` | Community-maintained guidance with broad adoption | Diátaxis, awesome-* repos |
| `research` | Academic papers or research-org reports | Microsoft Research papers, Anthropic research |

The Reviewer prefers higher tiers when two entries cover the same topic.

## Volatility tiers and renewal cadence

| Volatility | What it means | Renewal cadence | Examples |
|---|---|---|---|
| `low` | Formal standards, stable academic work | 12 months | OWASP LLM Top 10, NIST AI RMF, Diátaxis |
| `medium` | Vendor docs for mature products | 6 months | Microsoft Learn for WAF, CAF, SDL |
| `high` | Vendor docs for fast-moving products and new specs | 3 months | Foundry features, MCP spec, Microsoft Agent Framework, Anthropic subagents |

A citation is downgraded by the Reviewer when `today − last_verified > cadence`.

## Folder placement rules

| Folder | Inclusion test |
|---|---|
| `core/` | Cited by the multi-agent system template itself, regardless of project type. |
| `governance/` | Applies to AI/LLM safety, eval, or risk for most projects. |
| `microsoft/` | First-party Microsoft source. |
| `frameworks/` | Implementation-specific (a project may pick zero or one). |
| `_prior-art/` | Research-only. Not citable in a Reviewer pass. |

If an entry could fit in two folders, the more specific one wins (e.g., Semantic Kernel goes in `frameworks/` with a cross-link from `microsoft/`).

## Adding an entry

1. Pick the folder (rules above).
2. Create `<id>.md` from the template in `_schema/entry-schema.md`.
3. Write a real `key_requirements` block. If you can't, the entry belongs in `_prior-art/` instead.
4. Set `last_verified` to the date you actually opened the source.
5. Update the parent folder's index if one exists.

## Retiring an entry

1. Do not delete the file.
2. Set `superseded_by:` on the old entry to the new entry's id.
3. The new entry's frontmatter lists the old id in `supersedes:`.
4. Old citations remain valid until the next library audit, after which the Reviewer warns on them.

## Citation grammar

In any agent-authored document or `key_requirements` cross-reference:

```
ref: <id>                      # single citation
refs: <id>, <id>, <id>         # multiple
ref: <id>#<section-anchor>     # specific section within an entry
```

Never cite a raw URL inside a Reviewer pass. URLs are only valid inside `_prior-art/` and inside the `url:` field of an entry's frontmatter.

## Audits

The library gets a full audit when:

- More than 30% of entries are past their renewal cadence, **or**
- A new project is kicked off, **or**
- A major version of MCP, agents.md, or VS Code agent customization ships.

The audit produces a single `_audits/YYYY-MM-DD.md` log of changes (renewed dates, retired entries, added entries).
