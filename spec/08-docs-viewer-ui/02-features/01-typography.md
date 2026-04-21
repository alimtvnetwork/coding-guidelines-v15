# Feature: Typography System

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Specification

### Google Fonts Integration

Add to `index.html` `<head>`:

```html
<link href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@400;500;600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
```

### CSS Variables (index.css)

```css
--font-heading: 'Ubuntu', sans-serif;
--font-body: 'Poppins', sans-serif;
```

### Tailwind Config

```ts
fontFamily: {
  heading: ['Ubuntu', 'sans-serif'],
  body: ['Poppins', 'sans-serif'],
}
```

### Application Rules

| Selector | Font | Class |
|----------|------|-------|
| `h1, h2, h3, h4` | Ubuntu | `font-heading` |
| `body, p, li, td, span` | Poppins | `font-body` |
| `code, pre` | System monospace | (unchanged) |

---

*Typography — updated: 2026-04-03*

---

## Verification

_Auto-generated section — see `spec/08-docs-viewer-ui/97-acceptance-criteria.md` for the full criteria index._

### AC-UI-001b: Conformance check for this docs-viewer UI rule

**Given** Run the Playwright suite for the docs viewer.  
**When** Run the verification command shown below.  
**Then** Keyboard navigation works (`j`/`k` move selection); document tree validates against `schemas/doc-tree.schema.json`; zero hardcoded colors in viewer components.

**Verification command:**

```bash
bunx playwright test tests/docs-viewer/
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
