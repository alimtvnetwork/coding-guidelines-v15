# Envelope Parsing & Enrichment

> **Parent:** [Error Modal Reference](./00-overview.md)  
> **Version:** 2.2.0  
> **Updated:** 2026-03-31

---

The Universal Response Envelope provides six top-level blocks. The error modal consumes three of them for diagnostics:

## Errors Block → Backend Section (Overview + Stack tabs)

```json
{
  "Errors": {
    "BackendMessage": "Failed to fetch plugin details from remote site",
    "DelegatedServiceErrorStack": [
      "PHP Fatal error: Class 'PDO' not found in plugin-manager.php on line 42",
      "#0 endpoints.php(15): PluginManager->connect()",
      "#1 {main}"
    ],
    "Backend": [
      "site_handlers.go:327 handlers.EnableRemotePlugin",
      "service.go:1245 site.(*Service).EnableRemotePlugin"
    ],
    "Frontend": [],
    "DelegatedRequestServer": {
      "DelegatedEndpoint": "https://example.com/wp-json/riseup.../v1/snapshots/settings",
      "Method": "GET",
      "StatusCode": 403,
      "RequestBody": null,
      "Response": {
        "code": "rest_forbidden",
        "message": "This endpoint is disabled",
        "data": { "status": 403, "plugin_version": "1.54.0" }
      },
      "StackTrace": [
        "#0 riseup-asia-uploader.php(1098): FileLogger->error()",
        "#1 class-wp-hook.php(341): Plugin->enrichErrorResponse()"
      ],
      "AdditionalMessages": "Endpoint 'snapshots' is not enabled in plugin settings."
    }
  }
}
```

**Mapping:**
- `BackendMessage` → Overview tab red banner
- `DelegatedServiceErrorStack` → Stack tab (orange-themed PHP trace) + Traversal tab (legacy)
- `DelegatedRequestServer` → Stack tab (purple-themed delegated section) + Request tab (3rd hop) + Traversal tab (NEW v2.0.0)
- `DelegatedRequestServer.AdditionalMessages` → Overview tab info banner
- `DelegatedRequestServer.Response` → Request tab delegated response JSON viewer
- `DelegatedRequestServer.StackTrace` → Stack tab delegated server stack trace
- `Backend` → Stack tab (Go trace)

---

## MethodsStack Block → Execution + Traversal tabs

```json
{
  "MethodsStack": {
    "Backend": [
      { "Method": "handlers.EnableRemotePlugin", "File": "site_handlers.go", "LineNumber": 327 },
      { "Method": "site.(*Service).EnableRemotePlugin", "File": "service.go", "LineNumber": 1245 },
      { "Method": "wordpress.(*Client).doRequest", "File": "uploader.go", "LineNumber": 350 }
    ],
    "Frontend": []
  }
}
```

**Mapping:** Rendered as a sortable table with `#`, `Method`, `File`, `Line` columns.

---

## Attributes Block → Session ID propagation

```json
{
  "Attributes": {
    "RequestedAt": "http://localhost:8080/api/v1/plugins/enable",
    "RequestDelegatedAt": "https://example.com/wp-json/riseup-asia-uploader/v1/enable",
    "SessionId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "HasAnyErrors": true
  }
}
```

**Mapping:**
- `RequestedAt` + `RequestDelegatedAt` → Traversal tab endpoint flow
- `SessionId` → Session tab auto-fetch trigger

---

*Envelope parsing — updated: 2026-03-31*

---

## Verification

_Auto-generated section — see `spec/03-error-manage/97-acceptance-criteria.md` for the full criteria index._

### AC-ERR-003d: Conformance check for this error-management rule

**Given** Run the error-handling linter against the codebase.  
**When** Run the verification command shown below.  
**Then** Zero empty `catch {}` blocks; every `apperror.New(...)` call carries a file/path context; all `Err*` identifiers are PascalCase.

**Verification command:**

```bash
grep -rnE 'catch[[:space:]]*\([^)]*\)[[:space:]]*\{[[:space:]]*\}' src/ ; test $? -eq 1
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
