# TypeScript ExportStatus Enum — `src/lib/enums/export-status.ts`

> **Version**: 1.0.0  
> **Last updated**: 2026-02-27  
> **Tracks**: Issue #10 (`spec/23-how-app-issues-track/10-domain-status-magic-strings.md`)

---

## Purpose

Typed enum for import/export operation lifecycle states. Replaces `exportStatus === 'completed'` magic strings in frontend specs.

---

## Reference Implementation

```typescript
// src/lib/enums/export-status.ts

export enum ExportStatus {
  Pending = "PENDING",
  Processing = "PROCESSING",
  Completed = "COMPLETED",
  Failed = "FAILED",
}
```

---

## Usage Patterns

### Status Comparisons

```typescript
// ❌ WRONG: Magic string
if (exportStatus === 'completed') { ... }

// ✅ CORRECT: Enum constant
if (exportStatus === ExportStatus.Completed) { ... }
```

### Conditional Rendering

```typescript
// ❌ WRONG
{!isExporting && exportStatus !== 'completed' && <ExportForm />}

// ✅ CORRECT
{!isExporting && exportStatus !== ExportStatus.Completed && <ExportForm />}
```

### Type Definitions

```typescript
// ❌ WRONG
interface ExportState {
  status: 'pending' | 'processing' | 'completed' | 'failed';
}

// ✅ CORRECT
interface ExportState {
  status: ExportStatus;
}
```

---

## Consuming Spec Files

| Spec File | Pattern Replaced |
|-----------|-----------------|
| `05-features/03-project-management/02-import-export-ui.md` | `exportStatus === 'completed'/'failed'/'processing'` |
| `05-features/27-automation-pipeline/20-import-export.md` | Import/export status checks |

---

## Cross-Language Parity

| Feature | Go | TypeScript |
|---------|-----|-----------|
| Package | `pkg/enums/exportstatus` | `src/lib/enums/export-status.ts` |
| Type | `byte` iota | String enum |
| Values | `Pending`, `Processing`, `Completed`, `Failed` | Same |

---

## Cross-References

- Issue #10 — Domain Status Magic Strings <!-- external: spec/23-how-app-issues-track/10-domain-status-magic-strings.md -->
- [HttpMethod Enum](./05-http-method-enum.md) — Sibling enum spec
- [TypeScript Standards](./08-typescript-standards-reference.md) — Parent spec

---

*ExportStatus enum v1.0.0 — 2026-02-27*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-004a: Coding guideline conformance: Export Status Enum

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
