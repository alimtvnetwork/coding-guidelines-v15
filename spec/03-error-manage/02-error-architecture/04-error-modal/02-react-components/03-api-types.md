# API Types & Methods

> **Parent:** [React Components Index](./00-overview.md)  
> **Version:** 4.0.0  
> **Updated:** 2026-04-01

---

## Review Compliance

| Rule | Status | Notes |
|------|--------|-------|
| No object-literal API | ✅ Fixed | Refactored to `ErrorApiService` class |
| No `unknown` / `any` | ✅ Clean | All return types explicitly typed |
| Function size ≤ 15 lines | ✅ Clean | Each method is 1–2 lines |
| Parameters ≤ 3 | ✅ Clean | Max 2 params per method |

---

## API Response Wrapper

```typescript
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    message: string;
    code?: string;
  };
}
```

## ErrorApiService Class

```typescript
import { HttpMethod } from '@/enums/HttpMethodType';
import type { CapturedError, SessionDiagnostics } from './ErrorModalTypes';

interface SessionLogsResponse {
  logs: string;
}

interface LogContentResponse {
  content: string;
}

/**
 * Encapsulates all error-related API calls.
 * Instantiate once; inject via context or import singleton.
 */
class ErrorApiService {
  private readonly request: <T>(url: string, options?: RequestInit) => Promise<ApiResponse<T>>;

  constructor(requestFn: <T>(url: string, options?: RequestInit) => Promise<ApiResponse<T>>) {
    this.request = requestFn;
  }

  getSessionLogs(sessionId: string): Promise<ApiResponse<SessionLogsResponse>> {
    return this.request<SessionLogsResponse>(`/sessions/${sessionId}/logs`);
  }

  getSessionDiagnostics(sessionId: string): Promise<ApiResponse<SessionDiagnostics>> {
    return this.request<SessionDiagnostics>(`/sessions/${sessionId}/diagnostics`);
  }

  getBackendErrorLog(): Promise<ApiResponse<LogContentResponse>> {
    return this.request<LogContentResponse>('/logs/error');
  }

  getBackendFullLog(): Promise<ApiResponse<LogContentResponse>> {
    return this.request<LogContentResponse>('/logs/full');
  }

  getErrorHistory(limit: number = 100): Promise<ApiResponse<CapturedError[]>> {
    return this.request<CapturedError[]>(`/error-history?limit=${limit}`);
  }

  postErrorHistory(error: CapturedError): Promise<ApiResponse<void>> {
    return this.request<void>('/error-history', {
      method: HttpMethod.Post,
      body: JSON.stringify(error),
    });
  }
}

/** Singleton instance — import this in components */
export const errorApi = new ErrorApiService(request);
```

### Violations Fixed (v3.2.0 → v4.0.0)

| Previous | Violation | Fix |
|----------|-----------|-----|
| `const api = { ... }` object literal | Not class-based, no encapsulation | → `ErrorApiService` class |
| Implicit return types | Missing explicit typing | → All methods have return type annotations |
| Inline response shapes | Unnamed types | → `SessionLogsResponse`, `LogContentResponse` interfaces |

---

*API types — updated: 2026-04-01*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-003c: Error-management conformance: Api Types

**Given** Audit error-handling sites for use of the `apperror` package, error codes, and explicit file/path logging.  
**When** Run the verification command shown below.  
**Then** Every error site uses `apperror.Wrap`/`apperror.New` with a registered code; no bare `errors.New` or swallowed errors remain.

**Verification command:**

```bash
python3 linter-scripts/check-forbidden-strings.py && go run linter-scripts/validate-guidelines.go --path spec --max-lines 15
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
