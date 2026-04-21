# AppError Package

**Version:** 3.2.0  
**Status:** Active  
**Updated:** 2026-04-16  
**AI Confidence:** High  
**Ambiguity:** None

---


## Keywords

`error`, `resolution`, `apperror`, `package`

---

## Scoring

| Criterion | Status |
|-----------|--------|
| `00-overview.md` present | ✅ |
| AI Confidence assigned | ✅ |
| Ambiguity assigned | ✅ |
| Keywords present | ✅ |
| Scoring table present | ✅ |


## Purpose

Application error package specification.

---

## Document Inventory

| File | Purpose |
|------|---------|
| 01-apperror-reference.md | AppError struct, Result types, usage patterns |
| 01-apperror-reference/ | Subfolder with split reference docs (incl. 05-apperrtype-enums.md) |
| 99-consistency-report.md | Structural health |

---

## Cross-References

_See parent folder's `00-overview.md` for broader context._

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-000b: Error-management conformance: Overview

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
