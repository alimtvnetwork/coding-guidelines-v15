# Acceptance Criteria: AI Reliability

**Version:** 1.0.0

---

## Required

- [ ] All 9 files (00, 01-07, 97, 99) present
- [ ] Every failure has a `FAIL-{SURFACE}-{NNN}` ID
- [ ] Every anti-flicker rule has a paired test name
- [ ] Every validation gate has a runnable command
- [ ] Cross-references to `02-coding-guidelines/06-ai-optimization/` resolve

## Validation

- [ ] Reading the folder front-to-back gives a senior dev enough to debug a flicker bug without external help
- [ ] An AI agent can attribute any observed failure to exactly one ID
- [ ] The pre-output 12-point gate is satisfiable in ≤ 60 s of self-check
- [ ] G-* gate commands exit with documented codes (no "see logs")

## Roll-Up Targets

- [ ] Replay surface ASR ≥ 95% on the next measurement window
- [ ] Generated-code surface ASR ≥ 98%
- [ ] Plan-execution surface ASR ≥ 98%
- [ ] Aggregate ASR ≥ 98%

---

*Acceptance criteria v1.0.0 — 2026-04-21*