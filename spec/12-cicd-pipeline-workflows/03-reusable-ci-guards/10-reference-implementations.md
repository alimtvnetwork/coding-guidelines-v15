# Pattern 10 — Reference Implementations

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Purpose

Patterns 01–06 describe **what** each guard does and **why**.
Patterns 07–09 describe the **wrapper, config, and workflow** layers.
This document catalogues the **concrete, copy-pasteable scripts** that
sit under [`/.github/scripts/`](../../../.github/scripts/) and
implement every guard end-to-end.

An AI assistant generating CI for a new repo should:

1. Read the per-pattern doc (`01`–`06`) for the algorithm.
2. Copy the matching script from `.github/scripts/` as the starting
   point.
3. Adapt language-specific defaults using the per-language section in
   each pattern doc.
4. Wire the script through `scripts/ci-runner.sh` and the workflow
   templates in `.github/workflow-templates/`.

---

## Script Inventory

| Script | Pattern | Runtime | Inputs | Default Behaviour |
|--------|---------|---------|--------|-------------------|
| `check-forbidden-names.sh` | 01 | Bash + grep | `$1` source dir, `CI_GUARDS_FORBIDDEN_NAMES_*` | Scans `*.go` for verb-only / verb+generic-noun functions |
| `check-naming.sh` | 02 | Bash + awk | `CONST_DIR`, `BASELINE_FILE`, `--regenerate-baseline` | Diffs current vs baseline; mawk-portable extractor |
| `check-collisions.py` | 03 | Python 3.10+ | `CI_GUARDS_COLLISIONS_FILE_GLOB` | Reports identifiers declared in >1 file, raw-string aware |
| `lint-diff.py` | 04 | Python 3.10+ | `--current`, `--baseline`, `--normalizer` | Compares golangci/eslint JSON; only NEW findings fail |
| `lint-suggest.py` | 05 | Python 3.10+ | `--current`, `--baseline`, `--out`, `--table` | Markdown table appended to `GITHUB_STEP_SUMMARY` |
| `test-summary.sh` | 06 | Bash + grep | `$1` results dir, `CI_GUARDS_TEST_SUMMARY_*` | Shard PASS/FAIL counts + reason excerpts |

All scripts honour the shared exit-code contract from Pattern 07:
`0` clean · `1` violation · `2` tool error.

---

## Runtime Requirements

| Tool | Min Version | Notes |
|------|-------------|-------|
| `bash` | 4.0 | Associative arrays for forbidden patterns (optional) |
| `awk` | mawk or gawk | `check-naming.sh` uses POSIX-only `match()` + `RSTART`/`RLENGTH` |
| `grep` | GNU 3.0 | `-E`, `-H`, `-R`, `--include` |
| `python3` | 3.10 | Type hints (`X \| None`), `argparse` from stdlib |

No third-party packages required. Tested on `ubuntu-latest` runners.

---

## Smoke Test Recipe

```bash
# 1) Forbidden-name guard — clean dir
mkdir -p /tmp/smoke && \
  bash .github/scripts/check-forbidden-names.sh /tmp/smoke
# Expect: exit 0

# 2) Forbidden-name guard — violation
echo 'func runOne() {}' > /tmp/smoke/bad.go && \
  bash .github/scripts/check-forbidden-names.sh /tmp/smoke
# Expect: ::error...; exit 1

# 3) Wrapper end-to-end with JSON summary
bash scripts/ci-runner.sh \
  --phase check \
  --source-dir /tmp/smoke \
  --json /tmp/summary.json
cat /tmp/summary.json
# Expect: {"phase":"check","overall":1,...}
```

---

## Adapting for Other Languages

Each script's defaults target Go because that's where the patterns
were proven. To adapt:

- **Override via config** (preferred): set the relevant block in
  `ci-guards.yaml` (Pattern 08). The loader emits `CI_GUARDS_*` env
  vars that override the script defaults — no source edits needed.
- **Fork the script** (for novel languages): copy the file, change the
  default values at the top, and point `--scripts-dir` at the fork.

The per-language sections of Patterns 01–06 list the regex patterns,
file globs, and prefix rules for Node, Python, and Rust.

---

## Cross-References

- [00-overview.md](./00-overview.md)
- [07-shared-cli-wrapper.md](./07-shared-cli-wrapper.md) — Wrapper that dispatches to these scripts
- [08-config-schema.md](./08-config-schema.md) — Config keys mapped to the env vars these scripts read
- [09-workflow-templates.md](./09-workflow-templates.md) — GitHub Actions glue
- [`.github/scripts/README.md`](../../../.github/scripts/README.md) — Direct-invocation reference

---

*Reference implementations — v1.0.0 — 2026-04-21*