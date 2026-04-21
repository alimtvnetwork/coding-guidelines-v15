# Master Coding Guidelines — Quick checklist for any code change

> **Parent:** [Master Coding Guidelines](./00-overview.md)  
> **Version:** 2.1.0  
> **Updated:** 2026-03-31

---

## Quick Checklist for Any Code Change

```
[ ] Naming: camelCase variables, PascalCase classes/enums/DB columns
[ ] JSON/API keys: PascalCase (e.g., "PluginSlug", "SiteId" — never "SITE_ID" or "siteId")
[ ] Abbreviations: Id (not ID), Url (not URL), Md5 (not MD5), Json (not JSON), Api (not API)
[ ] Null guards: isDefined()/isDefinedAndValid() — never raw != null/nil + isValid()
[ ] Null safety: check err before value, nil before dereference, len before index
[ ] Booleans: is/has prefix, no negative words, no raw ! on calls
[ ] Enums: Type suffix, isEqual() not ===, PascalCase case names
[ ] DB: PascalCase tables/columns, PascalCase array keys for inserts
[ ] Formatting: braces always, zero nesting, blank before return, 15-line max
[ ] Nesting: zero nested if — use early returns, named booleans, extracted functions
[ ] Newlines: blank before return (multi-line), no double blanks, no blank at function start
[ ] Errors: apperror.Wrap (Go), Throwable imported (PHP), no fmt.Errorf
[ ] Results: hasError()/isSafe() checked before .value()/.Value() — use .AppError() in Go (not .Error())
[ ] Single return: Go functions return ONE value (Result[T] or typed struct) — never (T, bool, error)
[ ] No casting: zero type assertions in Go business logic — use concrete structs
[ ] No magic strings: all via enums/typed constants
[ ] Mutation: assign once, no post-construction mutation, mutex for concurrent state
[ ] Regex: last resort, compile at package level (Go), no regex in loops
[ ] Lazy eval: non-exported field + getter, mutex for concurrent, cascade lazy dependencies
[ ] Defer: max one per function (Go), top or bottom placement only
[ ] Log keys: camelCase in PHP context arrays
[ ] Types: no any/interface{} (Go), native types + no redundant PHPDoc (PHP)
[ ] Tests: three-part naming, AAA pattern, table-driven for 3+ cases, t.Helper() in Go helpers
```

---

*Master coding guidelines v2.0.0 — 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-007b: Coding guideline conformance: Checklist

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
