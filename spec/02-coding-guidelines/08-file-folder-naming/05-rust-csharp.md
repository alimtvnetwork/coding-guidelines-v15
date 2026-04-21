# File & Folder Naming — Rust / C#

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Rust

### File Naming — `snake_case.rs`

```
✅ http_client.rs
✅ error_handling.rs
✅ mod.rs
❌ httpClient.rs
❌ http-client.rs
❌ HttpClient.rs
```

### Folder Naming — `snake_case/`

```
✅ src/error_handling/
✅ src/http_client/
❌ src/error-handling/
❌ src/ErrorHandling/
```

### Standard Layout

```
my-crate/                        ← kebab-case crate name
├── src/
│   ├── main.rs                  ← binary entry
│   ├── lib.rs                   ← library entry
│   ├── error_handling/
│   │   ├── mod.rs               ← module root
│   │   └── custom_errors.rs
│   └── http_client/
│       ├── mod.rs
│       └── request_builder.rs
├── tests/
│   └── integration_test.rs
├── benches/
│   └── benchmark.rs
├── Cargo.toml
└── Cargo.lock
```

### Rust-Specific Rules

| Rule | Convention |
|------|-----------|
| Module files | `mod.rs` or `{module_name}.rs` |
| Test files | `tests/` folder or inline `#[cfg(test)]` |
| Crate name | `kebab-case` in Cargo.toml, `snake_case` in code |
| Macros | `snake_case!` |

---

## C#

### File Naming — `PascalCase.cs`

```
✅ UserService.cs
✅ HttpClientFactory.cs
✅ IUserRepository.cs            ← interfaces prefixed with I
❌ userService.cs
❌ user-service.cs
❌ user_service.cs
```

### Folder Naming — `PascalCase/`

C# is the **only language** that uses PascalCase folders:

```
✅ Models/
✅ Services/
✅ Controllers/
❌ models/
❌ services/
```

### Standard Layout

```
MyProject/                       ← PascalCase
├── MyProject.sln
├── src/
│   └── MyProject.Api/
│       ├── Controllers/
│       │   └── UserController.cs
│       ├── Models/
│       │   └── UserModel.cs
│       ├── Services/
│       │   ├── IUserService.cs
│       │   └── UserService.cs
│       └── Program.cs
└── tests/
    └── MyProject.Tests/
        └── UserServiceTests.cs
```

### C#-Specific Rules

| Rule | Convention |
|------|-----------|
| Interfaces | `I` prefix: `IUserService.cs` |
| Abstract classes | No special prefix |
| Test projects | `{Project}.Tests/` |
| One class per file | File name matches class name |

---

## Forbidden Patterns

| Language | Pattern | Why |
|----------|---------|-----|
| Rust | `camelCase.rs` | Violates Rust conventions |
| Rust | `kebab-case/` folders | Rust modules use `snake_case` |
| C# | `snake_case.cs` | Violates .NET conventions |
| C# | `lowercase/` folders | .NET uses PascalCase directories |

---

## Cross-References

| Reference | Location |
|-----------|----------|
| Rust Standards | [../05-rust/00-overview.md](../05-rust/00-overview.md) |
| C# Standards | [../07-csharp/00-overview.md](../07-csharp/00-overview.md) |
| Cross-Language Rules | [./01-cross-language.md](./01-cross-language.md) |

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-005b: Conformance check for this coding guideline section

**Given** Run the Code-Red metrics validator against the project sources.  
**When** Run the verification command shown below.  
**Then** Zero violations of the rules in this section. Functions ≤15 lines, files <300 lines, components <100 lines, no nested `if`.

**Verification command:**

```bash
python3 linter-scripts/validate-guidelines.py spec || python3 linter-scripts/check-forbidden-strings.py
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
