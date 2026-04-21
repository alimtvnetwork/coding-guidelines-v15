# Golang Coding Standards — File naming, size, function size, nesting ban

> **Parent:** [Golang Coding Standards](./00-overview.md)  
> **Version:** 3.7.0  
> **Updated:** 2026-03-31

---

## File Naming — PascalCase, No Underscores

Every `.go` file MUST be named in **PascalCase** matching its primary definition (struct, interface, or concept). No underscores.

| ❌ Forbidden | ✅ Required | Why |
|-------------|-----------|-----|
| `plugin_service.go` | `PluginService.go` | Named after the struct |
| `upload_handler.go` | `UploadHandler.go` | Named after the struct |
| `string_utils.go` | `StringUtils.go` | Named after the concept |
| `sync_repo.go` | `SyncRepo.go` | Named after the struct |

**Rule:** If a file contains a struct, the file is named after that struct. All methods on that struct live in the same file. If the file exceeds the 300-line target, split using PascalCase suffixes:

| Suffix | Purpose |
|--------|---------|
| `Plugin.go` | Struct + constructors |
| `PluginCrud.go` | Database operations |
| `PluginHelpers.go` | Private utilities |
| `PluginValidation.go` | Validation logic |

---


---

## File Size — Target 300 Lines (Soft Limit 400)

Every `.go` file targets **300 lines**. Up to **400 lines is acceptable** but must include a top-of-file comment: `// NOTE: Needs refactor — exceeds 300-line target`.

---


---

## Function Size — Max 15 Lines

> **Canonical source:** [Cross-Language Code Style](../../01-cross-language/04-code-style/00-overview.md) — Rule 6

Every function body must be **15 lines or fewer**. Extract logic into small, well-named helpers.

```go
// ❌ FORBIDDEN: Long function
func ProcessUpload(ctx context.Context, req UploadRequest) error {
    // 20+ lines of validation, upload, logging...
}

// ✅ REQUIRED: Decomposed
func ProcessUpload(ctx context.Context, req UploadRequest) error {
    if err := validateUpload(req); err != nil {
        return err
    }

    result := executeUpload(ctx, req)
    if result.HasError() {
        return result.AppError()
    }

    return logAndRespond(ctx, result.Value())
}
```

---


---

## Zero Nested `if` — Absolute Ban

> **Canonical source:** [Cross-Language Code Style](../../01-cross-language/04-code-style/00-overview.md) — Rule 2 & 7

Nested `if` blocks are **absolutely forbidden** — zero tolerance. Flatten with combined conditions or early returns.

```go
// ❌ FORBIDDEN — nested if with negative checks
if err != nil {
    if resp != nil {
        handleError(resp)
    }
}

// ❌ ALSO FORBIDDEN — mixed negative checks in one condition
if err != nil && resp != nil {
    handleError(resp)
}

// ✅ REQUIRED — positive named booleans, flat
hasError := err != nil
hasResponse := resp != nil
hasIssue := hasError && hasResponse

if hasIssue {
    handleError(resp)
}
```

---


---

## Abbreviation Casing — First Letter Only

> **Canonical source:** [Master Coding Guidelines §1.2](../../01-cross-language/15-master-coding-guidelines/00-overview.md)

Abbreviations in identifiers are treated as regular words — only capitalize the first letter. This applies to struct fields, variables, function names, parameters, enum constants, and `variantLabels` values.

| ❌ Wrong | ✅ Correct | Why |
|----------|-----------|-----|
| `SerpAPI` | `SerpApi` | API → Api |
| `BaseURL` | `BaseUrl` | URL → Url |
| `RequiresAPIKey` | `RequiresApiKey` | API → Api |
| `WithURL` | `WithUrl` | URL → Url |
| `postID` | `postId` | ID → Id |
| `fileURL` | `fileUrl` | URL → Url |
| `parseJSON` | `parseJson` | JSON → Json |
| `toYAML` | `toYaml` | YAML → Yaml |
| `httpAPI` | `httpApi` | API → Api |
| `sqlDB` | `sqlDb` | DB → Db |
| `htmlOutput` | `htmlOutput` | ✅ already correct (lowercase prefix) |

