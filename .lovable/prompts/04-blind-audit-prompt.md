# Blind-AI Audit Prompt

**Version:** 1.0.0
**Updated:** 2026-04-22
**Trigger phrases:** `blind audit` · `audit gap` · `gap audit` · `blind ai audit`
**Output cadence:** **Phase-by-phase** — execute one phase, list remaining phases + remaining items, then **WAIT** for the user to say `next` before proceeding.

---

## §1 Purpose

This prompt is the canonical, reusable instruction for performing a
**blind-AI implementability audit** on this repository — i.e., assess
whether a fresh AI agent given **only** `spec/17-consolidated-guidelines/`
could implement, modify, and validate the project end-to-end without
ever reading the source spec folders.

**Anchor reference files** (always read before drafting the new audit):

- `spec/17-consolidated-guidelines/25-blind-ai-implementability-audit.md` (v1)
- `spec/17-consolidated-guidelines/26-blind-ai-audit-v2.md` (v2)
- `spec/17-consolidated-guidelines/29-blind-ai-audit-v3.md` (v3 — latest at time of writing)

The next audit you produce becomes `vN+1` in this lineage. Bump the
filename suffix accordingly (e.g., `30-blind-ai-audit-v4.md`).

---

## §2 Hard Rules (DO NOT VIOLATE)

1. **Phase-by-phase execution.** Do exactly one phase per user turn. After
   the phase, print:
   - what you did (1–3 bullets)
   - remaining phases as a checklist
   - the literal sentence: *"Say `next` to continue, or describe a different next step."*
   Then STOP. Do not auto-continue.
2. **Empirical, not assumed.** Every score, count, and "✅" must be backed
   by a command you actually ran (cross-link checker, file count, grep,
   test invocation). If you can't verify a claim, mark it 🟡 with the
   reason "unverified" — never invent.
3. **Generic.** The prompt body uses no project-specific identifiers
   beyond what is already established in the lineage. The **audit you
   produce** is project-specific and verbatim.
4. **Numbered file convention.** New audit file is the next free integer
   in `spec/17-consolidated-guidelines/` (currently `30-`).
5. **Bump version.** After Phase 5 (publish), bump `package.json` minor,
   run `node scripts/sync-version.mjs` and `node scripts/sync-spec-tree.mjs`.
6. **Acceptance criteria block.** Append a `Verification` section with an
   `AC-CON-NN` block matching the file number, mirroring the structure
   used in `27-…md`, `28-…md`, `29-…md`.
7. **Never skip a phase** unless the user explicitly says "skip phase N".

---

## §3 Phase-by-Phase Workflow

### Phase 1 — Discover prior audits & repo state

Goal: anchor the new audit against the lineage and gather raw numbers.

**Actions:**

1. List existing audit files:
   `ls spec/17-consolidated-guidelines/ | grep -Ei 'audit|gap'`
2. Read the most recent audit's TL;DR table and §"Final Verdict".
3. Capture current empirical metrics in parallel:
   - `wc -l spec/17-consolidated-guidelines/*.md | tail -1`
   - `ls spec/17-consolidated-guidelines/*.md | wc -l`
   - `ls linter-scripts/*.{py,sh,go,cjs,mjs,ps1} 2>/dev/null | wc -l`
   - `grep -c '^\`\`\`' spec/17-consolidated-guidelines/*.md | awk -F: '{s+=$2} END{print s/2}'`
   - Current `package.json` version
4. Read `.lovable/memory/index.md` Core to surface any new rules added
   since the last audit (these are candidate gap sources).
5. Read `spec/17-consolidated-guidelines/24-folder-mapping.md` "Master
   Matrix" + "Known Blind-Spots" to enumerate every source folder's
   coverage status.

**Output:**

- A short table: `| Metric | Last audit | Now | Δ |`
- A short bulleted list of new memory Core rules since last audit
- Confirm the next audit file path (e.g., `30-blind-ai-audit-v4.md`)
- Stop and say: *"Say `next` to continue, or describe a different next step."*

