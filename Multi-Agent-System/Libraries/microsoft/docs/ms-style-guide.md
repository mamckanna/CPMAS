---
id: ms-style-guide
name: Microsoft Writing Style Guide
category: microsoft
authority: vendor
url: https://learn.microsoft.com/en-us/style-guide/welcome/
covers: [voice, tone, terminology, accessibility-language, bias-free, formatting]
agent_use: Cite when writing user-facing copy, documentation, error messages, or product UI text in an MS-stack workload; or when reviewing prose for voice, bias-free language, or terminology consistency.
volatility: low
licensing: CC BY 4.0 (Microsoft docs)
last_verified: 2026-05-25
---

# Microsoft Writing Style Guide

Microsoft's public style guide for technical writing, UI text, and customer-facing content. The default style authority for any prose produced for an MS-stack project — docs, release notes, error strings, dialog text, marketing copy.

## Key requirements

- **Warm, relaxed, crisp, ready-to-help voice.** Conversational tone, contractions allowed, second person ("you") for the reader, active voice. Marketing-grandiose adjectives ("revolutionary", "seamless", "powerful") are cut.
- **Bias-free communication is non-negotiable.** Follow the Bias-free communication chapter: avoid gendered defaults, ableist idioms, race/ethnicity stereotypes, and exclusionary terms. Use the published replacement list (e.g., "allowlist/blocklist" not "whitelist/blacklist"; "primary/secondary" not "master/slave").
- **Accessible writing as a hard requirement.** Plain language, short sentences (target 15–20 words), headings that scan, link text that names the destination ("see the Bicep reference") not "click here", alt text for every meaningful image.
- **Use the A–Z term list as ground truth** for product names, capitalization ("sign in" verb / "sign-in" noun), and contested terms. Disagreements with the A–Z list are findings, not preferences.
- **Number, date, and unit formatting follow the guide**: numerals for 10+ and for all measurements, ISO-style dates in technical contexts, non-breaking space between value and unit.
- **Code, UI, and command formatting conventions** are explicit: code voice for code, bold for UI labels, italics for first-mention of a term, no quotation marks around UI labels.
- **Global-ready English**: avoid idioms, sports metaphors, and culture-specific references that don't translate. The Localization chapter lists the worst offenders.

## Common misuses

- Treating the guide as marketing-only and ignoring it for error messages and dialog text — error strings are exactly where unclear, blame-y, or jargon-heavy prose hurts users most.
- Hard-coding "he/she" or gendered defaults in generated content; the guide's bias-free section is mandatory, not stylistic.
- Citing competitors' style guides (Google, Apple) for MS-stack product copy when this guide is the canonical reference for the platform.

## Notes

- Pairs with `ms-learn` (authoring conventions for docs published on Microsoft Learn), `ms-accessibility` (WCAG and platform-specific accessibility), and the team's own `docs/style/voice.md` if one exists.
- The Acrolinx scorecard at Microsoft is configured against this guide; agents producing customer-facing copy for an MS project should expect to be measured against the same rubric.
