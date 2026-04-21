# Null Pointer Safety

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**Applies to:** Go (primary), general principle cross-language  
**Source:** Consolidated from `01-pre-code-review-guides/03-golang-code-review-guides.md`

---

## 1. Principle

**Never access a pointer, array, or return value without checking for nil/null first.** Every pointer dereference is a potential panic/crash.

---

## 2. Rules

### Rule 1: Check Error Before Value

Always check `err` before using the returned value:

```go
// ❌ WRONG — checks value before error
cmd, err := exec.Command(args...)
if cmd != nil {
    // DANGEROUS — err might be non-nil
}

// ✅ CORRECT — error first
cmd, err := exec.Command(args...)
if err != nil {
    return exitResult
}

if cmd == nil {
    return exitResult
}

// safe to use cmd
output := cmd.Output()
```

### Rule 2: Never Call Methods on Unchecked Return Values

```go
// ❌ DANGEROUS — Output() called directly, will panic if command fails
output, err := exec.Command(args...).Output()

// ✅ SAFE — separate creation from execution
cmd, err := exec.Command(args...)
if err != nil || cmd == nil {
    return exitResult
}

output := cmd.Output()
```

### Rule 3: Check Pointer Before Dereference

```go
// ❌ WRONG — dereference without nil check
anyPtr := getPointerBytes()
data := *anyPtr  // PANIC if nil

// ✅ CORRECT — nil check first
anyPtr := getPointerBytes()
if anyPtr == nil {
    return exitResult
}

data := *anyPtr
```

### Rule 4: Check Array/Slice Before Index Access

```go
// ❌ WRONG — index access without nil/empty check
anyBytes := getBytes()
first := anyBytes[0]  // PANIC if nil or empty

// ✅ CORRECT — guard first
anyBytes := getBytes()
if anyBytes == nil || len(anyBytes) == 0 {
    return exitResult
}

first := anyBytes[0]
```

### Rule 5: Safe Pointer Returns

```go
// ❌ DANGEROUS — returning pointer of potentially nil value
func anyBytesRiskyPtr() *[]byte {
    anyBytes := getBytes()

    return &anyBytes  // dangerous if anyBytes is nil
}

// ✅ SAFE — nil check before pointer creation
func anyBytesSafePtr() *[]byte {
    anyBytes := getBytes()

    if anyBytes == nil {
        return nil
    }

    return &anyBytes
}
```

---

## 3. Cross-Language Guards

| Language | Null Check | Guard Pattern |
|----------|-----------|---------------|
| Go | `if x == nil` | `if x.IsDefined()` (preferred) |
| PHP | `if ($x === null)` | `if ($x->isDefined())` (preferred) |
| TypeScript | `if (x === null \|\| x === undefined)` | `if (isDefined(x))` (preferred) |

See [Master Coding Guidelines §3.1](./15-master-coding-guidelines/00-overview.md) for the full `isDefined`/`isDefinedAndValid` guard pattern.

---

## 4. Cross-References

- [Boolean Principles](./02-boolean-principles/00-overview.md) — Positive null guards (`isDefined`)
- [Master Coding Guidelines §3.1](./15-master-coding-guidelines/00-overview.md) — Guard table
- [Casting Elimination Patterns](./03-casting-elimination-patterns.md) — Type-safe access

---

*Null pointer safety — consolidated from pre-code review guides.*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-019b: Conformance check for this coding guideline section

**Given** Run the Code-Red metrics validator against the project sources.  
**When** Run the verification command shown below.  
**Then** Zero violations of the rules in this section. Functions ≤15 lines, files <300 lines, components <100 lines, no nested `if`.

**Verification command:**

```bash
python3 linter-scripts/validate-guidelines.py spec || python3 linter-scripts/check-forbidden-strings.py
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
