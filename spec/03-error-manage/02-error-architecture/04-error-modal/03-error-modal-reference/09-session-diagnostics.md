# Session Diagnostics Auto-Fetch

> **Parent:** [Error Modal Reference](./00-overview.md)  
> **Version:** 2.3.0  
> **Updated:** 2026-04-01

---

When `sessionId` is present, the `BackendSection` automatically fetches deep diagnostics using React Query:

> **v2.3.0:** Replaced manual `useState`/`useEffect` with `useQuery`. Replaced `Record<string, unknown>` and `unknown` with typed interfaces.

```tsx
// src/hooks/useSessionDiagnostics.ts
import { useQuery } from '@tanstack/react-query';

async function fetchSessionData(sessionId: string): Promise<{
  diagnostics: SessionDiagnostics | null;
  logs: string | null;
}> {
  const [logsRes, diagRes] = await Promise.all([
    errorApi.getSessionLogs(sessionId),
    errorApi.getSessionDiagnostics(sessionId),
  ]);
  return {
    logs: logsRes.success ? logsRes.data?.logs ?? null : null,
    diagnostics: diagRes.success ? diagRes.data ?? null : null,
  };
}

export function useSessionDiagnostics(sessionId?: string): SessionDiagnosticsResult {
  const { data, isLoading, error, refetch } = useQuery({
    queryKey: ['session-diagnostics', sessionId],
    queryFn: () => fetchSessionData(sessionId!),
    enabled: Boolean(sessionId),
    staleTime: 30_000,
    retry: 1,
  });

  return {
    diagnostics: data?.diagnostics ?? null,
    logs: data?.logs ?? null,
    loading: isLoading,
    error: error instanceof Error ? error.message : null,
    refetch,
  };
}
```

---

## SessionDiagnostics Shape

```typescript
/** Typed HTTP headers map */
interface HttpHeaders {
  [header: string]: string;
}

/** Typed request body for session diagnostics */
interface SessionRequestBody {
  [key: string]: string | number | boolean | null;
}

interface SessionDiagnostics {
  request?: {
    method: string;
    url: string;
    headers?: HttpHeaders;
    body?: SessionRequestBody;
  };
  response?: {
    statusCode: number;
    requestUrl: string;   // The full PHP endpoint that processed the request
    headers?: HttpHeaders;
    body?: string;
  };
  stackTrace?: {
    golang?: SessionStackFrame[];
    php?: SessionStackFrame[];
  };
  phpStackTraceLog?: string;  // Raw stacktrace.txt content
}

interface SessionStackFrame {
  function: string;
  file?: string;
  line?: number;
  class?: string;
}
```

---

*Session diagnostics — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-009c: Error-management conformance: Session Diagnostics

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
