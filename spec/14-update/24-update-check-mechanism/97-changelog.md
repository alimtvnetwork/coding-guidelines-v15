# Changelog — Update Check Mechanism

> **Parent:** [00-overview.md](./00-overview.md)

---

## v1.0.0 — 2026-04-20

**Initial spec.** Defines the non-blocking, parallel, status-script-driven
update-check mechanism for every CLI in the stack.

### Files added

* `00-overview.md` — Index, defining properties, resolved decisions
* `01-fundamentals.md` — V → V+5 parallel discovery algorithm
* `02-status-script-json.md` — `Status.ps1` / `Status.sh` output schema
* `03-combined-json.md` — Combined discovery JSON
* `04-database-schema.md` — `UpdateChecker` + `UpdateStatus` tables
* `05-update-checker-service.md` — Reusable service contract
* `06-cli-commands.md` — `update-check` and `do-update`
* `07-pre-command-hook.md` — Pre/post hooks, interval gate, warning
* `08-error-handling.md` — Try/catch policy, log file, error column
* `09-json-fallback-store.md` — JSON storage when no DB exists
* `97-acceptance-criteria.md` — 34-point acceptance matrix
* `97-changelog.md` — This file
* `99-consistency-report.md` — Cross-spec coherence audit

### Decisions resolved (no ambiguity remains)

1. No walking past V+5 — all six probes fire at once.
2. `do-update` runs unattended; trailing warning is the consent.
3. JSON fallback path: `~/.<CliName>/data/UpdateChecker.json`.
4. `--force` flag bypasses the interval gate.
5. Pre-hook opt-out via `BackgroundUpdateCheckEnabled`.
6. Newer-repo detection via `repo-v{N+1..N+5}` probes + `NewRepoUrl`.
7. `--persist` flag removed — both sync and `--async` persist.

---

*Changelog — 2026-04-20*

---

## Verification

_Auto-generated section — see `spec/14-update/97-acceptance-criteria.md` for the full criteria index._

### AC-UPD-097a: Self-update conformance: Changelog

**Given** Exercise the rename-first deploy path against a fixture release directory.  
**When** Run the verification command shown below.  
**Then** `latest.json` is written atomically; the old binary is renamed (not deleted) before the new one is moved into place; rollback restores the previous version.

**Verification command:**

```bash
python3 linter-scripts/check-spec-cross-links.py --root spec
```

**Expected:** exit 0. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-21_
