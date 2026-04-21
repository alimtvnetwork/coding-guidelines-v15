# Success-Rate Model

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Definition of "Success"

A unit of AI work is **successful** if and only if **all** of the following hold:

1. **Artifact produced** — the requested file/diff/answer exists.
2. **Validates** — passes the relevant gate (build, lint, replay-render, test) without manual fix-up.
3. **Faithful** — matches the user's stated intent, not a paraphrase the AI preferred.
4. **Reproducible** — re-running the same prompt + inputs gives an equivalent artifact (no nondeterministic hallucinations).
5. **Self-explained** — the AI can name *why* it works against the spec, citing rule IDs.

Missing any of the five = **failure**, even if the artifact looks plausible.

---

## Measurement

| Surface | Sample unit | Pass condition | Source of truth |
|---------|-------------|----------------|-----------------|
| Replay rendering | One captured rrweb session | Renders without flicker, all events present, ≤1 frame skip per 30s | `06-validation-gates.md §G-RPL` |
| Generated code | One PR / one tool-call edit | `run-all.sh` exits 0; no STYLE-*/BOOL-NEG-* findings | `linters-cicd/run-all.sh` |
| Multi-step plan | One user request | All declared tasks reach `done` without backtrack | `task_tracking` log |
| Bug repro | One issue file | Replay produces the same console error | `spec/*/03-issues/` |

The aggregate **AI Success Rate (ASR)** is computed weekly:

```
ASR = successes / total_attempts          (per surface)
ASR_total = weighted_mean(ASR_surface, weight = traffic_share)
```

---

## Gates

| Gate | Threshold | Action on miss |
|------|-----------|----------------|
| **G-PASS** | ASR ≥ 98% | Ship |
| **G-WARN** | 95% ≤ ASR < 98% | Ship + open follow-up issue |
| **G-BLOCK** | ASR < 95% | Hard block; revert change set |

The current baseline (~65%) is below G-BLOCK on all four surfaces. The roadmap below is what closes the gap.

---

## Closing the 65 → 98 Gap

| Phase | Lever | Expected lift | Where it lives |
|-------|-------|---------------|----------------|
| 1 | Adopt failure taxonomy + force ID attribution | +8 pp | `02-failure-taxonomy.md` |
| 2 | Mandatory pre-output validation gates | +10 pp | `06-validation-gates.md` |
| 3 | Anti-flicker rules in replay pipeline | +6 pp (replay only) | `04-anti-flicker-rules.md` |
| 4 | Missing-info recovery loop (auto-add logs, retry) | +5 pp | `05-missing-information-recovery.md` |
| 5 | Edge-condition checklist before declaring done | +4 pp | `07-edge-condition-checklist.md` |
| 6 | Debugging playbook used on every failure (no skip) | +3 pp | `03-debugging-playbook.md` |
| **Total** | | **+36 pp → ~98%** | |

Lifts are non-additive in adversarial cases; the model assumes independent failure modes, which the taxonomy enforces.

---

## What Counts as "Replay Engine ≥95%"

For the replay engine specifically (the tightest user-stated bar):

- **No visible flicker** during 60s of playback at 1× speed.
- **Every captured event** is rendered (zero `event_dropped` log lines).
- **Frame-time variance** stays under 33 ms (≈30 FPS floor).
- **Re-rendering** the same recording produces a pixel-stable output (≥99% SSIM).

Anything else is treated as a `FAIL-RPL-*` per `02-failure-taxonomy.md`.

---

*Success-rate model v1.0.0 — 2026-04-21*