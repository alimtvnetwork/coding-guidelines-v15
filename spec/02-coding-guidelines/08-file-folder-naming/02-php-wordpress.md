# File & Folder Naming — PHP / WordPress

**Version:** 3.2.0  
**Updated:** 2026-04-16

---

## Overview

WordPress has specific file naming conventions enforced by the plugin/theme loader and WordPress Coding Standards (WPCS). These are **mandatory** for any WordPress project.

---

## File Naming Rules

### 1. General PHP Files — `kebab-case.php`

```
✅ admin-settings.php
✅ api-handler.php
✅ template-loader.php
❌ adminSettings.php
❌ admin_settings.php
❌ AdminSettings.php
```

### 2. Class Files — `class-{name}.php`

WordPress convention: class files MUST be prefixed with `class-`.

```
✅ class-admin-settings.php
✅ class-api-client.php
✅ class-plugin-loader.php
❌ AdminSettings.php
❌ admin-settings-class.php
```

**The class name inside follows PascalCase:**

```php
// File: class-admin-settings.php
class Admin_Settings {
    // WordPress uses underscores in class names
}
```

### 3. Interface Files — `interface-{name}.php`

```
✅ interface-cacheable.php
✅ interface-renderable.php
```

### 4. Trait Files — `trait-{name}.php`

```
✅ trait-singleton.php
✅ trait-api-methods.php
```

### 5. Template Files

WordPress template hierarchy files use specific names:

```
✅ single.php
✅ page-about.php
✅ taxonomy-portfolio.php
✅ template-full-width.php
```

### 6. WordPress Required Files

These filenames are **mandatory** and case-sensitive:

| File | Location | Purpose |
|------|----------|---------|
| `functions.php` | Theme root | Theme functions |
| `style.css` | Theme root | Theme metadata |
| `index.php` | Theme/plugin root | Fallback template |
| `uninstall.php` | Plugin root | Cleanup on uninstall |
| `{plugin-slug}.php` | Plugin root | Main plugin file |

---

## Folder Naming Rules

### WordPress Plugin Structure

```
my-awesome-plugin/               ← kebab-case plugin slug
├── my-awesome-plugin.php        ← Main file matches folder name
├── uninstall.php
├── includes/                    ← lowercase
│   ├── class-plugin-loader.php
│   ├── class-admin-settings.php
│   └── class-api-client.php
├── admin/                       ← lowercase
│   ├── css/
│   ├── js/
│   └── views/
├── public/                      ← lowercase
│   ├── css/
│   ├── js/
│   └── views/
├── languages/                   ← lowercase
│   └── my-awesome-plugin.pot
├── templates/                   ← lowercase
│   └── single-portfolio.php
└── tests/                       ← lowercase
    └── test-admin-settings.php
```

### Key Folder Rules

| Rule | Convention |
|------|-----------|
| Plugin root folder | `kebab-case` matching the plugin slug |
| All subfolders | Lowercase, no hyphens preferred (`includes/`, `admin/`, `public/`) |
| Asset folders | `css/`, `js/`, `images/`, `fonts/` |
| No nested class folders | Keep classes flat in `includes/` |

---

## Forbidden Patterns

| Pattern | Why |
|---------|-----|
| `camelCase.php` | Violates WordPress Coding Standards |
| `snake_case.php` | Not WordPress convention (use kebab-case) |
| `PascalCase.php` | Reserved for PSR-4 autoloading (not WordPress convention) |
| `CLASS-name.php` | Prefix must be lowercase `class-` |
| Uppercase folders | `Includes/`, `Admin/` — always lowercase |

---

## Cross-References

| Reference | Location |
|-----------|----------|
| PHP Standards | [../04-php/00-overview.md](../04-php/00-overview.md) |
| Cross-Language Rules | [./01-cross-language.md](./01-cross-language.md) |

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-002a: Coding guideline conformance: Php Wordpress

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
