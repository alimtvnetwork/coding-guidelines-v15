# Acceptance Criteria — Update

**Spec:** `spec/14-update/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/14-update/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-UPD-NNN` — three-digit sequential.

**Test kind:** Update flow + rollback  
**Top-level verification:**

```bash
bash tests/update/acceptance.sh
```

---

## Criteria

### AC-UPD-001: Check-only exit codes

**Given** A pinned current version.  
**When** `update --check` against an environment with no newer release, then with a newer release, then with a network error.  
**Then** MUST exit 0 (no update), 10 (update available), and `>10` (error) respectively.

### AC-UPD-002: Post-update version

**Given** A successful `update` run targeting version `X.Y.Z`.  
**When** Inspect `version.json`.  
**Then** `.version` field MUST equal `X.Y.Z`.

### AC-UPD-003: Rename-first rollback invariant

**Given** Mid-update process is killed via `kill -9`.  
**When** Rerun `update`.  
**Then** Previous binary MUST be restored. `bin --version` MUST report the pre-update version.

### AC-UPD-004: Inventory consistency

**Given** `00-overview.md` file list and `99-consistency-report.md` inventory.  
**When** Compare counts.  
**Then** MUST agree exactly with actual `ls spec/14-update/*.md`.

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
