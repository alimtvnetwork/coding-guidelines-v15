# Acceptance Criteria — Research

**Spec:** `spec/10-research/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/10-research/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-RES-NNN` — three-digit sequential.

**Test kind:** Markdown structure lint  
**Top-level verification:**

```bash
python linters-cicd/scripts/check-research-structure.py spec/10-research/
```

---

## Criteria

### AC-RES-001: Required H2 sections

**Given** Any markdown file under `spec/10-research/` (excluding `00-overview.md`).  
**When** Parse all H2 headings.  
**Then** MUST contain `## Objective`, `## Methodology`, `## Findings`, `## Conclusion`. Order MUST be preserved.

### AC-RES-002: Cross-link to consolidated guidelines

**Given** Any research file.  
**When** Scan markdown links.  
**Then** MUST contain at least one link of the form `spec/17-consolidated-guidelines/...`.

### AC-RES-003: Inventory consistency

**Given** `99-consistency-report.md`.  
**When** Compare its inventory table to `ls spec/10-research/*.md`.  
**Then** Counts MUST match exactly. Any discrepancy is a hard fail.

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
