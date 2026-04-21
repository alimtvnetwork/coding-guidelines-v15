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

### AC-UI-004a: Docs viewer UI conformance: Keyboard Navigation

**Given** Render the docs viewer against the spec tree fixture.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation, syntax highlighting, fullscreen toggle, and copy-markdown all function without console errors.

**Verification command:**

```bash
npm run test
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
