# Suggestions

**Version:** 3.5.0  
**Updated:** 2026-04-19

---

## Active Suggestions

### Publish the app
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-16
- All features ready; make spec docs accessible via published URL.

### End-to-end browser testing
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-16
- Test all 4 view modes (Preview, Source, Edit, Split) + download.

### Mobile responsive testing
- **Status:** Pending **Priority:** Low **Added:** 2026-04-16
- Verify sidebar collapse behavior on mobile.

### Search/filter in spec tree
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-16
- Improves navigation for 568+ files.

### Breadcrumb navigation
- **Status:** Pending **Priority:** Low **Added:** 2026-04-16

### Update consistency report
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-16
- Reflect expanded `01-spec-authoring.md` (95%) and `16-app-design-system-and-ui.md` (93%).

### Expand remaining sub-90% guidelines
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-16

### Smoke-test BOOL-NEG-001 in full pipeline
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-19
- Run `linters-cicd/run-all.sh` end-to-end with the SQL fixture.

### Add Go-aware BOOL-NEG-001 variant
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-19
- Scan `embed.FS` SQL strings in Go source.

### Unit tests for BOOL-NEG-001
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-19

### Round-trip tests for codegen inversion table
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-19
- Assert `invert(invert(x)) == x` for every canonical pair.

### Wire codegen into CI
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-19
- Add `run-all.sh` step + `git diff --exit-code`.

### Strengthen BOOL-NEG-001 with replacement hints
- **Status:** Pending **Priority:** Low **Added:** 2026-04-19

### Linter for missing descriptive columns
- **Status:** Pending **Priority:** Medium **Added:** 2026-04-19
- Flag entity tables missing `Description`, transactional tables missing `Notes`/`Comments`.

### Cross-link Rule 9 / Rules 10–12 from related specs
- **Status:** Pending **Priority:** Low **Added:** 2026-04-19

---

## Implemented Suggestions

### Syntax highlighting for Source view — 2026-04-05
### Light/dark theme toggle — 2026-04-05
### Persistent theme preference (localStorage) — 2026-04-05
### Discriminated union + enum pattern for state — 2026-04-05
### Validate-guidelines as final health check — 2026-04-05
### Download folder as ZIP — 2026-04-05
### Regenerate `specTree.json` after restructuring — 2026-04-05
### Version bump all docs and UI to 3.1.0 — 2026-04-16
### Update consistency report after error-manage restructuring — 2026-04-16
### Placeholder guidelines 11/12/13 filled with real content — 2026-04-16
### Expanded `01-spec-authoring.md` to 95% — 2026-04-16
### Expanded `16-app-design-system-and-ui.md` to 93% — 2026-04-16
### Created `22-app-database.md` consolidated guideline — 2026-04-16
### Created write-memory prompt — 2026-04-16
- Re-saved as canonical v1.0.0 in `prompts/03-write-prompt.md` on 2026-04-19.

### CICD performance spec implementation — 2026-04-19
- Middle-out walker, `--jobs`, `--check-timeout`, `TOOL-TIMEOUT` synthetic SARIF. linters-cicd v3.12.0.

### `--version` flag on every check script — 2026-04-19
- Shared via `_lib/cli.py` using `argparse` `action="version"`. linters-cicd v3.13.0.

### Database naming Rule 9 (auto-inverted computed fields) — 2026-04-19
- `01-naming-conventions.md` v3.3.0 → v3.4.0 → v3.5.0. Three-bucket Rule 8 + Rules 10/11/12.

### BOOL-NEG-001 linter check — 2026-04-19
- `checks/boolean-column-negative/sql.py` with 10-name allow-list. linters-cicd v3.14.0.

### Inverted-field codegen tool — 2026-04-19
- `linters-cicd/codegen/` for Go methods / PHP traits / TS getter mixins.

### Cross-link Rule 9 from boolean specs — 2026-04-19
- `02-boolean-principles/00-overview.md` + `12-no-negatives.md` (v2.2.0).

### Schema design §6 Mandatory Descriptive Columns — 2026-04-19
- `02-schema-design.md` v3.3.0.

### Restructure `.lovable/` to single-file convention — 2026-04-19
- Removed `completed-tasks/`, `pending-tasks/`, `suggestions/`, `strictly-avoid/` directories.

---

*Suggestions — v3.5.0 — 2026-04-19*
