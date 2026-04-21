# Acceptance Criteria — Code Block System

**Spec:** `spec/09-code-block-system/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/09-code-block-system/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-CB-NNN` — three-digit sequential.

**Test kind:** Component contract + Playwright  
**Top-level verification:**

```bash
bunx playwright test tests/code-block/
```

---

## Criteria

### AC-CB-001: LineSelectionState interface exported

**Given** The code-block component module.  
**When** `grep -E 'export (type|interface) LineSelectionState' src/components/code-block/types.ts`.  
**Then** MUST find one match. Required fields: `startLine: number; endLine: number; isDragging: boolean`.

### AC-CB-002: Shift-click range selection

**Given** A code block with at least 10 numbered lines is rendered.  
**When** Click line 3, then shift-click line 7.  
**Then** Lines 3 through 7 inclusive MUST have the `data-selected="true"` attribute.

### AC-CB-003: Drag-selection performance

**Given** A code block with 100 lines.  
**When** Programmatically drag-select all 100 lines.  
**Then** Selection completes in `<100ms` (Playwright `performance.measure`).

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
