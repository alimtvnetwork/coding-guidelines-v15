# Seedable Config Architecture — Changelog


**Version:** 3.2.0  
**Last Updated:** 2026-04-16  

All notable changes to the Seedable Config Architecture specification are documented here.

---

## v2.0.0 — 2026-03-09

### Global Version Bump

Project-wide major version increment (+1.0.0) applied to all specification files in `07-seedable-config-architecture`.

#### Changed
- All spec files received a major version bump and date update to 2026-03-09.
- Part of a global effort spanning ~638 files across all 30+ spec folders, establishing a new project-wide versioning baseline.

---

*Keep this file updated when specs change.*

---

## v3.4.0 — 2026-04-20

### Repository Slug Migration

Updated all references from `coding-guidelines-v14` to `coding-guidelines-v15` across distribution and CI/CD specifications.

#### Changed
- Install scripts, CI templates, and release pipelines now reference `coding-guidelines-v15` repository slug
- Affected specs: Distribution & Runner (15), Generic Release (16), CI/CD Integration (02), Update Check Mechanism (14)
- 42 files updated with 440 total reference replacements

---

## Verification

_Auto-generated section — see `spec/06-seedable-config-architecture/97-acceptance-criteria.md` for the full criteria index._

### AC-CFG-097: Seedable-config conformance: Changelog

**Given** Diff the running config tree against `config.seed.json` after a SemVer-aware GORM merge.  
**When** Run the verification command shown below.  
**Then** Merged keys preserve user overrides; new seed keys are added; removed seed keys are pruned; merge is idempotent on a second pass.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
