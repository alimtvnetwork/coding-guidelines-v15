# AppError Package Reference

> ⚠️ **This file has been split into a subfolder.** See [01-apperror-reference/00-overview.md](./01-apperror-reference/00-overview.md)

All content now lives in [`01-apperror-reference/`](./01-apperror-reference/).

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-001c: Conformance check for this error-management rule

**Given** Run the error-handling linter against the codebase.  
**When** Run the verification command shown below.  
**Then** Zero empty `catch {}` blocks; every `apperror.New(...)` call carries a file/path context; all `Err*` identifiers are PascalCase.

**Verification command:**

```bash
grep -rnE 'catch[[:space:]]*\([^)]*\)[[:space:]]*\{[[:space:]]*\}' src/ ; test $? -eq 1
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
