# Acceptance Criteria — Wp Plugin How To

**Spec:** `spec/18-wp-plugin-how-to/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/18-wp-plugin-how-to/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-WP-NNN` — three-digit sequential.

**Test kind:** wp-cli + PHP lint  
**Top-level verification:**

```bash
bash tests/wp-plugin/run-acceptance.sh
```

---

## Criteria

### AC-WP-001: Plugin activates cleanly

**Given** A clean WordPress install.  
**When** `wp plugin activate <plugin-slug>`.  
**Then** Exit 0. No PHP warnings or errors emitted to stderr.

### AC-WP-002: PHP syntax

**Given** Every `.php` file in the plugin.  
**When** `find . -name '*.php' -exec php -l {} \;`.  
**Then** Every file MUST report `No syntax errors`.

### AC-WP-003: External cross-references

**Given** All references to `golang-standards` and `formatting-rules`.  
**When** Resolve each link.  
**Then** MUST resolve to an existing file (404 = hard fail). Tracked by `linter-scripts/check-spec-cross-links.py`.

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
