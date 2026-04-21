# Error Queue Navigation

> **Parent:** [Error Modal Reference](./00-overview.md)  
> **Version:** 2.2.0  
> **Updated:** 2026-03-31

---

Multiple concurrent errors are queued and navigable:

```tsx
// In ErrorStore:
errorQueue: CapturedError[];
currentQueueIndex: number;
navigateQueue: (direction: 'prev' | 'next') => void;
getQueuedErrorsMarkdown: () => string;  // All errors as one Markdown doc

// In GlobalErrorModal header:
{hasMultipleErrors && (
  <div className="flex items-center gap-1">
    <Button onClick={() => navigateQueue('prev')}>
      <ChevronLeft />
    </Button>
    <Badge>{currentQueueIndex + 1}/{errorQueue.length}</Badge>
    <Button onClick={() => navigateQueue('next')}>
      <ChevronRight />
    </Button>
    <Button onClick={copyAllErrors}>
      <CopyPlus /> All
    </Button>
  </div>
)}
```

---

*Queue navigation — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-011c: Error-management conformance: Queue Navigation

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
