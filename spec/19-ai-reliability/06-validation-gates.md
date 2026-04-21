# Validation Gates

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Gate Catalog

Each gate has an ID, a deterministic command, and a hard threshold. A change set that touches the gated surface must pass before merge.

| Gate | Surface | Command | Pass condition |
|------|---------|---------|----------------|
| G-GEN | Generated code | `./run-all.sh --jobs 4` | Exit 0; zero `STYLE-*`, `BOOL-NEG-*`, `MISSING-DESC-*` findings |
| G-RPL | Replay rendering | `npm run test -- tests/replay/anti-flicker.spec.ts` | All 7 anti-flicker tests pass; SSIM ≥ 0.99 vs golden |
| G-PLN | Plan execution | `task_tracking--get_task_list` post-loop | Zero `todo` left without explicit deferral note |
| G-REP | Bug repro | `./scripts/replay-repro.sh <issue>` | Console error from issue file appears in trace |
| G-CTX | Context hygiene | static check on tool-call log | Zero `code--view` for files already in `<current-code>` |

---

## Pre-Output Gate (every AI response that ships code)

Before emitting `<final-text>` the AI must mentally run this 12-point gate. Any "no" → fix and re-check, do not ship.

1. Did I attribute every failure I hit to a `FAIL-*` ID?
2. Did I run the relevant G-* command for the touched surface?
3. Are all generated identifiers PascalCase / camelCase per AH-N1..N7?
4. Are all booleans `is`/`has` prefixed and positively named?
5. Are all `cache.set` calls scoped with explicit TTL?
6. Are all `useQuery` calls given an explicit `staleTime`?
7. Did I use guard clauses (no nested `if`)?
8. Functions ≤ 15 lines, files ≤ 300 lines, components ≤ 100 lines?
9. Did I update `.lovable/plan.md` if I started/finished a tracked task?
10. Did I bump `package.json` minor version if code changed?
11. Did I avoid touching `.release/` and read-only files?
12. Did I list remaining tasks at end (per user preference)?

---

## Failure Reporting

When a gate fails, the AI must emit:

```
GATE: <id>
RESULT: FAIL
EVIDENCE: <command output snippet>
ATTRIBUTED-TO: <FAIL-* id>
NEXT-ACTION: <what will be done next>
```

No "fix in next iteration" without a tracked task ID.

---

## Severity Mapping

| Gate result | Severity | Effect |
|-------------|----------|--------|
| All gates pass | OK | Ship |
| 1 G-* fails on ASR ≥ 95% surface | Warn | Ship + open issue under `03-issues/` |
| 1 G-* fails on ASR < 95% surface | Block | Revert |
| ≥ 2 G-* fail | Block | Revert |
| G-CTX fails | Block | Always — context hygiene is non-negotiable |

---

*Validation gates v1.0.0 — 2026-04-21*