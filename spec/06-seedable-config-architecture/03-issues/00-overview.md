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

### AC-CFG-000a: Seedable-config conformance: Overview

**Given** Diff the running config tree against `config.seed.json` after a SemVer-aware GORM merge.  
**When** Run the verification command shown below.  
**Then** Merged keys preserve user overrides; new seed keys are added; removed seed keys are pruned; merge is idempotent on a second pass.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
