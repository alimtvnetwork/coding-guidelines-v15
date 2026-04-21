# Changelog: Rust Standards

**Version:** 3.2.0

---

## [1.1.0] — 2026-03-30

- Added AI Confidence and Ambiguity scores to overview
- Added Keywords and Scoring table

## [1.0.0] — 2026-03-09

- Initial Rust standards: naming, error handling, async, memory safety, testing, FFI

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
