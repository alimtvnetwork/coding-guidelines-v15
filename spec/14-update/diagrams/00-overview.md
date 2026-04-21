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

### AC-UPD-000b: Conformance check for this self-update rule

**Given** Run the update-flow acceptance harness.  
**When** Run the verification command shown below.  
**Then** `update --check` exit codes are 0 (none) / 10 (available) / >10 (error); on a `kill -9` mid-update the previous binary is restored (rename-first invariant).

**Verification command:**

```bash
bash tests/update/acceptance.sh
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
