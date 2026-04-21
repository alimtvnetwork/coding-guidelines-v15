# Docs Viewer UI — Features Index

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Feature Inventory

| # | Feature | Status | File |
|---|---------|--------|------|
| 01 | Typography (Ubuntu + Poppins) | ✅ Implemented | [01-typography](./01-typography.md) |
| 02 | Syntax Highlighting | ✅ Implemented | [02-syntax-highlighting](./02-syntax-highlighting.md) |
| 03 | Fullscreen Mode | ✅ Implemented | [03-fullscreen-mode](./03-fullscreen-mode.md) |
| 04 | Keyboard Navigation | ✅ Implemented | [04-keyboard-navigation](./04-keyboard-navigation.md) |
| 05 | Copy Markdown Button | ✅ Implemented | [05-copy-markdown](./05-copy-markdown.md) |
| 06 | Shortcuts Help Overlay | ✅ Implemented | [06-shortcuts-overlay](./06-shortcuts-overlay.md) |
| 07 | UI Theme, Colors & Animations | ✅ Implemented | [06-ui-theme-animations](./06-ui-theme-animations.md) |
| 08 | Visual Rendering & Component Guide | ✅ Implemented | [07-visual-rendering-guide](./07-visual-rendering-guide.md) |

---

*Features index — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-000a: Docs viewer UI conformance: Overview

**Given** Render the docs viewer against the spec tree fixture.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation, syntax highlighting, fullscreen toggle, and copy-markdown all function without console errors.

**Verification command:**

```bash
npm run test
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
