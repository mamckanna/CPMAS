---
id: ms-learn
name: Microsoft Learn Authoring Conventions
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/contribute/
covers: [docs-as-code, markdown, metadata, samples, diataxis, learn-modules]
agent_use: Cite when authoring or reviewing documentation that will publish to Microsoft Learn, or when applying Learn's docs-as-code conventions (metadata, file structure, code-sample policy) to internal MS-stack docs.
volatility: medium
licensing: CC BY 4.0 (Microsoft docs)
last_verified: 2026-05-25
---

# Microsoft Learn Authoring Conventions

The contributor guide for docs published to Microsoft Learn (formerly docs.microsoft.com). Defines the docs-as-code pipeline, Markdown dialect, required metadata, and code-sample policies for any Microsoft documentation surface — and, by adoption, for most internal MS-stack documentation sets.

## Key requirements

- **Docs-as-code**: content lives in Git, Markdown source, PR-reviewed, built by the Learn pipeline. Word docs, wiki pages, and ad-hoc PDFs are not Learn content.
- **Metadata block is required and validated.** Every article carries YAML frontmatter with `title`, `description`, `ms.date`, `ms.topic`, `author`, `ms.author`, and topic-specific fields. Missing or stale `ms.date` blocks publish.
- **Learn-flavored Markdown, not vanilla CommonMark.** Use the published extensions: `[!INCLUDE]` for shared fragments, `:::zone:::` for pivots, `:::code source=:::` for sample inclusion, `> [!NOTE]` / `[!WARNING]` / `[!IMPORTANT]` alerts. Inline HTML is restricted.
- **Code samples come from a buildable, tested source.** Snippets are pulled from a real sample repo via `:::code source=:::` with a `range` or `id`; in-line copy-pasted code that nobody compiles is a finding.
- **One topic type per article**, aligned with the Diátaxis-style taxonomy Learn uses: Overview, Quickstart, Tutorial, How-to, Concept, Reference, Troubleshooting. Mixing types (a tutorial that drifts into reference material) is rewritten, not merged.
- **Voice and terminology defer to `ms-style-guide`.** Authoring conventions cover structure and tooling; prose quality is governed by the style guide.
- **Accessibility is a publish gate.** Alt text on every meaningful image, descriptive link text, semantic heading order, captions or transcripts for embedded video. See `ms-accessibility`.
- **Localization-readiness**: no embedded text in screenshots where avoidable, no idioms, no concatenated sentence fragments. Strings flagged by the localization linter block publish.

## Common misuses

- Treating Learn metadata as cosmetic and letting `ms.date` go stale — stale dates demote articles in search ranking and trigger the freshness sweeper.
- Pasting code into an article and never linking back to a runnable sample; the code drifts from reality within one product release.
- One mega-article that is part tutorial, part concept, part reference. Learn's IA assumes single-purpose pages and search/cross-link does the rest.

## Notes

- Pairs with `ms-style-guide` (prose voice), `ms-accessibility` (a11y publish gates), `bicep` / `azure-pipelines` (sample repos that back `:::code source=:::` references).
- The internal "docs-pr" build pipeline in Azure DevOps mirrors the public Learn build; failing the local Acrolinx + markdownlint + link-check suite is the fastest path to a green publish.
