# Error Modal — Reusable React Components (Index)

> **Parent:** [Error Modal Spec](../00-overview.md)  
> **Version:** 4.0.0  
> **Updated:** 2026-04-01
> **AI Confidence:** 95%  
> **Ambiguity Score:** 5%  
> **Purpose:** Portable React code for rebuilding the Global Error Modal in any project.

---

## File Index

| # | File | Section | Description |
|---|------|---------|-------------|
| 01 | [01-typescript-interfaces.md](./01-typescript-interfaces.md) | TypeScript Interfaces | CapturedError, SessionDiagnostics, shared props |
| 02 | [02-error-store.md](./02-error-store.md) | Error Store (Zustand) | Store interface, key behaviors, stack trace parser |
| 03 | [03-api-types.md](./03-api-types.md) | API Types & Methods | Required API endpoints |
| 04 | [04-hooks.md](./04-hooks.md) | Hooks | useSessionDiagnostics |
| 05 | [05-component-hierarchy.md](./05-component-hierarchy.md) | Component Hierarchy | File structure + component props summary |
| 06 | [06-component-source.md](./06-component-source.md) | Component Source Code | All 7 major components with code patterns |
| 07 | [07-report-generator.md](./07-report-generator.md) | Error Report Generator | generateErrorReport + suggested fixes |
| 08 | [08-integration-guide.md](./08-integration-guide.md) | Integration Guide | Setup, React Query, utilities, adaptation |

---

## Architecture Overview

```
GlobalErrorModal (Dialog shell)
├── Header (error code, timestamp, queue navigation)
├── Section Toggle: Backend | Frontend
├── BackendSection (primary diagnostic view)
│   ├── Overview Tab
│   ├── Log Tab (error.log.txt viewer)
│   ├── Execution Tab (Go call chain + backend logs)
│   ├── Stack Tab (Go/PHP/Delegated stack frames)
│   ├── Session Tab (SessionLogsTab — 4 sub-tabs)
│   ├── Request Tab (RequestDetails — 3-hop chain)
│   └── Traversal Tab (TraversalDetails — endpoint flow)
├── FrontendSection
│   ├── Overview Tab (trigger, click path, call chain)
│   ├── Stack Tab (parsed/raw JS stack frames)
│   ├── Context Tab (JSON viewer)
│   └── Fixes Tab (suggested fixes by error code)
├── Footer
│   ├── DownloadDropdown (ZIP, error.log, log.txt, .md)
│   └── CopyDropdown (full report, with backend, logs)
```

**Dependencies:** React 18+, Zustand, Tailwind CSS, shadcn/ui (Dialog, Tabs, Badge, Button, ScrollArea, DropdownMenu), Lucide React icons.

---

## Document Inventory

| File |
|------|
| 99-consistency-report.md |


## Cross-References

- [Error Modal Spec](../03-error-modal-reference/00-overview.md) — Full modal structure, data model, and UX specification
- [Copy Format Samples](../01-copy-formats/00-overview.md) — Complete samples for all copy/export formats
- [Error Handling Spec](../../01-error-handling-reference.md) — Cross-stack error architecture
- [Response Envelope Schema](../../05-response-envelope/envelope.schema.json) — JSON Schema source of truth

---

*React components index — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-000c: Error-management conformance: Overview

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
