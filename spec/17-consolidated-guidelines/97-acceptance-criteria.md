# Acceptance Criteria — Consolidated Guidelines

**Spec:** `spec/17-consolidated-guidelines/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/17-consolidated-guidelines/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-CON-NNN` — three-digit sequential.

**Test kind:** Standalone-implementability test  
**Top-level verification:**

```bash
python linters-cicd/scripts/check-consolidated-standalone.py
```

---

## Criteria

### AC-CON-001: Code example present

**Given** Every consolidated file.  
**When** Scan for fenced code blocks.  
**Then** MUST contain at least one fenced code block (```` ``` ```` or `~~~`).

### AC-CON-002: Self-contained — no parent links

**Given** Every consolidated file.  
**When** `grep -c '\[.*\](\.\./' file.md`.  
**Then** MUST return 0. Consolidated files MUST NOT depend on relative parent links.

### AC-CON-003: Standalone implementability

**Given** A single consolidated file (e.g. `05-split-db-architecture.md`).  
**When** Feed it alone to a fresh AI session and ask for the SQL DDL.  
**Then** Output MUST validate against the schema spec without requiring any other file.

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
