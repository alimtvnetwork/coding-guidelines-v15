# Seedable Config Architecture — Features Index

**Updated:** 2026-04-20

---

## Feature Inventory

| # | File | Description | Status |
|---|------|-------------|--------|
| 01 | [01-rag-chunk-settings.md](./01-rag-chunk-settings.md) | RAG chunk size and overlap configuration | ✅ Active |
| 02 | [02-rag-validation-helpers.md](./02-rag-validation-helpers.md) | Go validation patterns for RAG config | ✅ Active |
| 03 | [03-rag-validation-tests.md](./03-rag-validation-tests.md) | Unit test specifications for validators | ✅ Active |
| 04 | [04-rag-test-coverage-matrix.md](./04-rag-test-coverage-matrix.md) | Test coverage matrix for RAG validation | ✅ Active |
| 05 | [05-validation-data-seeding.md](./05-validation-data-seeding.md) | CW Config → Root DB seeding pattern | ✅ Active |
| 06 | [06-update-check-keys.md](./06-update-check-keys.md) | `Update.*` and `Storage.Backend` keys for update-check subsystem | ✅ Active |

---

*Features index — updated: 2026-04-20*

---

## Verification

_Auto-generated section — see `spec/06-seedable-config-architecture/97-acceptance-criteria.md` for the full criteria index._

### AC-CFG-000a: Seedable-config conformance: Overview

**Given** Diff the running config tree against `config.seed.json` after a SemVer-aware GORM merge.  
**When** Run the verification command shown below.  
**Then** Merged keys preserve user overrides; new seed keys are added; removed seed keys are pruned; merge is idempotent on a second pass.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
