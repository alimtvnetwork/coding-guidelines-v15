# Feature: Copy Markdown Button

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Specification

### Trigger

- Button in the doc header bar (Copy icon from lucide-react)
- Copies the raw markdown content of the active file to clipboard

### Feedback

- Button text/icon changes to "Copied!" with a checkmark for 2 seconds
- Uses `navigator.clipboard.writeText()`

---

*Copy markdown — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-005a: Docs viewer UI conformance: Copy Markdown

**Given** Render the docs viewer against the spec tree fixture.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation, syntax highlighting, fullscreen toggle, and copy-markdown all function without console errors.

**Verification command:**

```bash
npm run test
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
