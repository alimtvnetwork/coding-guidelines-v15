# Acceptance Criteria — Cicd Pipeline Workflows

**Spec:** `spec/12-cicd-pipeline-workflows/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/12-cicd-pipeline-workflows/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-CI-NNN` — three-digit sequential.

**Test kind:** Workflow YAML schema + dry-run  
**Top-level verification:**

```bash
bash linters-cicd/run-all.sh --workflows-only
```

---

## Criteria

### AC-CI-001: Workflow YAML schema

**Given** Every file in `.github/workflows/`.  
**When** `check-jsonschema --schemafile schemas/github-workflow.json .github/workflows/*.yml`.  
**Then** Exit 0 for every file. Any schema violation is a hard fail.

### AC-CI-002: Release artifact count

**Given** A published GitHub release at tag `$TAG`.  
**When** `gh release view $TAG --json assets --jq '.assets|length'`.  
**Then** Result MUST be `>=` the artifact count declared in `00-overview.md`.

### AC-CI-003: Tag SemVer format

**Given** The last 10 git tags.  
**When** Iterate `git tag --sort=-v:refname | head -10`.  
**Then** Every tag MUST match `^v\d+\.\d+\.\d+(-(alpha|beta|rc)\.\d+)?$`.

### AC-CI-004: Inventory zero-diff

**Given** `00-overview.md` and `99-consistency-report.md`.  
**When** Compare file lists.  
**Then** MUST agree on file count and file names. Zero diff.

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
