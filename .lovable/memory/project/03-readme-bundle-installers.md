---
name: README Bundle Installers + GIFs
description: README has 7 bundle one-liners, walkthrough GIF, install-flow GIF; full improvement plan in spec/17/30
type: feature
---

## Status (as of v3.55.0, 2026-04-22)

**Shipped:**
- `public/images/coding-guidelines-walkthrough.gif` — 7-slide editorial deck (DejaVuSans + LiberationMono, 960×540, 145 KB, 34s loop). Embedded at top of `readme.md` under the Spec Viewer screenshot.
- `public/images/install-flow.gif` — terminal install demo (144 KB). Embedded inside the new **Bundle Installers** section.
- `readme.md` **Bundle Installers** section — 7-row matrix with bash + PowerShell one-liners, "pick a bundle by goal" table, traits list. Links to `bundles.json`.
- TOC entry added.
- All 7 bundles verified present: error-manage, splitdb, slides, linters, cli, wp, consolidated. Each has `<bundle>-install.sh` + `<bundle>-install.ps1` + spec folders + `bundles.json` registration.
- New consolidated files registered in `spec/17-consolidated-guidelines/00-overview.md`: 28 (distribution-and-runner), 29 (blind-ai-audit-v3), 30 (readme improvement suggestions).

**Pending — driven by `spec/17-consolidated-guidelines/30-readme-improvement-suggestions.md`:**
- Phase A: Above-the-fold rewrite (auto-stamped file count, elevator pitch, badges)
- Phase B: Promote bundle matrix to top, add verify + uninstall sections
- Phase C: Split readme.md into `readme.md` + `docs/*.md` (currently 1379 lines, violates 300-line rule)
- Phase D: AI-agent canonical-entry-points section
- Phase E: Visual polish + accessibility

## How to regenerate the GIFs

Both render scripts are in `/tmp/gifgen/`. They use:
- Slides: `DejaVuSans.ttf` (the only sans font reliably available on the sandbox; LiberationSans is missing)
- Terminal: `LiberationMono-{Regular,Bold}.ttf`

If a render shows hollow rectangles instead of letters, the font path resolution fell through to the wrong fallback — re-confirm with `fc-match -f "%{file}\n" sans-serif`.

## Why this matters

The README is the single first impression for any human or AI landing on the repo. The bundle matrix turns "what do I install?" from a wiki-crawl into a single table lookup. The walkthrough GIF makes the value of the guidelines visceral in 8 seconds (5 principles → before/after refactor → 7 bundles → install demo).