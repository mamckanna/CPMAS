# Setup — Install the Multi-Agent System in a VS Code Project

> Prereqs: VS Code with GitHub Copilot Chat enabled (or any agents.md-compatible host with chat modes + slash prompts + MCP). Project opened as a workspace folder. Git initialized.

---

## 1. Copy the template into your project

Copy the contents of `Multi-Agent-System/Template/` into the root of the target project. The end-state should look like:

```
<your-project>/
├── AGENTS.md
├── .github/
│   ├── copilot-instructions.md
│   ├── instructions/
│   │   ├── general.instructions.md
│   │   └── security.instructions.md
│   ├── chatmodes/                       ← 23 chat modes
│   │   ├── orchestrator.chatmode.md
│   │   ├── architect.chatmode.md
│   │   ├── builder.chatmode.md
│   │   ├── reviewer.chatmode.md
│   │   ├── librarian.chatmode.md
│   │   ├── validator.chatmode.md
│   │   ├── security-engineer.chatmode.md
│   │   ├── privacy-engineer.chatmode.md
│   │   ├── compliance-officer.chatmode.md
│   │   ├── documenter.chatmode.md
│   │   ├── database-engineer.chatmode.md
│   │   ├── sre.chatmode.md
│   │   ├── release-manager.chatmode.md
│   │   ├── maintainer.chatmode.md
│   │   ├── rai.chatmode.md              ← conditional (9 below)
│   │   ├── data-steward.chatmode.md
│   │   ├── accessibility.chatmode.md
│   │   ├── finops.chatmode.md
│   │   ├── legal.chatmode.md
│   │   ├── product.chatmode.md
│   │   ├── ux-researcher.chatmode.md
│   │   ├── qa.chatmode.md
│   │   └── support.chatmode.md
│   └── prompts/                         ← 8 slash prompts
│       ├── kickoff.prompt.md
│       ├── handoff.prompt.md
│       ├── phase-gate.prompt.md
│       ├── migrate-existing.prompt.md
│       ├── validate.prompt.md
│       ├── profile.prompt.md
│       ├── recover.prompt.md
│       └── health-check.prompt.md
├── .vscode/
│   └── mcp.json
└── .agents/
    └── state/                           ← templates copied here
        ├── README.md
        ├── checkpoint.template.md
        ├── plan.template.md
        ├── decisions.template.md
        ├── artifacts.template.md
        ├── validation-log.template.md
        ├── project-profile.template.md
        ├── role-manifest.template.md
        └── artifact-manifest.template.md
```

**PowerShell one-liner from this workspace root:**

```powershell
$src  = ".\Multi-Agent-System\Template"
$dest = "<absolute-path-to-your-project>"
Copy-Item -Path "$src\*" -Destination $dest -Recurse -Force
```

Backup files (`*.v1.bak`) under `Template/` are historical only; you may exclude them from the copy if you want a cleaner target.

---

## 2. Initialize state files

In the target project, instantiate the working state files from their templates. Most are empty until first run; `checkpoint.md` and `plan.md` get filled by `/kickoff`.

```powershell
cd <your-project>
$st = ".\.agents\state"
Copy-Item "$st\plan.template.md"             "$st\plan.md"
Copy-Item "$st\decisions.template.md"        "$st\decisions.md"
Copy-Item "$st\artifacts.template.md"        "$st\artifacts.md"
Copy-Item "$st\validation-log.template.md"   "$st\validation-log.md"
Copy-Item "$st\checkpoint.template.md"       "$st\checkpoint.md"
New-Item  "$st\handoff.md"      -ItemType File
New-Item  "$st\review-log.md"   -ItemType File
```

Do **not** instantiate `project-profile.md`, `role-manifest.md`, or `artifact-manifest.md` here. They are produced under controlled conditions:

- `project-profile.md` — written by `/kickoff` after the Profile interview, then **locked**.
- `role-manifest.md` — derived by Orchestrator at the Concept gate from the locked Profile, then **locked**.
- `artifact-manifest.md` — drafted by Architect/Builder during Plan phase, **locked** at the Plan gate.

