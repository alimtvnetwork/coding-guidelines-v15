# Acceptance Criteria — Generic Cli

**Spec:** `spec/13-generic-cli/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/13-generic-cli/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-CLI-NNN` — three-digit sequential.

**Test kind:** CLI smoke + JSON-schema  
**Top-level verification:**

```bash
bash tests/generic-cli/acceptance.sh
```

---

## Criteria

### AC-CLI-001: Version command

**Given** The compiled CLI on PATH as `bin`.  
**When** `bin --version`.  
**Then** Exit 0. Stdout MUST match `^\d+\.\d+\.\d+$`.

### AC-CLI-002: Help lists every subcommand

**Given** `03-subcommand-architecture.md` with the canonical subcommand list.  
**When** `bin --help`.  
**Then** Exit 0. Stdout MUST contain every subcommand name from the spec (substring match, case-sensitive).

### AC-CLI-003: Export JSON schema

**Given** Sample input data.  
**When** `bin export --format=json > /tmp/out.json`.  
**Then** Exit 0. `check-jsonschema --schemafile schemas/cli-export.schema.json /tmp/out.json` MUST exit 0.

### AC-CLI-004: Limit-flag regex

**Given** Any subcommand accepting `--limit`.  
**When** Pass `--limit 999999` and `--limit abc`.  
**Then** Numeric arg MUST match `^\d{1,6}$` and succeed. Non-numeric MUST fail with exit 2.

---

## Waiver policy

A criterion may be waived only by:
1. Adding an entry to `linter-scripts/spec-cross-links.allowlist` (for link checks), or
2. Editing this file to mark the criterion `**Waived (rationale: ...)**` with a tracking issue link.

Silent waivers (commented-out tests, skipped assertions without rationale) are forbidden.

---

## Validation history

| Date | Version | Action |
|------|---------|--------|
| 2026-04-21 | 1.0.0 | Initial acceptance criteria — generated from spec patch plan |

---

*Acceptance Criteria — updated: 2026-04-21*
