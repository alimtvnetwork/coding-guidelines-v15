# Golang Coding Standards

> ⚠️ **This file has been split into a subfolder.** See [04-golang-standards-reference/00-overview.md](./04-golang-standards-reference/00-overview.md)

All content now lives in [`04-golang-standards-reference/`](./04-golang-standards-reference/).

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-004a: Coding guideline conformance: Golang Standards Reference

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
