# AI Reliability — Generic 'AI Doing Work' Success Rate

**Version:** 1.0.0
**Updated:** 2026-04-21
**AI Confidence:** Production-Ready
**Ambiguity:** None
**Owner:** Reliability Working Group

---

## Keywords

`ai-reliability`, `success-rate`, `replay-engine`, `failure-taxonomy`, `debugging-playbook`, `flicker`, `missing-information`, `validation-gates`, `recovery`

---

## Scoring

| Criterion | Status |
|-----------|--------|
| `00-overview.md` present | ✅ |
| AI Confidence assigned | ✅ |
| Ambiguity assigned | ✅ |
| Keywords present | ✅ |
| Scoring table present | ✅ |
| Acceptance criteria present | ✅ |

---

## Purpose

Raise the **AI work success rate from the current ~65% baseline to ≥98%** across three replay surfaces:

1. **Browser session replay (rrweb)** — used to debug user UI interactions.
2. **Linter / codegen replay** — used to verify deterministic regeneration in `linters-cicd/`.
3. **AI agent loop replay** — used to measure success of generated code over time.

The spec treats all three as one generic problem: *"AI takes a task, produces an artifact, and the artifact is judged correct or not."* Anything below **95% success is considered a hard failure** and blocks release.

---

## Why 65% Today, ≥98% Target

Empirically observed failure surfaces (see `02-failure-taxonomy.md`):

| Surface | Today | Root cause cluster |
|---------|-------|--------------------|
| Replay rendering | ~65% usable | Flicker, missing frames, timing jitter |
| Generated code | ~70% lints clean first try | Naming/typing hallucinations |
| Multi-step plans | ~60% complete without rework | Lost context, dropped steps |
| Bug reproduction | ~55% reproducible from replay | Missing pre-state, env vars, seeds |

The 33-point gap is **not** a model-capability gap. It is a **process and instrumentation gap** — the same gap a senior developer closes by debugging, adding logs, checking edge conditions, and re-running with a tighter spec.

This folder encodes that senior-developer behaviour as **machine-checkable rules**.

---

## Files

| # | File | Description |
|---|------|-------------|
| 01 | [01-success-rate-model.md](./01-success-rate-model.md) | The 65→98 model: definitions, measurement, gates |
| 02 | [02-failure-taxonomy.md](./02-failure-taxonomy.md) | Catalogue of failure modes with IDs (FAIL-RPL-001 …) |
| 03 | [03-debugging-playbook.md](./03-debugging-playbook.md) | What a senior dev does — encoded as steps |
| 04 | [04-anti-flicker-rules.md](./04-anti-flicker-rules.md) | Replay flicker root causes + fixes |
| 05 | [05-missing-information-recovery.md](./05-missing-information-recovery.md) | Detect & recover from missing frames/data |
| 06 | [06-validation-gates.md](./06-validation-gates.md) | Pre-output gates, build/lint/test thresholds |
| 07 | [07-edge-condition-checklist.md](./07-edge-condition-checklist.md) | Programmer-style edge cases to always check |
| 97 | [97-acceptance-criteria.md](./97-acceptance-criteria.md) | Pass criteria for this spec |
| 99 | [99-consistency-report.md](./99-consistency-report.md) | Cross-link audit |

---

## How AI Should Use This Folder

1. **Before starting work**, read `01-success-rate-model.md` to know what "success" means for this task type.
2. **During work**, consult `03-debugging-playbook.md` whenever a tool call fails or output looks wrong.
3. **Before output**, run the gates in `06-validation-gates.md` and the edge checklist in `07-edge-condition-checklist.md`.
4. **On replay-class issues** (flicker, missing data), apply `04-anti-flicker-rules.md` and `05-missing-information-recovery.md`.
5. **On any failure**, attribute it to a `FAIL-*` ID from `02-failure-taxonomy.md`. Unattributed failures are not allowed.

---

## Cross-References

- [Anti-Hallucination Rules](../02-coding-guidelines/06-ai-optimization/01-anti-hallucination-rules.md) — preconditions enforced before this spec applies
- [Common AI Mistakes](../02-coding-guidelines/06-ai-optimization/03-common-ai-mistakes.md) — seed for failure taxonomy
- [Quick Reference Checklist](../02-coding-guidelines/06-ai-optimization/02-ai-quick-reference-checklist.md) — pairs with §06 gates

---

*AI Reliability overview v1.0.0 — 2026-04-21*