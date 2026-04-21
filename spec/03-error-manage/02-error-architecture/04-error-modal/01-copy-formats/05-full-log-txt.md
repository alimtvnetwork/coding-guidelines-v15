# log.txt (Backend Full Log)

> **Parent:** [Copy Formats Index](./00-overview.md)  
> **Version:** 3.2.0  
> **Updated:** 2026-03-31  
> **Purpose:** Raw text file from `GET /api/v1/logs/full`. Contains ALL log entries (info, warn, error).

---

## Sample Entry

```
[2026-02-12 00:53:30] [INFO] GET /api/v1/sites
  Duration: 12ms
  Status: 200

[2026-02-12 00:53:30] [INFO] GET /api/v1/sites/1/mappings
  Duration: 8ms
  Status: 200

[2026-02-12 00:53:34] [ERROR] GET /api/v1/sites/1/snapshots/settings
  Duration: 4190ms
  Status: 500
  Error: [E3001] failed to fetch snapshot settings...
```

---

*log.txt format — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-005c: Error-management conformance: Full Log Txt

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
