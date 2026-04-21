# Component Hierarchy

> **Parent:** [React Components Index](./00-overview.md)  
> **Version:** 3.2.0  
> **Updated:** 2026-03-31

---

## File Structure

```
src/components/errors/
├── GlobalErrorModal.tsx       # Root modal shell (Dialog, header, footer, section toggle)
├── BackendSection.tsx         # Backend diagnostic tabs (Overview, Log, Execution, Stack, Session, Request, Traversal)
├── FrontendSection.tsx        # Frontend tabs (Overview, Stack, Context, Fixes)
├── SessionLogsTab.tsx         # Session sub-tabs (Logs, Request, Response, Stack Trace)
├── RequestDetails.tsx         # 3-hop request chain visualization
├── TraversalDetails.tsx       # Endpoint flow + methods stack + delegated error stack
├── ErrorModalActions.tsx      # Download & Copy dropdown menus (reused by both modals)
├── ErrorModalTypes.ts         # Shared types (PHPStackFrame, AppInfo, SectionCommonProps)
├── ErrorQueueBadge.tsx        # Floating badge showing error count
├── ErrorDetailModal.tsx       # Standalone detail modal (error history / E2E tests page)
├── ErrorHistoryDrawer.tsx     # Side drawer listing recent errors
├── AppErrorBoundary.tsx       # React error boundary wrapper
├── errorReportGenerator.ts    # Pure function: CapturedError → Markdown report (compact + full)
└── errorLogAdapter.ts         # Maps backend ErrorLog → CapturedError for ErrorDetailModal

src/stores/
└── errorStore.ts              # Zustand store for error state management

src/hooks/
└── useSessionDiagnostics.ts   # Hook for fetching session diagnostics
```

---

## Component Props Summary

| Component | Key Props |
|-----------|-----------|
| `GlobalErrorModal` | None (reads from `useErrorStore`) |
| `BackendSection` | `error`, `phpStackFrames`, `errorLogContent`, `errorLogLoading`, `copySection`, `formatTs` |
| `FrontendSection` | `error`, `showRawStack`, `displayFrames`, `suggestedFixes`, `copySection`, `formatTs` |
| `SessionLogsTab` | `sessionId`, `sessionType` |
| `RequestDetails` | `error`, `copySection`, `sessionDiagnostics` |
| `TraversalDetails` | `error`, `copySection` |
| `DownloadDropdown` | `error`, `appName`, `appVersion`, `gitCommit`, `buildTime` |
| `CopyDropdown` | `error`, `appName`, `appVersion`, `gitCommit`, `buildTime`, `copyFullError` |
| `ErrorDetailModal` | `open`, `onOpenChange`, `error` (receives `ErrorLog`, adapts internally) |

---

*Component hierarchy — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-005c: Error-management conformance: Component Hierarchy

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
