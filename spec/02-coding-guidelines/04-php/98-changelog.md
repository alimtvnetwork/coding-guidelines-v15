# PHP Standards — Changelog


**Version:** 3.2.0  
**Last Updated:** 2026-04-16  

All notable changes to the PHP Standards specification are documented here.

---

## v2.1.0 — 2026-03-31

### Changed
- `07-php-standards-reference.md` split into subfolder (5 files, max 252 lines — down from 840)
- Fixed spacing violations in code examples

---

## v2.0.0 — 2026-03-09

### Global Version Bump

Project-wide major version increment (+1.0.0) applied to all specification files in `03-coding-guidelines/04-php`.

#### Changed
- All spec files received a major version bump and date update to 2026-03-09.
- Part of a global effort spanning ~638 files across all 30+ spec folders, establishing a new project-wide versioning baseline.

---

*Keep this file updated when specs change.*

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
