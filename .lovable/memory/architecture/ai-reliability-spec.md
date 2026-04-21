---
name: AI Reliability Spec
description: spec/19-ai-reliability/ — 65→98% ASR target with failure taxonomy, anti-flicker rules, missing-info recovery, validation gates, and edge-condition checklist.
type: feature
---

## Location

`spec/19-ai-reliability/` (new top-level Core spec, slot 19; 16/17/18 already taken).

## Files

| # | File | Purpose |
|---|------|---------|
| 00 | `00-overview.md` | Surfaces (RPL/GEN/PLN/REP/CTX), file index |
| 01 | `01-success-rate-model.md` | ASR definition, gates G-PASS/G-WARN/G-BLOCK, 65→98 lift roadmap |
| 02 | `02-failure-taxonomy.md` | `FAIL-{SURFACE}-NNN` IDs — every failure must attribute to one |
| 03 | `03-debugging-playbook.md` | 5 mandatory steps: Reproduce → Instrument → Bisect → Fix → Prove |
| 04 | `04-anti-flicker-rules.md` | A1–A7 (diff-only, inline CSS, recorded ts, font preload, scheme pin, warmup, frame budget) |
| 05 | `05-missing-information-recovery.md` | M1–M7 deterministic recovery (no improvising) |
| 06 | `06-validation-gates.md` | Runnable G-* gates + 12-point pre-output self-check |
| 07 | `07-edge-condition-checklist.md` | Programmer-style edge cases by category |
| 97 | `97-acceptance-criteria.md` | Pass criteria |
| 99 | `99-consistency-report.md` | Cross-link audit |

## Key Rules to Remember

- Below 95% ASR = G-BLOCK (revert).
- Every observed failure must have a `FAIL-*` ID; unattributed = forbidden.
- Debugging: never propose a fix until Reproduce/Instrument/Bisect produced evidence.
- Replay: never re-apply full snapshot mid-playback (FAIL-RPL-001).
- Missing data → log + placeholder + loud failure; never interpolate.
- Pre-output 12-point gate is mandatory before `<final-text>`.

## Pending Follow-ups (tracked in plan.md #16–#19)

- `tests/replay/anti-flicker.spec.ts` (7 named tests)
- `scripts/replay-repro.sh` (G-REP gate)
- `G-CTX` static check in `run-all.sh`
- Promote ⚠ NEEDS REAL EXAMPLE rows with real traces

## Cross-References

- `spec/02-coding-guidelines/06-ai-optimization/01-anti-hallucination-rules.md` (preconditions)
- `spec/02-coding-guidelines/06-ai-optimization/03-common-ai-mistakes.md` (FAIL-GEN mirror)