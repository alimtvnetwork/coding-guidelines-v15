# Spec Cross-Link Checker

`check-spec-cross-links.py` walks `spec/`, parses every markdown link, and
fails CI if any internal link points to a missing file or a non-existent
heading anchor.

## Local run

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
# Optional: JSON report
python3 linter-scripts/check-spec-cross-links.py --root spec --json
# Optional: GitHub annotations
python3 linter-scripts/check-spec-cross-links.py --root spec --github
```

## Exit codes

| Code | Meaning |
|------|---------|
| 0    | All internal links resolve |
| 1    | One or more broken links / missing sections |
| 2    | Invocation error |

## What is checked

- Markdown links of the form `[text](path)` and `[text](path#anchor)`.
- Path must resolve to an existing file (relative to source `.md`, or absolute from repo root).
- If `#anchor` is present, it must match an existing H1–H6 heading slug in the target file.
- Links inside fenced code blocks (```` ``` ```` or `~~~`) are ignored — they are examples, not real references.
- External URLs (`http://`, `https://`, `mailto:`, etc.) and project schemes (`mem://`, `user-uploads://`, `knowledge://`) are skipped.

## Allowlist (waivers)

Known-broken links live in `linter-scripts/spec-cross-links.allowlist`,
one waiver per line:

```
# Comments start with `#` (only at line start; anchor `#` inside entries is preserved)
spec/path/to/file.md:42:./missing-target.md
spec/other.md:99:./file.md#missing-section
```

Format: `<relpath-from-repo-root>:<line>:<exact-target-as-written>`.
Remove a waiver as soon as the underlying link is fixed.

## CI

Runs as the `cross-links` job in `.github/workflows/ci.yml` on every push
and pull request to `main`.
