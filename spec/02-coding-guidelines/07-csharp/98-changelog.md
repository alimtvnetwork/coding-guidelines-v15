# C# Coding Standards — Changelog

**Module:** `07-csharp`

---

## [1.0.0] — 2026-04-02

### Added
- `00-overview.md` — C# coding standards overview with cross-references
- `01-naming-and-conventions.md` — PascalCase methods, `I` prefix interfaces, abbreviation casing, boolean naming
- `02-method-design.md` — Boolean flag splitting, function size limits, async patterns, LINQ usage
- `03-error-handling.md` — Specific exception catching, guard clauses, nullable reference types
- `04-type-safety.md` — Generics over object, pattern matching, records for DTOs, no magic strings
- `97-acceptance-criteria.md` — 30+ testable checks across 7 acceptance categories
- `99-consistency-report.md` — Initial health report (A+)

### Cross-Language Integration
- Added C# examples to `01-cross-language/24-boolean-flag-methods.md`
- Added C# examples to `01-cross-language/25-generic-return-types.md`
- Added 6 C#-specific checks to `06-ai-optimization/02-ai-quick-reference-checklist.md`
- Added C# column to README key standards table

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-098a: Coding guideline conformance: Changelog

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
