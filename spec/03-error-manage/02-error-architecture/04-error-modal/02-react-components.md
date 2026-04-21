# ⚠️ THIS FILE HAS BEEN SPLIT INTO A SUBFOLDER

> **Moved to:** [02-react-components/00-overview.md](./02-react-components/00-overview.md)  
> **Date:** 2026-04-02  
> **Reason:** 751-line deprecated v3.0.0 file replaced by 9 focused v4.0.0 files.

---

## File Index → [02-react-components/](./02-react-components/)

| File | Content |
|------|---------|
| [00-overview.md](./02-react-components/00-overview.md) | Index, component architecture, cross-references |
| [01-typescript-interfaces.md](./02-react-components/01-typescript-interfaces.md) | All TypeScript interfaces and types |
| [02-error-store.md](./02-react-components/02-error-store.md) | Zustand error store |
| [03-api-types.md](./02-react-components/03-api-types.md) | API request/response types |
| [04-hooks.md](./02-react-components/04-hooks.md) | Custom React hooks |
| [05-component-hierarchy.md](./02-react-components/05-component-hierarchy.md) | Component tree and layout |
| [06-component-source.md](./02-react-components/06-component-source.md) | Full component source code |
| [07-report-generator.md](./02-react-components/07-report-generator.md) | Report generation functions |
| [08-integration-guide.md](./02-react-components/08-integration-guide.md) | Integration and usage guide |

---

*This file is kept as a redirect. All content lives in the subfolder above.*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-002c: Conformance check for this error-management rule

**Given** Run the error-handling linter against the codebase.  
**When** Run the verification command shown below.  
**Then** Zero empty `catch {}` blocks; every `apperror.New(...)` call carries a file/path context; all `Err*` identifiers are PascalCase.

**Verification command:**

```bash
grep -rnE 'catch[[:space:]]*\([^)]*\)[[:space:]]*\{[[:space:]]*\}' src/ ; test $? -eq 1
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