---

### Phase 2 — Stress-test 8 common AI tasks (DRY-RUN)

Goal: empirically test whether the consolidated folder alone is
sufficient for the 8 canonical tasks. **Do not actually modify the repo
during this phase** — just trace whether each task is answerable from
the consolidated folder.

**Canonical 8 tasks** (do not change these — keep the lineage stable):

| # | Task |
|---|---|
| 1 | Build a React component using design tokens |
| 2 | Add a SQL table following naming rules |
| 3 | Add a new error code |
| 4 | Write a new linter rule |
| 5 | Modify an install script's probe behavior |
| 6 | Bump a dependency (especially axios) |
| 7 | Ship a release |
| 8 | Add a sibling-repo cross-reference |

For each task, answer with one of:

| Symbol | Meaning |
|---|---|
| ✅ | Fully answerable from `17-consolidated-guidelines/` alone — name the file + section |
| 🟡 | Partially answerable — name what's missing |
| 🔴 | Not answerable — name what's missing |

**Output:**

- The 8-row table
- A pass-rate summary `(✅ / 🟡 / 🔴)`
- Comparison to the previous audit's pass rate
- Stop and say: *"Say `next` to continue, or describe a different next step."*

---

### Phase 3 — Run all root-level validators

Goal: empirically prove the repo is in a clean state before scoring.

**Commands** (run in parallel where independent):

```bash
node scripts/sync-version.mjs
node scripts/sync-spec-tree.mjs
python3 linter-scripts/check-spec-cross-links.py --root spec --repo-root .
python3 linter-scripts/check-spec-folder-refs.py
python3 linter-scripts/check-memory-mirror-drift.py
bash linter-scripts/check-axios-version.sh
```

**For each:** record exit code and the headline OK/FAIL line.

**Output:**

- Code block of the validator output (trimmed to OK/FAIL lines)
- A "✅ N / N validators clean" headline
- If any validator fails, STOP the audit and report the failure as a
  **🔴 actionable gap** that must be fixed before publishing the audit.
- Otherwise: *"Say `next` to continue, or describe a different next step."*

---

### Phase 4 — Score & write the audit file

Goal: produce `spec/17-consolidated-guidelines/NN-blind-ai-audit-vN.md`.

**Required sections** (mirror the `29-blind-ai-audit-v3.md` template):

1. Header: Version, Updated, Scope, Compares against, Repo version at audit
2. **TL;DR — Verified Outcome** — table with all prior versions' scores
   + this version's, plus a Δ column. Capabilities scored:
   - Understand rules conceptually
   - Build a fresh project from spec
   - Modify the live system
   - Pass project validators
3. **§1 What Changed Since Last Audit** — table of new files / new
   linters / new memory tokens
4. **§2 Prior Acceptable Gaps — Status Now** — table flipping
   `🟡 Acceptable` to `✅ Closed (Phase X)` where applicable
5. **§3 Stress-Test Re-Run** — copy Phase 2's 8-row table verbatim, with
   "Why vN improves" column
6. **§4 Surface-Area Metrics (Empirical)** — copy Phase 1's metrics
7. **§5 Live Validator Snapshot** — copy Phase 3's output
8. **§6 Remaining Acceptable Gaps (Architecturally Permanent)** — only
   list gaps that are *not closeable by design* (e.g., intentional
   placeholder folders, deliberate folding to avoid duplication)
9. **§7 Final Verdict** — multi-row Q&A table
10. **§8 Recommended Next Actions** — event-triggered re-audit rules
11. Cross-references
12. Validation History — append a row for this version
13. Verification block with `AC-CON-NN` (NN = file number)

**Scoring rubric (use uniformly across audits):**

| Symbol on a stress-test task | Score contribution to "Modify live system" |
|---|---|
| ✅ | full credit |
| 🟡 | half credit |
| 🔴 | no credit |

Overall score = weighted average of the 4 capabilities, each out of 100.
Handoff-weighted = same with "Pass project validators" weighted ×2.

