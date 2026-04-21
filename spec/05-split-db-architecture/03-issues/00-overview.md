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

### AC-SDB-000a: Split-DB architecture conformance: Overview

**Given** Inspect Root/App/Session DB lifecycle wiring and Casbin RBAC enforcement points.  
**When** Run the verification command shown below.  
**Then** Each tier opens its own SQLite handle (WAL mode), policy reload happens on Casbin policy change, and user-scope isolation is enforced by row filters.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
