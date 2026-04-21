# Diagrams — Self-Update & App Update

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Purpose

Index of all Mermaid diagrams supporting the self-update and app update specifications. These diagrams visualize decision trees and workflows described in the parent module.

---

## Diagram Inventory

| # | File | Description | Format |
|---|------|-------------|--------|
| 01 | [01-self-update-workflow.mmd](./01-self-update-workflow.mmd) | Full 9-step `<binary> update` command decision tree with error handling and rollback paths | Mermaid |
| 02 | [02-update-cleanup-workflow.mmd](./02-update-cleanup-workflow.mmd) | 2-phase `<binary> update-cleanup` workflow covering temp copies and `.old` backup removal | Mermaid |

**Total:** 2 diagrams

---

## Rendering

These `.mmd` files use Mermaid flowchart syntax. To render:

- **VS Code**: Install the "Mermaid Preview" extension
- **GitHub**: Mermaid blocks render natively in `.md` files (wrap in ` ```mermaid ` fences)
- **CLI**: Use `mmdc` from `@mermaid-js/mermaid-cli`

---

## Cross-References

| Reference | Location |
|-----------|----------|
| Update Command Workflow (references these diagrams) | [../16-update-command-workflow.md](../16-update-command-workflow.md) |
| Self-Update Overview | [../01-self-update-overview.md](../01-self-update-overview.md) |
| Cleanup Specification | [../06-cleanup.md](../06-cleanup.md) |

---

*Diagrams Overview — v3.2.0 — 2026-04-15*

---

## Verification

_Auto-generated section — see `spec/14-update/97-acceptance-criteria.md` for the full criteria index._

### AC-UPD-000a: Self-update conformance: Overview

**Given** Exercise the rename-first deploy path against a fixture release directory.  
**When** Run the verification command shown below.  
**Then** `latest.json` is written atomically; the old binary is renamed (not deleted) before the new one is moved into place; rollback restores the previous version.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
