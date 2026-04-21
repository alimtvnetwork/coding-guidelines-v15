# Feature: Fullscreen Mode

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Specification

### Trigger

- Button in the doc header bar (Maximize2 icon from lucide-react)
- Keyboard shortcut: `F` key (when no input focused)

### Behavior

- Fullscreen hides the sidebar and expands the content area to fill the viewport
- Header remains visible with a minimize button to exit
- `Escape` key also exits fullscreen
- Implemented via React state (not browser Fullscreen API) for better control

---

*Fullscreen mode — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-003b: Conformance check for this docs-viewer UI rule

**Given** Run the Playwright suite for the docs viewer.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation works (`j`/`k` move selection); document tree validates against `schemas/doc-tree.schema.json`; zero hardcoded colors in viewer components.

**Verification command:**

```bash
bunx playwright test tests/docs-viewer/
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
