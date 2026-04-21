# Acceptance Criteria — Powershell Integration

**Spec:** `spec/11-powershell-integration/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/11-powershell-integration/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-PS-NNN` — three-digit sequential.

**Test kind:** Pester + ScriptAnalyzer  
**Top-level verification:**

```bash
pwsh -Command 'Invoke-Pester tests/powershell/ -CI'
```

---

## Criteria

### AC-PS-001: Pester suite green

**Given** PowerShell 7+ installed.  
**When** `pwsh -Command 'Invoke-Pester tests/powershell/ -CI'`.  
**Then** Exit 0, FailedCount = 0. CI artifact `pester-results.xml` MUST be uploaded.

### AC-PS-002: Run.ps1 template exists and lints

**Given** The repo at HEAD.  
**When** Verify file then lint.  
**Then** `Test-Path templates/run.ps1` MUST be `$true`. `Invoke-ScriptAnalyzer -Severity Error templates/run.ps1` MUST return zero diagnostics.

### AC-PS-003: Go version regex

**Given** `go version` is in PATH.  
**When** Capture its stdout.  
**Then** Output MUST match `^go version go(\d+\.\d+\.\d+) `. Captured group 1 is the SemVer string used downstream.

### AC-PS-004: Node version regex

**Given** `node --version` is in PATH.  
**When** Capture its stdout.  
**Then** Output MUST match `^v(\d+\.\d+\.\d+)$`. Captured group 1 is the SemVer string used downstream.

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
