# App Issues

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Overview

App-specific issue analysis, root cause analysis, bug documentation, and solution guidance. This folder tracks problems encountered during application development, their diagnosis, and their resolution.

---

## Placement Rule

Any content that analyzes bugs, failures, root causes, or fixes for application-level work belongs here. General coding principle violations or cross-cutting concerns belong in the core fundamentals range (01–20).

---

## Contents

_No content yet. Add app issue analyses as numbered files within this folder._

---

## Cross-References

| Reference | Location |
|-----------|----------|
| App Specs | [../21-app/00-overview.md](../21-app/00-overview.md) |
| Coding Guidelines Spec | [../00-overview.md](../00-overview.md) |

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
