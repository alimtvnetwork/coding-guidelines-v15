# Issue: URLError Renamed to UrlError — Inconsistent Casing

**Date:** 2026-04-02  
**Severity:** Low  
**Status:** Resolved

---

## Error Description

All convenience constructor references used `URLError` / `WrapURLError` across spec files (`02-apperror-struct.md`, `readme.md`, `98-changelog.md`). This violated the project's mixed-case identifier convention where acronyms in multi-word names use title case (`Url`) not all-caps (`URL`).

## Root Cause

Initial implementation followed Go stdlib convention (`URL` all-caps) instead of the project's own naming guideline which prefers `Url` for consistency with `SlugError`, `SiteError`, `EndpointError` — all of which use title case, not all-caps.

## Solution

Renamed all occurrences across 3 files:
- `URLError` → `UrlError`
- `WrapURLError` → `WrapUrlError`

Verified with case-sensitive search: zero `URLError` references remain in the spec tree.

## Prevention

- Before naming new constructors, check existing sibling names for casing patterns
- Run `grep -r "URLError" spec/` as a post-change verification step
- Anti-hallucination rule: AI must match sibling naming conventions, not stdlib conventions

## Related

- [02-apperror-struct.md](../../02-error-architecture/06-apperror-package/01-apperror-reference/02-apperror-struct.md) — sections 2.2.2–2.2.5
- [98-changelog.md](../../98-changelog.md) — v2.2.0 entry

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-2026b: Error-management conformance: 04 02 Url Error Casing Fix

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
