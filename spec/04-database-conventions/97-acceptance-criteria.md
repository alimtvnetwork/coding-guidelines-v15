# Acceptance Criteria — Database Conventions

**Spec:** `spec/04-database-conventions/`  
**Version:** 1.0.0  
**Updated:** 2026-04-21  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

Deterministic, machine-verifiable acceptance criteria for `spec/04-database-conventions/`. 
Each criterion is written in Given/When/Then form with an exact verification command.
An AI implementing this spec is considered conformant if and only if every `MUST` 
criterion below is satisfied with exit code 0.

---

## Test ID format

`AC-DB-NNN` — three-digit sequential.

**Test kind:** SQL schema linter  
**Top-level verification:**

```bash
python linter-scripts/check-db-schema.py path/to/schema.sql
```

---

## Criteria

### AC-DB-001: Table name PascalCase singular

**Given** A SQL DDL file `path/to/schema.sql` containing `CREATE TABLE` statements.  
**When** Run `python linter-scripts/check-db-schema.py path/to/schema.sql`.  
**Then** Every table name MUST match regex `^[A-Z][A-Za-z]+$`. Examples that MUST FAIL: `users`, `created_at`, `Users_Roles`. Examples that MUST PASS: `User`, `OrderLine`.

### AC-DB-002: Primary key naming and type

**Given** A table named `<TableName>` in DDL.  
**When** Inspect the column list.  
**Then** The PK column MUST be named `<TableName>Id` and typed `INTEGER PRIMARY KEY AUTOINCREMENT`. No UUIDs, no `id`, no `pk`.

### AC-DB-003: NOT NULL by default

**Given** Any DDL column declaration.  
**When** Scan every column.  
**Then** All columns MUST be `NOT NULL` unless explicitly listed in the table-level `NULLABLE_COLUMNS` waiver block at the top of the file.

### AC-DB-004: Forbidden tokens

**Given** The full DDL text.  
**When** `grep -E '(createdAt|created_at|UUID|uuid_generate_v4)' path/to/schema.sql`.  
**Then** MUST return zero matches. Any hit is a hard fail.

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
