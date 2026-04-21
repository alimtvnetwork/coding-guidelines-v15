# Failure Taxonomy

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Why a Taxonomy

Every observed failure must map to exactly one ID. Unattributed failures are forbidden because they cannot be tracked, fixed, or measured. IDs follow `FAIL-{SURFACE}-{NNN}`.

| Surface code | Meaning |
|--------------|---------|
| `RPL` | Replay rendering |
| `GEN` | Generated code |
| `PLN` | Multi-step plan execution |
| `REP` | Bug reproduction |
| `CTX` | Context / instruction handling |

---

## RPL — Replay Rendering

| ID | Name | Symptom | Root cause | Fix reference |
|----|------|---------|------------|---------------|
| FAIL-RPL-001 | Flicker between frames | DOM repaints visibly between two near-identical states | Full snapshot replayed instead of incremental diff | `04-anti-flicker-rules.md §A1` |
| FAIL-RPL-002 | Dropped event | UI state at t=N missing because event was skipped | Event buffer overflow during capture | `05-missing-information-recovery.md §M1` |
| FAIL-RPL-003 | Missing initial snapshot | Replay starts mid-DOM, blank/half UI | Capture started after first paint | `05-missing-information-recovery.md §M2` |
| FAIL-RPL-004 | Stylesheet not inlined | Unstyled flash, then style snaps in | External CSS not captured | `04-anti-flicker-rules.md §A2` |
| FAIL-RPL-005 | Iframe content missing | Iframe replays as empty | Cross-origin frame skipped | `05-missing-information-recovery.md §M3` |
| FAIL-RPL-006 | Timing jitter | Events fire faster/slower than original | Wall-clock used instead of recorded timestamps | `04-anti-flicker-rules.md §A3` |
| FAIL-RPL-007 | Canvas/video black | Canvas paints empty | `recordCanvas` flag off | `05-missing-information-recovery.md §M4` |
| FAIL-RPL-008 | Network responses missing | XHR/fetch shows pending forever | No fetch interception during capture | `05-missing-information-recovery.md §M5` |
| FAIL-RPL-009 | Font swap flash | Text changes font mid-replay | Fonts not preloaded in player | `04-anti-flicker-rules.md §A4` |
| FAIL-RPL-010 | Theme flicker (light↔dark) | Theme toggles for one frame | `prefers-color-scheme` not pinned | `04-anti-flicker-rules.md §A5` |

---

## GEN — Generated Code

Cross-references the catalog in `spec/02-coding-guidelines/06-ai-optimization/03-common-ai-mistakes.md`. Each mistake there has a 1:1 `FAIL-GEN-*` mirror so the metric pipeline can count it.

| ID | Mirrors | Description |
|----|---------|-------------|
| FAIL-GEN-001 | Mistake #1 | camelCase JSON keys generated |
| FAIL-GEN-002 | Mistake #2 | Uppercase abbreviations (`ID`, `URL`) |
| FAIL-GEN-003 | Mistake #3 | Multi-return Go functions instead of `Result[T]` |
| FAIL-GEN-004 | Mistake #4 | `fmt.Errorf` instead of `apperror.Wrap` |
| FAIL-GEN-005 | Mistake #5 | Nested `if` instead of guard |
| FAIL-GEN-006 | Mistake #6 | Boolean without `is`/`has` prefix |
| FAIL-GEN-007 | Mistake #16 | Caching error as success |
| FAIL-GEN-008 | Mistake #17 | `cache.set` without TTL |
| FAIL-GEN-009 | Mistake #20 | `useQuery` without `staleTime` |
| FAIL-GEN-099 | — | Any new mistake — must be promoted to a numbered entry within 24h |

---

## PLN — Multi-Step Plan Execution

| ID | Name | Symptom |
|----|------|---------|
| FAIL-PLN-001 | Dropped task | A declared task never moves to `done` |
| FAIL-PLN-002 | Silent scope creep | AI completes work not in any task |
| FAIL-PLN-003 | Two `in_progress` at once | Concurrency limit violated |
| FAIL-PLN-004 | Backtrack without note | Re-doing prior work without recording why |
| FAIL-PLN-005 | Final summary contradicts task list | "Done" claimed for `todo` items |

---

## REP — Bug Reproduction

| ID | Name | Symptom |
|----|------|---------|
| FAIL-REP-001 | Missing pre-state | Bug only triggers from a specific session that wasn't captured |
| FAIL-REP-002 | Env mismatch | Repro env differs from user env (timezone, locale, viewport) |
| FAIL-REP-003 | Non-deterministic seed | Random/order-dependent path not pinned |
| FAIL-REP-004 | Network mocking gap | Replay can't reach a service the original used |

---

## CTX — Context / Instruction Handling

| ID | Name | Symptom |
|----|------|---------|
| FAIL-CTX-001 | Stale file in context | AI edits an outdated copy, blowing away later changes |
| FAIL-CTX-002 | Memory ignored | AI proposes a previously-rejected pattern |
| FAIL-CTX-003 | Reading file already shown | Wasted tool call on a file in `<current-code>` |
| FAIL-CTX-004 | Parallelizable calls done serially | Latency budget blown |
| FAIL-CTX-005 | Question skipped | AI guesses instead of asking when ambiguous |

---

## ⚠ NEEDS REAL EXAMPLE

The following entries are inferred and need a real captured trace before next release:

- FAIL-RPL-002 (need actual `event_dropped` log)
- FAIL-RPL-005 (need iframe-bearing recording)
- FAIL-PLN-004 (need backtrack git diff)
- FAIL-REP-002 (need env-diff bug report)

Mark them resolved by attaching the trace path under each row.

---

*Failure taxonomy v1.0.0 — 2026-04-21*