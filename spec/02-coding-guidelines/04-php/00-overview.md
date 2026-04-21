# PHP Standards

**Version:** 3.2.0  
**Status:** Active  
**Updated:** 2026-04-16  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Keywords

`coding`, `guidelines`, `php`, `enums`, `naming`, `spacing`, `response-key`

---

## Purpose

PHP-specific coding standards and patterns for the RiseupAsia namespace.

---

## Document Inventory

| # | File | Description |
|---|------|-------------|
| 01 | `01-enums.md` | PHP enum patterns |
| 02 | `02-forbidden-patterns.md` | Forbidden PHP patterns |
| 03 | `03-naming-conventions.md` | PHP naming conventions |
| 05 | `05-response-array-standard.md` | Response array standards |
| 07 | `07-php-standards-reference/00-overview.md` | PHP standards reference |
| 08 | `08-spacing-and-imports.md` | Spacing and import rules |
| 09 | `09-response-key-type-inventory.md` | ResponseKeyType case inventory (176 cases) |
| 10 | `10-php-go-consistency-audit.md` | PHP–Go cross-language consistency audit |
| — | 01-enums.md | — |
| — | 02-forbidden-patterns.md | — |
| — | 03-naming-conventions.md | — |
| — | 05-response-array-standard.md | — |
| — | 07-php-standards-reference.md | — |
| — | 08-spacing-and-imports.md | — |
| — | 09-response-key-type-inventory.md | — |
| — | 10-php-go-consistency-audit.md | — |
| — | 97-acceptance-criteria.md | — |
| — | 98-changelog.md | — |
| — | 99-consistency-report.md | — |

| — | 01-enums.md | — |
| — | 02-forbidden-patterns.md | — |
| — | 03-naming-conventions.md | — |
| — | 05-response-array-standard.md | — |
| — | 07-php-standards-reference.md | — |
| — | 08-spacing-and-imports.md | — |
| — | 09-response-key-type-inventory.md | — |
| — | 10-php-go-consistency-audit.md | — |
| — | 97-acceptance-criteria.md | — |
| — | 98-changelog.md | — |
| — | 99-consistency-report.md | — |
**Total:** 8 spec files + acceptance criteria, changelog, consistency report

---

## Cross-References

- [Cross-Language Guidelines](../01-cross-language/00-overview.md)
- [Go Standards](../03-golang/00-overview.md) — for PHP–Go parity
- [Parent Overview](../00-overview.md)

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
