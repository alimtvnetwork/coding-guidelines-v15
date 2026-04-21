# Golang Standards

**Version:** 3.2.0  
**Status:** Active  
**Updated:** 2026-04-16  
**AI Confidence:** High  
**Ambiguity:** None

---


## Keywords

`coding`, `golang`, `guidelines`

---

## Scoring

| Criterion | Status |
|-----------|--------|
| `00-overview.md` present | ✅ |
| AI Confidence assigned | ✅ |
| Ambiguity assigned | ✅ |
| Keywords present | ✅ |
| Scoring table present | ✅ |


## Purpose

Go-specific coding standards and patterns.

---

## Document Inventory

| File |
|------|
| 02-boolean-standards.md |
| 03-httpmethod-enum.md |
| 04-golang-standards-reference.md |
| 05-defer-rules.md |
| 06-string-slice-internals.md |
| 07-code-severity-taxonomy.md |
| 08-pathutil-fileutil-spec.md |
| 98-changelog.md |
| 99-consistency-report.md |
| 97-acceptance-criteria.md |

| 02-boolean-standards.md |
| 03-httpmethod-enum.md |
| 04-golang-standards-reference.md |
| 05-defer-rules.md |
| 06-string-slice-internals.md |
| 07-code-severity-taxonomy.md |
| 08-pathutil-fileutil-spec.md |
| 97-acceptance-criteria.md |
| 98-changelog.md |
| 99-consistency-report.md |
---

## Cross-References

_See parent folder's `00-overview.md` for broader context._

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
