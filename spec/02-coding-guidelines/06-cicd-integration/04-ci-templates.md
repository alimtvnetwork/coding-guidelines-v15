# CI Templates Inventory

> **Version:** 1.0.0
> **Updated:** 2026-04-19

Ready-to-paste workflow files per CI platform. All call the same
`linters-cicd/run-all.sh` and consume the same SARIF output, so behavior
is identical across platforms.

---

## Shipped templates

| Platform | File | Findings surface as |
|----------|------|---------------------|
| GitHub Actions | `linters-cicd/ci/github-actions.yml` | Code Scanning (Security tab) + PR annotations |
| GitHub composite | `linters-cicd/action.yml` | Same as above, one-liner via `uses:` |
| GitLab CI | `linters-cicd/ci/gitlab-ci.yml` | Code Quality MR widget + SAST report |
| Azure DevOps | `linters-cicd/ci/azure-pipelines.yml` | SARIF SAST extension |
| Bitbucket Pipelines | `linters-cicd/ci/bitbucket-pipelines.yml` | Pipeline log + report artifact |
| Jenkins | `linters-cicd/ci/Jenkinsfile` | Warnings-NG plugin |
| Pre-commit hook | `linters-cicd/ci/pre-commit-hook.sh` | Local block before push |

---

## Other platforms (CircleCI, TeamCity, Drone, …)

Not shipped as templates. Users wire them themselves using the contract:

```bash
# 1. Install
curl -fsSL https://github.com/alimtvnetwork/coding-guidelines-v15/releases/latest/download/install.sh | bash

# 2. Run
./linters-cicd/run-all.sh --path . --format sarif --output coding-guidelines.sarif

# 3. Upload artifact + fail build on exit code 1
```

---

## GitHub composite Action — usage

```yaml
- uses: alimtvnetwork/coding-guidelines-v15/linters-cicd@v3.9.0
  with:
    path: .
    languages: go,typescript     # optional, default: auto-detect
    severity: error              # optional, default: error
    fail-on-warning: false       # optional, default: false
```

---

*Part of [CI/CD Integration](./00-overview.md)*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-004a: Coding guideline conformance: Ci Templates

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
