---
id: ms-accessibility
name: Microsoft Accessibility Standards
category: microsoft
authority: vendor
url: https://www.microsoft.com/en-us/accessibility
covers: [accessibility, wcag, keyboard, screen-reader, color-contrast, captions, inclusive-design]
agent_use: Cite when reviewing any user-facing surface (web, app, CLI prompts, doc) for accessibility; when establishing the project's accessibility bar; or when the Accessibility role produces a release-gate verdict.
volatility: medium
licensing: proprietary (Microsoft public guidance; references W3C WCAG)
last_verified: 2026-05-25
---

# Microsoft Accessibility Standards

Microsoft's accessibility expectations across products, built on W3C WCAG and extended with Microsoft-specific guidance (Fluent UI accessibility, Inclusive Design toolkit, accessibility conformance reports). Cited as the project-level accessibility bar for any MS-stack workload with a user interface; satisfies the Inclusiveness principle of `ms-rai-standard`.

## Key requirements

- **WCAG 2.2 Level AA is the minimum bar** for public-facing surfaces; AAA is targeted for specific contexts (government, education, regulated). The Accessibility role names the target per surface.
- **All interactive UI is keyboard-operable.** Every action reachable by mouse / pointer is also reachable by keyboard; focus is always visible; tab order is logical. Mouse-only flows are a release blocker.
- **Screen-reader compatibility tested with at least one major SR** (Narrator on Windows, VoiceOver on macOS/iOS, NVDA, JAWS). Components use semantic HTML / ARIA correctly; aria-* attributes are validated, not invented.
- **Color contrast meets WCAG ratios** (4.5:1 normal text, 3:1 large text and UI components). Color is never the sole signifier of state.
- **Captions and transcripts** for audio and video; alt text for images that convey meaning; descriptive link text ("read the report", not "click here").
- **Forms have labels and error messages associated programmatically.** Errors are announced; required fields are marked accessibly; instructions are reachable before the field, not only via hover/tooltip.
- **Responsive and reflow support.** Content reflows to 320 CSS px without horizontal scroll; text resizes to 200% without loss of function; zoom and OS-level text-scaling settings are respected.
- **Reduced motion and high-contrast modes are honored.** `prefers-reduced-motion` disables non-essential animation; high-contrast OS modes do not break layout.
- **Accessibility Conformance Report (ACR / VPAT) for products with external customers.** The Documenter or Accessibility role produces the ACR before public release.
- **Accessibility-Insights / axe-core in CI.** Automated checks run on every pull request; failures are blocking. Manual review supplements but does not replace automation.

## Common misuses

- Treating accessibility as a final-pass cleanup. Retrofit accessibility is 5–10× more expensive than building it in; the Architect addresses accessibility in the design.
- "We use a component library, so we're accessible." Component libraries can be accessible if used correctly; misuse (wrong semantic, missing label, custom-built non-semantic clone) breaks the guarantee.
- Relying entirely on axe-core / automated scans. Automation catches ~30–40% of issues; manual SR + keyboard testing catches the rest.

## Notes

- Pairs with `ms-rai-standard` (Inclusiveness principle), `ms-style-guide` (accessible writing guidance), `azure-architecture-center` (front-end reference architectures address accessibility), `accessibility` chatmode (the role that operationalizes this entry).
- Volatility is `medium`: WCAG versions update every few years; Microsoft-specific guidance refines more often. Re-verify every 6 months.
