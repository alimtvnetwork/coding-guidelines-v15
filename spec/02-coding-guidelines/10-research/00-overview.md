# Research

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Overview

Dedicated folder for comparative studies, technology evaluations, exploratory technical notes, and research that supports foundational coding guidelines. This includes game development research, framework comparisons, language evaluations, and any other exploratory work categorized as part of the foundational system.

---

## Placement Rule

All research content — including comparative studies, technology evaluations, and exploratory technical notes — MUST be placed in this folder (`10-research/`) unless explicitly categorized elsewhere by the spec authoring guide.

---

## Contents

_No content yet. Add research documents as numbered files within this folder._

---

## Cross-References

| Reference | Location |
|-----------|----------|
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