**Exemptions (Go standard library interfaces only):**
- `MarshalJSON()` / `UnmarshalJSON()` — required by `encoding/json`
- `Error() string` — required by `error` interface
- `String() string` — required by `fmt.Stringer`

These interface method names are mandated by Go's standard library and MUST retain their original spelling. All other identifiers follow the abbreviation rule.

---


---

## File Naming & Organization

### File Naming Rules

| Rule | Convention | Example |
|------|-----------|---------|
| File name | `snake_case.go` | `server_config.go`, `status_type.go` |
| Maps to primary type | File name derived from its exported type | `ServerConfig` → `server_config.go` |
| One exported type per file | Each struct/interface/enum gets its own file | Don't combine `Config` + `ServerConfig` |
| Related methods stay together | All methods on a type live in its file | `StatusType.IsValid()` stays in `status_type.go` |
| Suffix convention | Split large types using suffixes | `_crud.go`, `_helpers.go`, `_validation.go` |
| Package directory | `snake_case` for multi-word | `site_health/`, `search_mode/` |

### Splitting Convention (When Files Exceed 300 Lines)

| Suffix | Purpose | Example |
|--------|---------|---------|
| `{type}.go` | Struct + constructors | `config.go` |
| `{type}_crud.go` | Database CRUD operations | `plugin_crud.go` |
| `{type}_helpers.go` | Private utility functions | `config_helpers.go` |
| `{type}_validation.go` | Input/business rule validation | `upload_validation.go` |
| `{type}_json.go` | JSON marshal/unmarshal methods | `error_json.go` |

### Package Naming Rules

Go packages follow strict naming conventions:

| Rule | Convention | Example |
|------|-----------|---------|
| Lowercase only | No underscores, no mixed case | `sitehealth`, not `site_health` or `SiteHealth` |
| Short and clear | Prefer one word when possible | `auth`, `config`, `sync` |
| No stuttering | Package name must not repeat in exported identifiers | `config.Config` ❌ → `config.Settings` ✅ |
| No generic names | Avoid `util`, `common`, `misc`, `helpers` as package names | Use domain-specific names instead |
| Directory matches package | Directory name = package declaration | `internal/backup/` → `package backup` |

```go
// ❌ FORBIDDEN: Package name stutters in exported type
package config
type ConfigManager struct {} // config.ConfigManager stutters

// ✅ REQUIRED: No stutter
package config
type Manager struct {} // config.Manager reads cleanly

// ❌ FORBIDDEN: Uppercase or underscores in package name
package SiteHealth
package site_health

// ✅ REQUIRED: Lowercase, no separators
package sitehealth
```

### Package Directory Naming

```
// ✅ Correct — enum packages end with 'type' suffix, no underscores
internal/enums/logleveltype/
internal/enums/snapshotmodetype/
internal/services/sitehealth/

// ❌ Wrong
internal/enums/logLevel/
internal/enums/log_level/
internal/enums/SnapshotMode/
internal/services/SiteHealth/
```

### File-to-Type Mapping Examples

```
// ✅ One type per file, name matches
config.go           → type Config struct
server_config.go    → type ServerConfig struct
watcher_config.go   → type WatcherConfig struct
status_type.go      → type StatusType byte + methods
error_json.go       → MarshalJSON/UnmarshalJSON on AppError

// ❌ Wrong: multiple unrelated types in one file
config.go           → Config + ServerConfig + WatcherConfig + BackupConfig
```

### Cross-References

- [Boolean Flag Method Splitting](../../01-cross-language/24-boolean-flag-methods.md) — Split bool-flag methods into two named methods (Go examples included)

---

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-001b: Coding guideline conformance: File And Function Rules

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
