# tools/_template

How to author a tool-specific reference subset.

## Purpose

A `tools/<tool-name>/index.md` is a **curated id list** for a specific consumer (the multi-agent system itself, or a downstream tool built on it). It does **not** duplicate entry content — entries live in `core/`, `governance/`, `microsoft/`, or `frameworks/` and are pointed to by id.

## When to create one

Create a new `tools/<tool-name>/` folder when:

- You are building a new tool or product that uses the multi-agent system, **and**
- That tool has a specific subset of library ids it needs beyond the multi-agent-system base, **and**
- You want a single place to enumerate that subset so the tool's chat modes and Reviewer can cite from a stable list.

Do **not** create a `tools/` entry for a one-off project. Most projects use `tools/multi-agent-system/index.md` directly.

## File shape

A `tools/<tool-name>/index.md` contains:

1. **Title and purpose.** One paragraph: what consumer this is for, and what problem space it covers.
2. **Required ids.** Tables grouped by source folder, listing each required id and what it's cited for.
3. **Optional ids.** Same shape; clearly marked as opt-in.
4. **How a project consumes this index.** 3–5 numbered steps.
5. **Extension rules.** Whether downstream consumers can extend this index or must create their own.

## Rules

- An index file is **a list of ids and brief annotations**, not a place to put new entry content.
- If a needed entry does not yet exist in `core/`, `governance/`, `microsoft/`, or `frameworks/`, create the entry there first, then reference its id from the tool index.
- A tool index never invents an id that doesn't exist as a file in a domain folder.
- Tool indexes are **not citable** in Reviewer passes. They are navigation aids. The cited authorities are the underlying domain entries.

## Naming

- Folder name: `tools/<kebab-case-tool-name>/`
- File name inside: `index.md` (only)
- Tool name should match the product/project's working name, not its marketing name.
