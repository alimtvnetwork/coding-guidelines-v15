# SARIF 2.1.0 Output Contract

> **Version:** 1.0.0
> **Updated:** 2026-04-19

Every check script in `linters-cicd/checks/` MUST emit SARIF 2.1.0
conforming to this contract when run with `--format sarif`.

---

## Top-level shape

```json
{
  "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
  "version": "2.1.0",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "coding-guidelines-<check-id>",
          "version": "1.0.0",
          "informationUri": "https://github.com/alimtvnetwork/coding-guidelines-v15",
          "rules": [
            {
              "id": "CODE-RED-001",
              "name": "NoNestedIf",
              "shortDescription": { "text": "Nested if statements are forbidden" },
              "helpUri": "https://github.com/alimtvnetwork/coding-guidelines-v15/blob/main/spec/02-coding-guidelines/01-cross-language/04-code-style/00-overview.md"
            }
          ]
        }
      },
      "results": [
        {
          "ruleId": "CODE-RED-001",
          "level": "error",
          "message": { "text": "Nested if at depth 3 — extract guard clauses." },
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": { "uri": "src/payments/charge.ts" },
                "region": { "startLine": 42, "startColumn": 5 }
              }
            }
          ]
        }
      ]
    }
  ]
}
```

---

## Required fields per result

| Field | Required | Notes |
|-------|----------|-------|
| `ruleId` | ✅ | `CODE-RED-NNN` from `06-rules-mapping.md` |
| `level` | ✅ | `error` for CODE RED, `warning` for STYLE |
| `message.text` | ✅ | Human sentence ending in a period |
| `locations[].physicalLocation.artifactLocation.uri` | ✅ | Path **relative** to the scanned root |
| `locations[].physicalLocation.region.startLine` | ✅ | 1-indexed |
| `locations[].physicalLocation.region.startColumn` | ⚠️ | Optional but recommended |

---

## Severity mapping

| Spec severity | SARIF `level` | CI behavior |
|---------------|---------------|-------------|
| 🔴 CODE RED | `error` | Block merge |
| 🟡 STYLE | `warning` | Annotate, do not block |
| ℹ️ INFO | `note` | Surface in report only |

---

## Merging multiple check outputs

`run-all.sh` calls each check, then merges outputs into a single SARIF
file with one `runs[]` entry per tool. Consumers pick this single file
up via `upload-sarif` (GitHub) or `Code Quality: sarif` (GitLab via
sarif-to-codequality converter).

---

## Validation

The `linters-cicd/scripts/validate-sarif.py` script validates every
emitted file against the official SARIF 2.1.0 schema. CI runs this on
every PR to the linter pack itself.

---

*Part of [CI/CD Integration](./00-overview.md)*

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-001a: Coding guideline conformance: Sarif Contract

**Given** Run the cross-language coding-guidelines validator against `src/` and language-specific source roots.  
**When** Run the verification command shown below.  
**Then** Zero CODE-RED violations are reported (functions ≤ 15 lines, files ≤ 300 lines, no nested ifs, max 2 boolean operands).

**Verification command:**

```bash
go run linter-scripts/validate-guidelines.go --path spec --max-lines 15 && python3 linter-scripts/validate-guidelines.py spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
