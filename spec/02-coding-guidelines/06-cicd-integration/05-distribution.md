# Distribution

> **Version:** 1.0.0
> **Updated:** 2026-04-19

The linter pack ships **two ways**, both produced by the same release job
in `.github/workflows/release.yml`.

---

## 1. Versioned ZIP (universal)

Built into every GitHub Release as
`coding-guidelines-linters-vX.Y.Z.zip`. Contains:

```
linters-cicd/
├── checks/
├── ci/
├── configs/
├── action.yml
├── run-all.sh
├── install.sh
├── README.md
└── VERSION
```

Install one-liner (Linux / macOS):

```bash
curl -fsSL https://github.com/alimtvnetwork/coding-guidelines-v15/releases/latest/download/install.sh | bash
```

The installer:

1. Downloads the matching `coding-guidelines-linters-<latest>.zip`
2. Extracts to `./linters-cicd/`
3. Verifies SHA-256 against `checksums.txt`
4. Prints next-step commands

Flags:

- `-d <dir>` install destination (default: `./linters-cicd`)
- `-v <version>` install a specific version (default: latest)
- `-n` skip checksum verification (not recommended)

---

## 2. GitHub composite Action

`linters-cicd/action.yml` lets GitHub users skip the install entirely:

```yaml
- uses: alimtvnetwork/coding-guidelines-v15/linters-cicd@v3.9.0
```

GitHub clones the repo at the specified ref and runs `action.yml`. Zero
maintenance for consumers — just bump the version pin.

---

## Release pipeline integration

`.github/workflows/release.yml` runs on every `v*` tag and:

1. Zips `linters-cicd/` → `coding-guidelines-linters-vX.Y.Z.zip`
2. Computes SHA-256, appends to `checksums.txt`
3. Uploads as a Release asset alongside slides-app and core artifacts

---

*Part of [CI/CD Integration](./00-overview.md)*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-005a: Coding guideline conformance: Distribution

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
