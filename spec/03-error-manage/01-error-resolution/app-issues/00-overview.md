# App Issues

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**AI Confidence:** High  
**Ambiguity:** None

---

## Keywords

`app-issues`, `error-documentation`, `root-cause`, `prevention`, `code-red`

---

## Scoring

| Criterion | Status |
|-----------|--------|
| `00-overview.md` present | ✅ |
| AI Confidence assigned | ✅ |
| Ambiguity assigned | ✅ |
| Keywords present | ✅ |
| Scoring table present | ✅ |

---

## Purpose

Documented application errors with root cause analysis, solutions, and prevention steps. Each entry follows the [Error Documentation Guideline](../00-error-documentation-guideline.md) to prevent AI hallucination on previously solved problems.

---

## Document Inventory

| File | Purpose |
|------|---------|
| [2026-04-02-url-error-casing-fix.md](./2026-04-02-url-error-casing-fix.md) | URLError renamed to UrlError — inconsistent casing fix |
| [error-management-file-path-and-missing-file-code-red-rule.md](./error-management-file-path-and-missing-file-code-red-rule.md) | 🔴 Code Red: Mandatory file path and failure reason in all file/path error logs |

---

## Cross-References

- [Error Documentation Guideline](../00-error-documentation-guideline.md) — Mandatory documentation process
- [Error Resolution Overview](../00-overview.md) — Parent folder

---

*App issues overview — created: 2026-04-07*

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
