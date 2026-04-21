# Split DB Architecture — Features Index

**Updated:** 2026-04-16

---

## Feature Inventory

| # | File | Description | Status |
|---|------|-------------|--------|
| 01 | [01-cli-examples.md](./01-cli-examples.md) | CLI database structure examples (AI Bridge, GSearch, BRun, Nexus Flow) | ✅ Active |
| 02 | [02-reset-api-standard.md](./02-reset-api-standard.md) | 2-step reset API standard with 5-min TTL | ✅ Active |
| 03 | [03-database-flow-diagrams.md](./03-database-flow-diagrams.md) | Visual architecture diagrams for all CLIs | ✅ Active |
| 04 | [04-rbac-casbin.md](./04-rbac-casbin.md) | Role-Based Access Control with Casbin | ✅ Active |
| 05 | [05-user-scoped-isolation.md](./05-user-scoped-isolation.md) | User-scoped database isolation patterns | ✅ Active |

---

*Features index — updated: 2026-04-03*

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
