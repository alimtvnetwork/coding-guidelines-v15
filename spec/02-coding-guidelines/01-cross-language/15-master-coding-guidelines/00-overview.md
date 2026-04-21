# Master Coding Guidelines

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Keywords

`15-master-coding-guidelines` · `coding-standards`

---

## Scoring

| Criterion | Status |
|-----------|--------|
| `00-overview.md` present | ✅ |
| AI Confidence assigned | ✅ |
| Ambiguity assigned | ✅ |
| Keywords present | ✅ |
| Scoring table present | ✅ |

---

## Purpose

Previously a single 1122-line file, now split into focused modules under 300 lines each.

---

## Document Inventory

| # | File | Purpose | Lines |
|---|------|---------|-------|
| — | [01-naming-and-database.md](./01-naming-and-database.md) | Naming conventions, database naming, file naming | 174 |
| — | [02-boolean-and-enum.md](./02-boolean-and-enum.md) | Boolean standards, isDefined guards, enum standards | 213 |
| — | [03-code-style-and-errors.md](./03-code-style-and-errors.md) | Code style formatting, error handling | 277 |
| — | [04-type-safety.md](./04-type-safety.md) | Type safety, single return value, no casting | 221 |
| — | [05-magic-strings-and-organization.md](./05-magic-strings-and-organization.md) | Magic strings, file organization, array keys | 127 |
| — | [06-advanced-patterns.md](./06-advanced-patterns.md) | Lint, enum sync, tests, lazy eval, regex, mutation, null safety, nesting, newlines, defer | 177 |
| — | [07-checklist.md](./07-checklist.md) | Quick checklist for any code change | 41 |
| — | 99-consistency-report.md | — | — |

| — | 99-consistency-report.md | — | — |
---

## Cross-References

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-000c: Conformance check for this coding guideline section

**Given** Run the Code-Red metrics validator against the project sources.  
**When** Run the verification command shown below.  
**Then** Zero violations of the rules in this section. Functions ≤15 lines, files <300 lines, components <100 lines, no nested `if`.

**Verification command:**

```bash
python3 linter-scripts/validate-guidelines.py spec || python3 linter-scripts/check-forbidden-strings.py
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
