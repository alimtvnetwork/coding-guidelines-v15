# Changelog: Static Analysis & Linter Enforcement

All notable changes to the `16-static-analysis/` subfolder.

---

## [1.2.0] — 2026-04-01

### Added
- `10-cross-language-rule-matrix.md` — side-by-side SonarQube rule mapping across all 8 languages
- `97-acceptance-criteria.md` — acceptance criteria for the subfolder
- `98-changelog.md` — this file

## [1.1.0] — 2026-04-01

### Added
- `09-ci-pipeline-quality-gate.md` — unified CI pipeline spec with GitHub Actions and GitLab CI templates
- `99-consistency-report.md` — initial consistency report

### Changed
- All 8 language specs bumped to v1.1.0 — standardized Keywords/Scoring sections, integration checklist format, and added missing SonarQube rules (S1126, S4144)
- `00-overview.md` bumped to v1.1.0 — added CI pipeline to inventory

## [1.0.0] — 2026-03-31

### Added
- `00-overview.md` — subfolder overview with document inventory and rule mapping table
- `02-go-golangci-lint.md` — Go static analysis spec
- `03-php-phpcs-phpstan.md` — PHP static analysis spec
- `04-csharp-stylecop.md` — C# static analysis spec
- `05-rust-clippy.md` — Rust static analysis spec
- `06-vb-dotnet-analyzers.md` — VB.NET static analysis spec
- `07-nodejs-eslint.md` — Node.js static analysis spec
- `08-python-ruff.md` — Python static analysis spec

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-098b: Coding guideline conformance: Changelog

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
