# AI Optimization

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**AI Confidence:** Production-Ready  
**Ambiguity:** None

---

## Purpose

AI-specific guidelines designed to prevent hallucination and ensure AI-generated code meets all project standards. Contains explicit forbidden patterns, quick validation checklists, and common mistake catalogs.

---

## Files

| # | File | Description |
|---|------|-------------|
| 01 | [01-anti-hallucination-rules.md](./01-anti-hallucination-rules.md) | 30+ explicit "never generate X" rules with forbidden/required patterns |
| 02 | [02-ai-quick-reference-checklist.md](./02-ai-quick-reference-checklist.md) | 50-check pre-output validation checklist |
| 03 | [03-common-ai-mistakes.md](./03-common-ai-mistakes.md) | Top 15 real mistakes AI makes, with before/after corrections |
| 04 | [04-condensed-master-guidelines.md](./04-condensed-master-guidelines.md) | Sub-200-line distillation of master guidelines for AI context windows |
| 05 | [05-enum-naming-quick-reference.md](./05-enum-naming-quick-reference.md) | Cross-language enum naming rules: Go, TypeScript, PHP — declaration, naming, usage, validation checklist |

---

## How AI Should Use This Section

1. **Before generating code:** Scan the quick-reference checklist (02)
2. **During generation:** Apply anti-hallucination rules (01) to each code block
3. **After generation:** Verify against common mistakes (03)
4. **For enum code:** Consult the enum naming quick reference (05)

---

*AI optimization overview for coding guidelines.*

## Document Inventory

| File |
|------|
| 97-acceptance-criteria.md |
| 99-consistency-report.md |

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-000a: Coding guideline conformance: Overview

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
