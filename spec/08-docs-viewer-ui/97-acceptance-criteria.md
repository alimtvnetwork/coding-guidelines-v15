# Acceptance Criteria — Docs Viewer Ui

**Spec:** `spec/08-docs-viewer-ui/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/08-docs-viewer-ui/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-UI-NNN` — three-digit sequential.

**Test kind:** Playwright E2E + design-token contract  
**Top-level verification:**

```bash
bunx playwright test tests/docs-viewer/ && bun run check:no-hardcoded-colors
```

---

## Criteria

### AC-UI-001: Keyboard navigation

**Given** The docs viewer page is open with the file sidebar visible.  
**When** Press `j` once, then `k` once.  
**Then** After `j`, sidebar selection moves to the next file. After `k`, it returns to the original file. Verified via Playwright keyboard event.

### AC-UI-002: Document tree schema

**Given** A document tree JSON loaded by the viewer.  
**When** Validate against `schemas/doc-tree.schema.json`.  
**Then** MUST contain `id` (string), `title` (string), `path` (string), `children` (array). Schema validation MUST pass.

### AC-UI-003: Zero hardcoded colors

**Given** All component source files under `src/components/`.  
**When** `grep -rE '(text|bg|border)-(white|black|gray-[0-9]|red-[0-9]|blue-[0-9])' src/components/`.  
**Then** MUST return zero matches. All colors MUST resolve to a CSS variable in `src/index.css`.

---

## Waiver policy

A criterion may be waived only by:
1. Adding an entry to `linter-scripts/spec-cross-links.allowlist` (for link checks), or
2. Editing this file to mark the criterion `**Waived (rationale: ...)**` with a tracking issue link.

Silent waivers (commented-out tests, skipped assertions without rationale) are forbidden.

---

## Validation history

| Date | Version | Action |
|------|---------|--------|
| 2026-04-21 | 1.0.0 | Initial acceptance criteria — generated from spec patch plan |

---

*Acceptance Criteria — updated: 2026-04-21*
