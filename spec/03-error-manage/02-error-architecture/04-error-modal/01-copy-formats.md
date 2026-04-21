# ⚠️ THIS FILE HAS BEEN SPLIT INTO A SUBFOLDER

> **Moved to:** [01-copy-formats/00-overview.md](./01-copy-formats/00-overview.md)  
> **Date:** 2026-03-31  
> **Reason:** 871-line file split into 10 focused files for easier AI consumption.

---

## File Index → [01-copy-formats/](./01-copy-formats/)

| File | Content |
|------|---------|
| [00-overview.md](./01-copy-formats/00-overview.md) | Index, format overview, copy/download menu patterns |
| [01-compact-report.md](./01-copy-formats/01-compact-report.md) | ⭐ DEFAULT — Compact Report (instant, includes delegated server info) |
| [02-full-report.md](./01-copy-formats/02-full-report.md) | Full Report — all sections, verbose |
| [03-full-report-with-backend-logs.md](./01-copy-formats/03-full-report-with-backend-logs.md) | Full Report + error.log.txt appended |
| [04-error-log-txt.md](./01-copy-formats/04-error-log-txt.md) | Raw error.log.txt format |
| [05-full-log-txt.md](./01-copy-formats/05-full-log-txt.md) | Raw log.txt format |
| [06-error-log-with-delegated-info.md](./01-copy-formats/06-error-log-with-delegated-info.md) | error.log.txt + Delegated Server Info |
| [07-envelope-error-response.md](./01-copy-formats/07-envelope-error-response.md) | Envelope Error JSON structure |
| [08-session-diagnostics.md](./01-copy-formats/08-session-diagnostics.md) | Session Diagnostics JSON |
| [09-generator-code-reference.md](./01-copy-formats/09-generator-code-reference.md) | Source files, signatures, replication guide |

---

*This file is kept as a redirect. All content lives in the subfolder above.*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-001b: Error-management conformance: Copy Formats

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
