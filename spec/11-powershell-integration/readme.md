# PowerShell Integration — Index

> **Updated:** 2026-03-26

---

## Specifications

| File | Description |
|------|-------------|
| [00-overview.md](./00-overview.md) | Overview of PowerShell runner (`run.ps1`) |
| [01-configuration-schema.md](./01-configuration-schema.md) | Configuration schema for `powershell.json` |
| [01-template-vs-project-differences.md](./01-template-vs-project-differences.md) | Template vs project configuration differences |
| [02-script-reference.md](./02-script-reference.md) | Script reference and CLI flags |
| [03-integration-guide.md](./03-integration-guide.md) | Integration guide for Go+React projects |
| [04-error-codes.md](./04-error-codes.md) | Error codes reference |
| [05-firewall-rules.md](./05-firewall-rules.md) | Firewall rules for remote connectivity |
| [06-php-known-issues.md](./06-php-known-issues.md) | Known PHP issues and workarounds |
| [25-multi-site-deployment.md](./25-multi-site-deployment.md) | Multi-site deployment strategy |
| [changelog.md](./changelog.md) | PowerShell integration changelog |
| [parallel-work-sync-output.md](./parallel-work-sync-output.md) | Parallel work sync output specification |

## Supporting Files

| File | Description |
|------|-------------|
| [schemas/powershell.schema.json](./schemas/powershell.schema.json) | JSON Schema for `powershell.json` |
| [templates/powershell.json](./templates/powershell.json) | Template `powershell.json` |
| [templates/run.ps1](./templates/run.ps1) | Template `run.ps1` entry point |
| [examples/server-client-project.json](./examples/server-client-project.json) | Example server-client project configuration |

---

## Verification

_Auto-generated section — see `spec/11-powershell-integration/97-acceptance-criteria.md` for the full criteria index._

### AC-PS-523: Conformance check for this PowerShell integration rule

**Given** Invoke the Pester suite.  
**When** Run the verification command shown below.  
**Then** Pester exits 0 with FailedCount=0; `Invoke-ScriptAnalyzer -Severity Error` returns zero diagnostics on every shipped `.ps1`.

**Verification command:**

```bash
pwsh -Command 'Invoke-Pester tests/powershell/ -CI'
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
