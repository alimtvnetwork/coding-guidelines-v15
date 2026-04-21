# Master Coding Guidelines

> ⚠️ **This file has been split into a subfolder.** See [15-master-coding-guidelines/00-overview.md](./15-master-coding-guidelines/00-overview.md)

All content now lives in [`15-master-coding-guidelines/`](./15-master-coding-guidelines/).

---

## Verification

_Auto-generated section — see `spec/02-coding-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CG-015b: Conformance check for this coding guideline section

**Given** Run the Code-Red metrics validator against the project sources.  
**When** Run the verification command shown below.  
**Then** Zero violations of the rules in this section. Functions ≤15 lines, files <300 lines, components <100 lines, no nested `if`.

**Verification command:**

```bash
python3 linter-scripts/validate-guidelines.py spec || python3 linter-scripts/check-forbidden-strings.py
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
