# Regex Usage Guidelines

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**Applies to:** Go (primary), general principle cross-language  
**Source:** Consolidated from `01-pre-code-review-guides/03-golang-code-review-guides.md`

---

## 1. Principle

Regex uses backtracking and is **extremely expensive**. It should be the **last resort** for pattern matching in strings.

---

## 2. When NOT to Use Regex

| Task | Use Instead |
|------|-------------|
| Searching for dots, commas, or delimiters | `strings.Split()`, `strings.Contains()` |
| Searching for specific text in a line | `strings.Contains()`, `strings.HasPrefix()` |
| Checking if a line starts/ends with a value | `strings.HasPrefix()`, `strings.HasSuffix()` |
| Finding a number in a line | Extract the known part first, then parse the dynamic part |
| Simple string replacement | `strings.Replace()`, `strings.ReplaceAll()` |

---

## 3. When to Use Regex

| Task | Why Regex is Justified |
|------|------------------------|
| Dynamic text with variable patterns | No static alternative exists |
| Code or syntax parsing | Complex grammar matching |
| Ignoring whitespace while finding matches | Regex whitespace classes |
| Avoiding O(n³) nested loop searches | Regex is cheaper than triple nesting |

---

## 4. Go-Specific Rules

### Rule 1: Compile Regex in `var` (Package Level)

```go
// ✅ CORRECT — compiled once at package init
var reEmail = regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)

func IsValidEmail(email string) bool {
    return reEmail.MatchString(email)
}
```

```go
// ❌ WRONG — compiled on every call
func IsValidEmail(email string) bool {
    re := regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)

    return re.MatchString(email)
}
```

### Rule 2: Add Sample Data as Comment

```go
// reIpAddress matches IPv4 addresses
// Examples: "192.168.1.1", "10.0.0.1", "255.255.255.0"
var reIpAddress = regexp.MustCompile(`\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b`)
```

### Rule 3: Never Use Regex in Loops Without Reviewer Approval

If regex must run in a loop or high-frequency function, verify with your mentor or reviewer **before** writing the code. Don't write it and get rejection.

### Rule 4: Benchmark-Driven

Moving regex from inside a function to a package-level `var` can yield significant performance improvements. See [Go Tooling in Action — Benchmark Improvement](https://youtu.be/uBjoTxosSys?t=1451).

---

## 5. Cross-Language Applicability

| Language | Compilation | Recommendation |
|----------|-------------|----------------|
| Go | `regexp.MustCompile()` in `var` | Mandatory |
| TypeScript | `new RegExp()` or `/pattern/` literal | Use literals for static; `new RegExp()` only for dynamic |
| PHP | `preg_match()` | Cache compiled patterns if reused |

---

## 6. Cross-References

- [Code Style](./04-code-style/00-overview.md) — Performance considerations
- [Master Coding Guidelines](./15-master-coding-guidelines/00-overview.md) — §8 Magic Strings (regex patterns are not magic strings)

---

*Regex usage guidelines — consolidated from pre-code review guides.*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-017b: Conformance check for this coding guideline section

**Given** Run the Code-Red metrics validator against the project sources.  
**When** Run the verification command shown below.  
**Then** Zero violations of the rules in this section. Functions ≤15 lines, files <300 lines, components <100 lines, no nested `if`.

**Verification command:**

```bash
python3 linter-scripts/validate-guidelines.py spec || python3 linter-scripts/check-forbidden-strings.py
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
