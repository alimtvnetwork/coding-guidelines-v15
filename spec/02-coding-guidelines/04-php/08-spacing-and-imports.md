# PHP Spacing and Import Rules

**Version:** 3.2.0  
**Updated:** 2026-04-16  
**Applies to:** All PHP files in the `RiseupAsia` namespace  
**Source:** Consolidated from `04-coding-guidelines-wpon/07-php-standards/php-spacing-and-imports.md`

---

## Rule 1: Blank Line Before `if` When Preceded by Statements

When an `if` block is preceded by one or more statements, insert one blank line before the `if`.

**Exception:** No blank line when `if` is the first statement in a function body, or immediately follows another `}`.

```php
// ❌ WRONG — no blank line between statement and if
$existingRunning = $this->findRunningProcess();
if ($existingRunning !== null) {
    Logger::warning('Scan already running', array('existingId' => $existingRunning->id));

    throw new RuntimeException('A scan is already in progress', 14100);
}

// ✅ CORRECT — blank line separates setup from decision
$existingRunning = $this->findRunningProcess();

if ($existingRunning !== null) {
    Logger::warning('Scan already running', array('existingId' => $existingRunning->id));

    throw new RuntimeException('A scan is already in progress', 14100);
}
```

---

## Rule 2: Blank Line Before `throw` When Preceded by Statements

Same as `return`: if a `throw` is preceded by one or more statements in the same block, insert one blank line before it.

```php
// ❌ WRONG
if ($existingRunning !== null) {
    Logger::warning('Scan already running', array('existingId' => $existingRunning->id));
    throw new RuntimeException('A scan is already in progress', 14100);
}

// ✅ CORRECT
if ($existingRunning !== null) {
    Logger::warning('Scan already running', array('existingId' => $existingRunning->id));

    throw new RuntimeException('A scan is already in progress', 14100);
}
```

---

## Rule 3: No Leading Backslash — Use `use` Import

In namespaced PHP files, **never** reference global types with a leading backslash. Add a `use` import at the top instead.

```php
// ❌ WRONG — leading backslash
throw new \RuntimeException('...');
catch (\Throwable $e) { ... }

// ✅ CORRECT — use import at file top
use RuntimeException;
use Throwable;

throw new RuntimeException('...');
catch (Throwable $e) { ... }
```

**Exemptions:**
- `Autoloader.php` — must be self-contained
- Main plugin bootstrap file — may use backslash before autoloader is registered

---

## Rule 4: Reusable Log Context Keys Must Use Enums

Log context keys follow camelCase. But reusable keys appearing in 3+ log calls across different files must use `ResponseKeyType` enum.

```php
// ❌ WRONG — 'existingId' used in 5+ files as raw string
Logger::warning('Scan running', array('existingId' => $id));

// ✅ CORRECT — enum for reusable key
Logger::warning('Scan running', array(ResponseKeyType::ExistingId->value => $id));
```

---

## Combined Example — All Rules

```php
// ❌ WRONG — four violations
$existingRunning = $this->findRunningProcess();
if ($existingRunning !== null) {
    Logger::warning('Scan already running', ['existing_id' => $existingRunning->id]);
    throw new \RuntimeException('A scan is already in progress', 14100);
}

// ✅ CORRECT — all rules applied
$existingRunning = $this->findRunningProcess();

if ($existingRunning !== null) {
    Logger::warning('Scan already running', array('existingId' => $existingRunning->id));

    throw new RuntimeException('A scan is already in progress', 14100);
}
```

---

## Cross-References

- [Code Style](../01-cross-language/04-code-style/00-overview.md) — Rules R4, R5, R10
- [PHP Naming Conventions](./03-naming-conventions.md) — Array key casing
- [PHP Forbidden Patterns](./02-forbidden-patterns.md) — Banned patterns

---

*PHP spacing and import rules — consolidated from WPOnboard coding guidelines.*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-008a: Coding guideline conformance: Spacing And Imports

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
