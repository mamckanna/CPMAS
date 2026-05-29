# Entry Schema

Every citable entry in `Libraries/` (under `core/`, `governance/`, `microsoft/`, `frameworks/`) conforms to this schema. One entry per file. File name == entry `id`.

## Entry format

```yaml
---
id: <stable-kebab-case-id>           # required, globally unique, never renamed
name: <human-readable name>          # required
category: <core | governance | microsoft | framework>   # required
authority: <standard | vendor | community | research>   # required
url: <canonical source URL>          # required, must resolve at last_verified date
covers:                              # required, 3–8 keywords
  - <keyword>
  - <keyword>
agent_use: <one sentence describing when agents cite this entry>
volatility: <low | medium | high>    # required
licensing: <open | proprietary | mixed | n/a>
last_verified: YYYY-MM-DD            # required
supersedes: [<id>, ...]              # optional
superseded_by: <id>                  # optional
---

# <name>

<One-paragraph framing: what this is and why it's in the library.>

## Key requirements

> Normative bullets distilled from the source. Agents treat these as authoritative
> for review purposes. 5–12 bullets, each one short, each one falsifiable.

- <bullet 1>
- <bullet 2>
- ...

## Common misuses

> Optional. Things agents get wrong about this source. 0–5 bullets.

- <bullet>

## Notes

> Optional. Free-form context, edge cases, version notes.
```

## Field definitions

| Field | Meaning |
|---|---|
| `id` | Stable identifier. Used in all citations. Kebab-case. Never renamed; deprecate via `superseded_by`. |
| `name` | Human-readable title. |
| `category` | One of the citable folders. Must match the file's parent folder. |
| `authority` | `standard` = formal spec or de-facto standard; `vendor` = product docs from the owner; `community` = community-maintained; `research` = academic or research-org output. |
| `url` | Canonical source. One URL only. If the source spans multiple pages, link the index page. |
| `covers` | Search keywords. Not normative. |
| `agent_use` | When an agent should reach for this entry. Read by chat modes. |
| `volatility` | Renewal cadence per `conventions.md`. |
| `licensing` | License of the source content (not your library entry). |
| `last_verified` | Date the URL was confirmed live and the `key_requirements` were confirmed accurate. |
| `supersedes` / `superseded_by` | Entry-replacement chain. Old entries stay; they just mark forward to the replacement. |

## Why `key_requirements` is mandatory

Without it, an entry is a pointer. An agent citing a pointer falls back to training data, which may be wrong or stale. `key_requirements` is the normative payload — the thing the Reviewer can actually check code against. If you can't write a `key_requirements` block for an entry, the entry doesn't belong in this library; put the URL in `_prior-art/` as research instead.

## Why `last_verified` and `volatility` matter

The Reviewer downgrades any citation past its renewal cadence from `pass` to `warn`. This keeps the library honest as standards and products evolve, without requiring an all-at-once refresh.
