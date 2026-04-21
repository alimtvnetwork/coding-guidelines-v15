# Feature: Keyboard Navigation

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Specification

### Key Bindings

| Key | Action |
|-----|--------|
| `→` | Next file within current folder |
| `←` | Previous file within current folder |
| `↓` | Next folder (jump to first file) |
| `↑` | Previous folder (jump to first file) |

### Guards

- Only active when no `<input>`, `<textarea>`, or `[contenteditable]` is focused
- Only active when a file is currently selected (no-op on welcome screen)

### Edge Cases

- At last file in folder → wraps to first file in same folder
- At last folder → wraps to first folder

---

*Keyboard navigation — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-004b: Conformance check for this docs-viewer UI rule

**Given** Run the Playwright suite for the docs viewer.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation works (`j`/`k` move selection); document tree validates against `schemas/doc-tree.schema.json`; zero hardcoded colors in viewer components.

**Verification command:**

```bash
bunx playwright test tests/docs-viewer/
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
