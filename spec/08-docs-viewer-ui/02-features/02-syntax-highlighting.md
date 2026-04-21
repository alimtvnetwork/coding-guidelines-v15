# Feature: Syntax Highlighting

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Specification

### Library

- **highlight.js** — lightweight, 40+ languages, auto-detection
- Theme: `github-dark` for dark mode, `github` for light mode
- Only register needed languages: `typescript`, `go`, `php`, `css`, `json`, `bash`, `sql`, `rust`

### Integration Point

In `MarkdownRenderer.tsx`, replace the plain `<pre><code>` output with highlight.js-processed HTML.

### Copy Button on Code Blocks

Each code block gets a floating "Copy" button (top-right corner) that copies the raw code to clipboard.

---

*Syntax highlighting — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-002a: Docs viewer UI conformance: Syntax Highlighting

**Given** Render the docs viewer against the spec tree fixture.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation, syntax highlighting, fullscreen toggle, and copy-markdown all function without console errors.

**Verification command:**

```bash
npm run test
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