**Output:**

- Confirm file written with `wc -l <new file>`
- Stop and say: *"Say `next` to continue, or describe a different next step."*

---

### Phase 5 — Register, version-bump, sync, publish

Goal: integrate the new audit into the repo so it shows up in the
overview, the spec tree, and `version.json`.

**Actions:**

1. Patch `spec/17-consolidated-guidelines/00-overview.md` — add a row for
   the new audit at the bottom of the inventory table.
2. Bump `package.json` `version` — minor bump (`X.Y+1.0`).
3. Run, in this exact order:
   ```bash
   node scripts/sync-version.mjs
   node scripts/sync-spec-tree.mjs
   ```
4. Re-run the four checkers from Phase 3 to confirm the audit didn't
   introduce stale links or drift:
   ```bash
   python3 linter-scripts/check-spec-cross-links.py --root spec --repo-root .
   python3 linter-scripts/check-spec-folder-refs.py
   python3 linter-scripts/check-memory-mirror-drift.py
   bash linter-scripts/check-axios-version.sh
   ```
5. Print a final summary block with:
   - New file path + line count
   - Old → new score
   - Old → new package version
   - All validator exit codes

**Output:**

- The summary block above
- Mark the audit complete: *"Audit vN published. Re-run trigger
  (`blind audit` / `audit gap`) when needed."*

---

## §4 Gap-Hunting Heuristics (use during Phase 2)

When deciding whether a task is ✅ / 🟡 / 🔴, search the consolidated
folder for these *concreteness markers*:

| Marker | What to grep for | Why it matters |
|---|---|---|
| Verbatim file paths | `linter-scripts/`, `scripts/sync-*.mjs` | A blind AI can't guess paths |
| Verbatim env var names | `[A-Z_]{3,}=` patterns | Required for runtime modification |
| Numeric thresholds | `< [0-9]+`, `[0-9]+ lines` | Required to enforce metrics |
| Exit codes | `exit 0`, `exit 1`, `exit 2` | Required for CI integration |
| Generator commands | `node scripts/`, `python3 scripts/` | Required for codegen tasks |
| Allowlist field names | `@waiver`, `@reason`, `[external]`, `[doc-only]` | Required to add exemptions |
| Approved values | enums of allowed strings | Required to avoid rejection |

Missing any of the above for a task → mark it 🟡 or 🔴 with the
specific marker name as the gap description.

---

## §5 Anti-Patterns (reject in your own audit)

- Inventing scores. Every number must trace to a metric or a stress-test
  result.
- Marking a gap "Acceptable" without naming the source folder it covers.
- Skipping the validator snapshot. Without it, the audit is unfalsifiable.
- Re-using prior audit prose verbatim. Each version must update the
  "Why this version improves" cells in the stress-test table.
- Closing a gap without a back-reference (`✅ Closed in Phase X — see
  [file](./...)`).
- Forgetting to bump the version. The audit is part of the spec; an
  un-bumped version means the spec tree is stale.

---

## §6 Trigger Wiring

This prompt is registered as the canonical handler for these chat
triggers (case-insensitive, anywhere in the user message):

- `blind audit`
- `audit gap`
- `gap audit`
- `blind ai audit`

When any trigger fires, read this entire file, then begin **Phase 1**.
Do **not** auto-progress past Phase 1 without an explicit `next`.

---

## §7 File Inventory (this prompt's outputs over time)

| Audit version | File | Score | Date |
|---|---|---|---|
| v1 | `25-blind-ai-implementability-audit.md` | 96.5 / 100 | 2026-04-22 |
| v2 | `26-blind-ai-audit-v2.md` | 99.4 / 100 | 2026-04-22 |
| v3 | `29-blind-ai-audit-v3.md` | 99.8 / 100 | 2026-04-22 |
| v4+ | (next call to this prompt creates `30-…md`) | — | — |

---

*Blind-AI audit prompt — v1.0.0 — 2026-04-22*
