# Feature: Shortcuts Help Overlay

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Specification

### Trigger

- `?` key (when no input focused)
- Also accessible via a keyboard icon button in the header

### Content

Displays a modal/overlay listing all keyboard shortcuts in a clean grid:

| Key | Action |
|-----|--------|
| `←` / `→` | Previous / Next file |
| `↑` / `↓` | Previous / Next folder |
| `F` | Toggle fullscreen |
| `?` | Toggle this help |
| `Escape` | Close overlay / exit fullscreen |

### Dismiss

- `Escape` key or clicking outside the overlay

---

*Shortcuts overlay — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-006a: Docs viewer UI conformance: Shortcuts Overlay

**Given** Render the docs viewer against the spec tree fixture.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation, syntax highlighting, fullscreen toggle, and copy-markdown all function without console errors.

**Verification command:**

```bash
npm run test
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
