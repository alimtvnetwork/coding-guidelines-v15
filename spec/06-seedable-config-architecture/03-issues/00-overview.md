# Seedable Config Architecture — Issues Index

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

_Auto-generated section — see `spec/06-seedable-config-architecture/97-acceptance-criteria.md` for the full criteria index._

### AC-CFG-000b: Conformance check for this seedable config rule

**Given** Run the config-merge unit tests.  
**When** Run the verification command shown below.  
**Then** Seed merge is idempotent (re-run produces byte-identical output) and preserves user overrides + unknown keys.

**Verification command:**

```bash
go test ./config/... -run TestSeedMerge
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
