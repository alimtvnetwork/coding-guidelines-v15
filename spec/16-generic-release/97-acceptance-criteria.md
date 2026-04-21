# Acceptance Criteria — Generic Release

**Spec:** `spec/16-generic-release/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/16-generic-release/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-REL-NNN` — three-digit sequential.

**Test kind:** Cross-compile matrix  
**Top-level verification:**

```bash
bash tests/release/matrix-check.sh
```

---

## Criteria

### AC-REL-001: Build matrix coverage

**Given** A successful release build.  
**When** List release artifacts.  
**Then** MUST include all six pairs: `linux/amd64`, `linux/arm64`, `darwin/amd64`, `darwin/arm64`, `windows/amd64`, `windows/arm64`.

### AC-REL-002: Tag regex

**Given** Every release tag.  
**When** Iterate tags.  
**Then** MUST match `^v\d+\.\d+\.\d+(-(alpha|beta|rc)\.\d+)?$`.

### AC-REL-003: Install scripts smoke-tested in CI

**Given** A release workflow run.  
**When** Inspect job matrix.  
**Then** MUST include `ubuntu-latest`, `macos-latest`, `windows-latest` runners executing `install.sh`/`install.ps1` end-to-end.

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
