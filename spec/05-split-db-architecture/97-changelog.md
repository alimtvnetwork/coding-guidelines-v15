# Split DB Architecture — Changelog


**Version:** 3.2.0  
**Last Updated:** 2026-04-16  

All notable changes to the Split DB Architecture specification are documented here.

---

## v2.0.0 — 2026-03-09

### Global Version Bump

Project-wide major version increment (+1.0.0) applied to all specification files in `06-split-db-architecture`.

#### Changed
- All spec files received a major version bump and date update to 2026-03-09.
- Part of a global effort spanning ~638 files across all 30+ spec folders, establishing a new project-wide versioning baseline.

---

*Keep this file updated when specs change.*

---

## Verification

_Auto-generated section — see `spec/05-split-db-architecture/97-acceptance-criteria.md` for the full criteria index._

### AC-SDB-097: Split-DB architecture conformance: Changelog

**Given** Inspect Root/App/Session DB lifecycle wiring and Casbin RBAC enforcement points.  
**When** Run the verification command shown below.  
**Then** Each tier opens its own SQLite handle (WAL mode), policy reload happens on Casbin policy change, and user-scope isolation is enforced by row filters.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
