# Frontend Section (Tabs)

> **Parent:** [Error Modal Reference](./00-overview.md)  
> **Version:** 2.2.0  
> **Updated:** 2026-03-31

---

## Tab: Overview

- **Trigger Context** — Component → Action badge (e.g., `PluginCard → enable_clicked`)
- **Message** and **Details**
- **Call Chain** — Indented tree visualization of `invocationChain[]`
- **User Interaction Path** — Last 10 clicks with component name, text, action type, and route

## Tab: Stack

- **Parsed/Raw toggle** — Switch between parsed frame table and raw stack string
- **Show internal frames** — Toggle for node_modules frames
- **React Execution Chain** — From `useExecutionLogger` (component renders, effect triggers, handler calls)
- **Error Location** — File, line, function

## Tab: Context

- Full JSON context (`error.context`) with syntax highlighting via `JsonHighlighter`

## Tab: Fixes

- Suggested fixes keyed by error code (e.g., E1001 → check backend port, E5001 → check plugin activation)

---

*Frontend tabs — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-006c: Error-management conformance: Frontend Tabs

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
