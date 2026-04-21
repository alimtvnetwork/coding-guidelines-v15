# App Database

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**AI Confidence:** Draft  
**Ambiguity:** None

---

## Purpose

App-specific database specifications under coding guidelines. Covers data model decisions, table designs, and query patterns unique to this application.

---

## Contents

_No content yet. Add database design documents as numbered files within this folder._

---

## Cross-References

| Reference | Location |
|-----------|----------|
| Coding Guidelines Overview | [../00-overview.md](../00-overview.md) |
| Consolidated Database Conventions | [../../17-consolidated-guidelines/18-database-conventions.md](../../17-consolidated-guidelines/18-database-conventions.md) |

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-000b: Conformance check for this coding guideline section

**Given** Run the Code-Red metrics validator against the project sources.  
**When** Run the verification command shown below.  
**Then** Zero violations of the rules in this section. Functions ≤15 lines, files <300 lines, components <100 lines, no nested `if`.

**Verification command:**

```bash
python3 linter-scripts/validate-guidelines.py spec || python3 linter-scripts/check-forbidden-strings.py
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
