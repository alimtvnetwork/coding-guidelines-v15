# Acceptance Criteria — Distribution And Runner

**Spec:** `spec/15-distribution-and-runner/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/15-distribution-and-runner/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-DIST-NNN` — three-digit sequential.

**Test kind:** Install + runner contract  
**Top-level verification:**

```bash
bash tests/distribution/acceptance.sh && pwsh tests/distribution/acceptance.ps1
```

---

## Criteria

### AC-DIST-001: Windows install path

**Given** A clean Windows host with PowerShell 7+.  
**When** Run `install.ps1` then `Test-Path $env:LOCALAPPDATA/<app>/bin/<app>.exe`.  
**Then** Result MUST be `$true`.

### AC-DIST-002: POSIX install path

**Given** A clean Linux/macOS host.  
**When** Run `install.sh` then `[ -x "$HOME/.local/bin/<app>" ]`.  
**Then** Exit 0.

### AC-DIST-003: Runner exit-code mapping

**Given** The runner binary on PATH.  
**When** Trigger each documented failure mode.  
**Then** Exit codes MUST be: 0 success, 1 usage, 2 config, 3 network, 4 auth, 64+ internal.

### AC-DIST-004: Documented dependencies

**Given** Every install/runner script.  
**When** Scan the script header.  
**Then** MUST declare required deps: `bun >=1.1`, `git >=2.40`, `unzip`, `curl`. Missing dep block is a hard fail.

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
