# Boolean Principles — P1: is/has prefixes, P2: no negative words

> **Parent:** [Boolean Principles](./00-overview.md)  
> **Version:** 2.6.0  
> **Updated:** 2026-03-31

---

## Principle 1: Always Use `is` or `has` Prefixes

Every boolean identifier — variable, property, parameter, or method — **must** start with `is` or `has`.

```php
// ── PHP ──────────────────────────────────────────────────────

// ❌ FORBIDDEN
$active = true;
$loaded = false;
$blocked = true;

// ✅ REQUIRED
$isActive = true;
$isLoaded = false;
$isBlocked = true;
$hasPermission = true;
```

```typescript
// ── TypeScript ───────────────────────────────────────────────

// ❌ FORBIDDEN
const loading = true;
const valid = false;
const overdue = checkOverdue();

// ✅ REQUIRED
const isLoading = true;
const isValid = false;
const hasOverdue = checkOverdue();
```

```go
// ── Go ───────────────────────────────────────────────────────

// ❌ FORBIDDEN
blocked := true
connected := false

// ✅ REQUIRED
isBlocked := true
isConnected := false
hasItems := len(items) > 0
```

### Method Names Follow the Same Rule

```php
// ❌ FORBIDDEN
$order->overdue();
$user->admin();

// ✅ REQUIRED
$order->hasOverdue();
$user->isAdmin();
```

This mirrors industry best practices. For example, .NET's `char` type exposes `IsLetter`, `IsDigit`, `IsUpper`, `IsLower`, `IsNumber`, `IsPunctuation`, `IsSeparator`, `IsSymbol`, `IsControl`, `IsLetterOrDigit` — all boolean methods with the `Is` prefix.

---


---

## Principle 2: Never Use Negative Words in Boolean Names

The words **`not`**, **`no`**, and **`non`** are **absolutely banned** from boolean variable names, function names, and method names. These words create cognitive overhead — the reader must mentally invert the meaning. Instead, always use a **positive semantic synonym** that describes what the state actually **is**.

Double negatives (`!isNot...`, `!isNotBlocked`) are the worst form and must never appear.

### Naming Strategy: Describe What It IS, Not What It ISN'T

| ❌ Forbidden Name | ✅ Required Name | Semantic Meaning |
|---|---|---|
| `isNotReady` | `isPending` | The order is waiting |
| `isNotInList` | `isAbsentFromList` | The item is absent |
| `isNoRecentErrors` | `isErrorListClear` | The error list is clean |
| `isNotDirectory` | `isDirAbsent` | The directory doesn't exist |
| `isNotRegularFile` | `isIrregularPath` | The path is irregular |
| `isNotPHP` | `isSkippableEntry` | The entry should be skipped |
| `isNotBlocked` | `isActive` | The entity is active |
| `isClassNotLoaded` | `isClassUnregistered` | The class is unregistered |
| `hasNoPermission` | `isUnauthorized` | The user lacks access |

```typescript
// ❌ FORBIDDEN — "not" in the variable name
const isNotReady = order.status !== 'ready';
if (isNotReady) {
    throw new Error('Order is not ready');
}

// ✅ REQUIRED — Positive semantic synonym
const isPending = order.status !== 'ready';
if (isPending) {
    throw new Error('Order is not ready');
}
```

```php
// ❌ FORBIDDEN — "No" in the variable name
$isNoRecentErrors = empty($errors) || !$hasUnseen;

// ✅ REQUIRED — Describes the positive state
$isErrorListClear = empty($errors) || !$hasUnseen;
```

### Rule: Name booleans for the **positive semantic state**, then negate only once if needed

```typescript
// ❌ AVOID — Raw negation at call site
if (!isBlocked) {
    // active
}

// ✅ BEST — Extract to a positive boolean
const isActive = !isBlocked;

if (isActive) {
    // best to use like this
}
```

---

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-001b: Coding guideline conformance: Naming Prefixes

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
