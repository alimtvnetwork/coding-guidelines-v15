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

### AC-CG-000a: Coding guideline conformance: Overview

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
