# .github/scripts — Reusable CI guard implementations

This directory ships the concrete scripts dispatched by
`scripts/ci-runner.sh`. Each script implements one of the 6 reusable
CI guards documented in
[`spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/`](../../spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/).

| Script | Pattern | Spec doc |
|--------|---------|----------|
| `check-forbidden-names.sh` | 01 — Forbidden-Name Guard | `01-forbidden-name-guard.md` |
| `check-naming.sh` | 02 — Grandfather-Baseline Naming | `02-grandfather-baseline-naming.md` |
| `check-collisions.py` | 03 — Cross-File Collision Audit | `03-cross-file-collision-audit.md` |
| `lint-diff.py` | 04 — Baseline-Diff Lint Gate | `04-baseline-diff-lint-gate.md` |
| `lint-suggest.py` | 05 — Actionable Lint Suggestions | `05-actionable-lint-suggestions.md` |
| `test-summary.sh` | 06 — Matrix Test Aggregator | `06-matrix-test-aggregator.md` |

## Exit-code contract

All scripts honour the wrapper contract:

| Code | Meaning |
|------|---------|
| `0` | Clean — no violations |
| `1` | Violation detected |
| `2` | Tool error (missing input, unreadable file) |

`lint-suggest.py` is advisory and always exits `0` unless a tool error
occurs; the suggestion table is appended to `GITHUB_STEP_SUMMARY`.

## Configuration

Scripts read from `CI_GUARDS_*` environment variables emitted by
`scripts/ci-config.mjs` (Pattern 08). When run standalone they fall
back to documented Go-flavoured defaults.

## Direct invocation

```bash
# Pattern 01 — scan a directory for forbidden names
bash .github/scripts/check-forbidden-names.sh src/cmd

# Pattern 02 — gate or regenerate the grandfather baseline
bash .github/scripts/check-naming.sh
bash .github/scripts/check-naming.sh --regenerate-baseline

# Pattern 03 — find duplicate identifiers across files
python3 .github/scripts/check-collisions.py

# Pattern 04 — diff current lint report vs baseline
python3 .github/scripts/lint-diff.py --current golangci.json --baseline .cache/lint-baseline.json

# Pattern 05 — actionable suggestions for new findings
python3 .github/scripts/lint-suggest.py --current golangci.json --baseline .cache/lint-baseline.json

# Pattern 06 — aggregate matrix shards
bash .github/scripts/test-summary.sh ./test-artifacts
```

## Wrapper invocation (preferred)

```bash
bash scripts/ci-runner.sh --phase all --config ci-guards.yaml
```

See [`spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/07-shared-cli-wrapper.md`](../../spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/07-shared-cli-wrapper.md)
for the full flag contract.