Locking is enforced by the chat modes; bypassing it is a process violation.

---

## 3. Customize the project header

Edit these two files to reflect the project:

- **`AGENTS.md`** — replace the `<project name>`, `<one-line purpose>`, and `<primary stack>` placeholders.
- **`.github/copilot-instructions.md`** — set stack, owner, audience, and any non-negotiable rules.

Do not pre-populate `project-profile.md`. The `/kickoff` interview asks for those fields one at a time and writes the locked file.

---

## 4. Configure MCP servers

Open `.vscode/mcp.json`. The default file registers a small starter set:

- `filesystem` — points at the workspace root.
- `git` — local repo operations.
- `github` — optional; enable when you want issue/PR access.

Then in VS Code: **Command Palette → MCP: List Servers →** verify each shows as running. If a server fails, fix its command/args and reload the window. The Librarian, Validator, and Reviewer modes have read-only tool allow-lists that depend on these servers; verify their tool surface after first run.

---

## 5. Register the chat modes

VS Code auto-discovers `.chatmode.md` files under `.github/chatmodes/`. To verify:

1. Open the **Copilot Chat** view.
2. Click the chat-mode dropdown (top of the chat input).
3. You should see all 23 modes (14 baseline + 9 conditional).

If they don't appear:

- Confirm the files are in `.github/chatmodes/` exactly.
- Confirm each file has valid YAML frontmatter with `description:` and a `tools:` allow-list.
- Reload the window (**Command Palette → Developer: Reload Window**).

Conditional modes appear in the dropdown but **refuse work** unless their name is listed in `.agents/state/role-manifest.conditional_active`. That's expected — they activate when the Project Profile justifies them.

---

## 6. First run

1. Select the **Orchestrator** chat mode.
2. Type `/kickoff` and press Enter.
3. The Orchestrator will:
   - Interview the 14-field Project Profile (one question per turn).
   - Write the locked `project-profile.md`.
   - If `migrating_from != none`: stop and route you to `/migrate-existing` (see §8).
   - Otherwise: write `plan.md` with the 10-phase queue (current phase = Concept), write `handoff.md` routing to Architect, write `checkpoint.md`.
4. Switch to the **Architect** chat mode. Type `/handoff` (or follow the recommended next action). Architect produces `docs/concept.md` and hands back to Orchestrator.
5. Back in **Orchestrator**, run `/phase-gate Concept`. On pass, Orchestrator derives `role-manifest.md` from the locked Profile and locks it. Conditional roles activate from this point.
6. Proceed phase by phase. Each phase gate is `/phase-gate <phase>` from Orchestrator (Audit is run by Compliance Officer).

Per-phase rhythm: agent reads `checkpoint.md` (pre-flight) → reads `handoff.md` + relevant state → does its phase work → writes outputs + appends to logs → runs `/handoff` to route to the next agent → user switches modes.

---

## 7. Build phase mechanics (manifest + validation chain)

Once `artifact-manifest.md` is locked at the Plan gate, each Build artifact follows this chain:

1. **Producing agent** (Builder / Architect / Database Engineer / Documenter / SRE / Release Manager) writes the artifact at the path declared in the manifest.
2. Producing agent appends an `artifacts.md` entry with `Status: validation-requested`.
3. Producing agent runs `/handoff` (or the user runs `/validate`).
4. **Validator** runs the three-pass gate (existence + format + content), appends a `V-NNN` entry to `validation-log.md`. On `pass`: artifact status → `validation-passed`. On `block`: routes back to producing agent with `Attempt N+1`.
5. **Reviewer** does the cross-cutting code/standards review.
6. **Domain reviewers** listed in the manifest entry's `reviewed_by` (Security, Privacy, RAI, Accessibility, etc.) each append a `REV-NNN` entry to `review-log.md` citing the `V-id`.
7. When every `reviewed_by` role has a pass entry, artifact status → `reviewed-pass`. `/phase-gate Build` accepts it.

No artifact bypasses Validator. No artifact reaches Reviewer without a passing V-id.

---

