# Split DB Architecture — Issues Index

**Updated:** 2026-04-16

---

## Issue Tracker

| # | Issue | Status | Priority |
|---|-------|--------|----------|
| — | No open issues | — | — |

---

*Issues index — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/05-split-db-architecture/97-acceptance-criteria.md` for the full criteria index._

### AC-SDB-000b: Conformance check for this split-DB architecture rule

**Given** Initialize the app and inspect the on-disk DB hierarchy.  
**When** Run the verification command shown below.  
**Then** Root, App, and Session DB files exist at the documented paths and report `journal_mode=wal` via `PRAGMA journal_mode;`.

**Verification command:**

```bash
bash tests/split-db/acceptance.sh
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
