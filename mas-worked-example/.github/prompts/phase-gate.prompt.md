---
description: "Run a phase gate. Pass, warn, or block. Usable from Orchestrator (most phases) or Reviewer/Compliance (Audit). Writes a G- entry to review-log.md and advances plan.md on pass."
mode: agent
---

# /phase-gate <phase>

Run the gate check for the named phase. If `<phase>` is omitted, use the current phase from `plan.md`.

## Pre-flight

- Read `.agents/state/checkpoint.md` first; refuse if integrity check fails (route to `/recover`).
- Read `.agents/state/plan.md`, `.agents/state/project-profile.md`, `.agents/state/role-manifest.md` (if produced), `.agents/state/artifact-manifest.md` (if produced).
- For Build / Audit gates: also read `validation-log.md` and `artifacts.md`.

## Gate criteria by phase

### References (recurring)
- Every Library `id` cited in `decisions.md`, `review-log.md`, `validation-log.md`, and `docs/**` resolves to an entry under `Libraries/`.
- No entry past its volatility renewal window without a `last_verified` refresh in the current phase.

### Concept gate
- `docs/concept.md` exists.
- `.agents/state/project-profile.md` exists, is fully populated, and is locked (`locked_at` set).
- Success criteria are concrete and measurable.
- Non-goals are listed.
- At least one Library `id` citation.
- **On pass**: Orchestrator derives `.agents/state/role-manifest.md` and locks it (recorded as a process decision).

### Architecture gate
- `docs/architecture.md` exists with at least one Mermaid diagram.
- At least one reference-architecture `id` cited from `Libraries/`.
- Alternatives-considered section is non-empty.
- One STRIDE-flavored threat surface listed (full threat model is Security Engineer's later output).

### Design gate
- `docs/design.md` exists.
- Component diagram + data-model summary present.
- Identity / authn / authz approach cited by Library `id`.
- Threat-model summary cited by Library `id`.
- If `ai_features != none`: RAI-related Library `id` cited.
- If `data_products != none`: Database Engineer's design-phase outputs (schema sketch, integrity constraints) present.

### Plan gate
- `docs/implementation-plan.md` exists.
- Each task has: owner-agent, artifact target path, test target.
- `.agents/state/artifact-manifest.md` exists, every entry has all required fields per the template, `must_NOT_be` block populated, `produced_by` / `validated_by` / `reviewed_by` set.
- Every task in `implementation-plan.md` maps to one or more manifest entries.
- No manifest entry has `type: doc` for something the Concept declared as a runtime feature.
- Manifest is locked (`manifest.locked_at` set; entries marked `manifest_locked: true`).
- Sequencing has no obvious cycles.

### Build artifact gate (automated, per artifact)
- The on-disk artifact's path matches the manifest entry's path.
- Extension matches `expected_format.extension`; content is not on the `must_NOT_be` list.
- A `V-NNN` entry in `validation-log.md` for this artifact has `Verdict: pass`.
- For every role listed in the manifest entry's `reviewed_by`, a corresponding pass entry exists in `review-log.md` citing that V-id.
- `artifacts.md` entry status is `reviewed-pass`.

### Operate gate
- Runbooks exist for every production surface declared in `docs/design.md`.
- SLOs / SLIs declared with measurable targets.
- Observability config (metrics, logs, traces) artifacts validated.
- Deploy evidence captured (last successful deploy timestamp + reproducible deploy command).

### Release gate
- Release notes drafted by Release Manager.
- Version policy entry cited from `Libraries/`.
- Deprecation timeline declared if any breaking change.
- Customer-comms artifact validated (if `external_users == yes`).

### Audit gate (final)
- Every entry in `artifact-manifest.md` with `manifest_locked: true` has a corresponding on-disk artifact in the declared format and language.
- Every such entry has an `artifacts.md` line with `Status: reviewed-pass` (or terminates in a `superseded` chain ending in `reviewed-pass`).
- No `.docx`, `.pdf`, `.pptx` exists where the manifest declares a non-binary `type`.
- No orphan artifacts on disk that are not in the manifest.
- No open blockers in `review-log.md` or `validation-log.md`.
- Compliance Officer's framework matrix has at least one cited control per declared framework in `project-profile.regulated_data`.
- If `ai_features != none`: RAI evidence (model card, eval suite, red-team) cited.
- If `ui != none`: Accessibility conformance evidence cited.

## Output

Write to `.agents/state/review-log.md` (note: this is **not** a REV- entry; gates use the G- prefix and may be appended by Orchestrator):

```
## G-<NNN>: <phase> gate
- Date: YYYY-MM-DDTHH:MM:SSZ
- Verdict: pass | warn | block
- Findings: <bullets>
- References: <Library ids>
- Required follow-ups: <bullets, if warn or block>
- turn_token: <int>
```

Update `plan.md`:

- On `pass`: mark phase complete; advance current phase to the next in the queue; set gate status to `pending human approval` if the gate was a human-checkpoint phase.
- On `warn`: phase passes but warn items roll into the next phase's plan as risks; record them in the next phase's notes.
- On `block`: phase stays open; `expected_next_agent` becomes the producer of the blocked output.

## Maintain (perpetual sibling)

Maintain is **not** gated via this prompt. Maintainer-scope changes have a per-action gate via the standard Validator + Reviewer chain. The phase pointer does not advance into or out of Maintain.

## Stop

Do not auto-advance past a human gate. Print the G- entry, the new `plan.md` `Current phase`, and the updated `turn_token`.