## 8. Migration workflow (existing project)

If `project-profile.migrating_from != none`, `/kickoff` routes you to `/migrate-existing` instead of the standard Concept phase. The migration substitutes a 6-phase flow:

References (recurring) → **Inventory** → **Reconciliation** → Plan → Build → Operate → Release → Audit, with Maintain perpetual.

- **Inventory** — Maintainer scans `legacy/` (or wherever the existing project lives) and writes `migration/inventory.md`: every file, extension, sniffed content type, classification.
- **Reconciliation** — Architect (+ Validator + Database Engineer if data) derives the target Artifact Manifest. Each inventory item is marked `keep` / `convert` / `replace` / `discard`. Output: `migration/reconciliation.md` + a draft `artifact-manifest.md`.
- **Plan / Build / Audit** — Standard phases. Tasks are mostly `convert` (e.g., `.docx` → `docs/design.md`) or `replace` (regenerate from scratch).
- **Retire** — Maintainer moves discarded/superseded files to `archive/`. Never deletes.

The Audit gate refuses `.docx` / `.pdf` / `.pptx` files where the manifest declares a non-binary `type`.

---

## 9. Expanding the roster

Conditional roles (RAI, Data Steward, Accessibility, FinOps, Legal, Product, UX Researcher, QA, Support) are already in the template. They activate via the Project Profile, not by manual file creation.

To add a **net-new specialist** beyond the 23:

1. Duplicate the closest existing chat-mode file in `.github/chatmodes/`.
2. Narrow the `description:` and `tools:` allow-list.
3. Add the role to `role-manifest.md` (and to the activation rules in `Design/SYSTEM-DESIGN.md` §7).
4. Update `orchestrator.chatmode.md` dispatch rules to mention the new specialist by name.
5. Update `AGENTS.md` Roster.

No other files need changes.

To **revise the Project Profile** mid-flight (and re-derive `role-manifest.md` atomically): run `/profile` from Orchestrator. Newly-activated roles needing upstream catch-up are recorded as `scope-gap` decisions in `decisions.md`.

---

## 10. Daily workflow

- **Start of session:** open Orchestrator mode → run `/health-check`. If it reports integrity failure, run `/recover`.
- **Mid-session phase switch:** save current state → run `/handoff` → switch chat mode.
- **Need next validation target:** run `/validate` from any mode to route to Validator with the next pending artifact.
- **Before a phase gate:** run `/phase-gate <phase>` from Orchestrator.
- **End of session:** ensure `handoff.md` and `checkpoint.md` are current (any agent can run `/handoff`).

---

## 11. Troubleshooting

| Symptom | Fix |
|---|---|
| Chat modes don't show up | Files not under `.github/chatmodes/`, or frontmatter invalid. Reload window. |
| Conditional mode refuses to work | Expected unless its name is in `role-manifest.conditional_active`. Use `/profile` to revise the Project Profile if the role should be active. |
| Agent ignores instructions | Check `.github/copilot-instructions.md` is at root and the file in `instructions/` has a matching `applyTo` glob. |
| Agent invents URLs | Routing is automatic: missing Library `id` → Librarian. If an agent cites without `id`, that's a process violation; flag in `decisions.md`. |
| State file out of sync / `turn_token` mismatch | Run `/health-check`. If broken, run `/recover`. |
| Validator keeps blocking same artifact | The artifact's content fails a `must_NOT_be` rule or `expected_format`. Read the V-entry's findings; producing agent must address all before re-submitting as `Attempt N+1`. |
| Manifest entry missing for an artifact | Plan gate failed silently or a new artifact slipped in. Halt Build, return to Plan, amend manifest, re-lock at next gate. |
| MCP server not running | `MCP: List Servers` → click the server → view logs → fix command or env vars. |

---

## 12. Uninstall

Delete `.github/chatmodes/`, `.github/prompts/`, `.github/instructions/`, `.github/copilot-instructions.md`, `.agents/`, `.vscode/mcp.json`, and `AGENTS.md`. Move any project artifacts you want to keep out of `archive/` first. Nothing else in your project was touched.
