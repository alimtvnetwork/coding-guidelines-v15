# Debugging Playbook — What a Senior Developer Does

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Premise

A senior developer doesn't *guess*. They (a) reproduce, (b) instrument, (c) bisect, (d) fix, (e) prove. This playbook encodes those five steps so the AI executes them deterministically rather than skipping ahead to a fix.

**Hard rule:** the AI may not propose a fix until steps (a), (b), and (c) have produced evidence. Skipping is a `FAIL-CTX-005`.

---

## Step A — Reproduce (always first)

1. Identify the failing surface (`RPL`, `GEN`, `PLN`, `REP`, `CTX`).
2. State the **exact** input that triggered it (file + line, prompt, replay file path).
3. Run the smallest command that reproduces it locally:
   - Replay: `./run.sh replay --file <path> --speed 1`
   - Code: `./run-all.sh --paths <file>`
   - Plan: re-execute the failing tool call with same args
4. Confirm the failure is **deterministic** (3/3 runs). If not, escalate to FAIL-REP-003.

---

## Step B — Instrument (add evidence)

The AI must add observability before guessing.

| Surface | What to add |
|---------|-------------|
| Replay flicker | `console.debug('[rpl] frame', t, dirtyNodeCount)` around the diff apply path |
| Generated code | `linters-cicd/run-all.sh --explain` to dump rule hits |
| Plan dropouts | Add a `task_note` at every branch decision |
| Bug repro | Capture network HAR + console + viewport into `/mnt/documents/repro-{date}.zip` |

Logs added during debugging are kept until the issue is closed; removing them prematurely is `FAIL-CTX-001`.

---

## Step C — Bisect (narrow blame)

- **File bisect** for code regressions: `git log --oneline` on the affected file, half the range, retest.
- **Frame bisect** for replay flicker: binary-search the timeline (skip to t/2, decide which half flickers, repeat).
- **Rule bisect** for linter regressions: disable rules in groups of 5 via `.codeguidelines.toml` until the failing rule is isolated.

Stop when blame is narrowed to **a single change** (one commit, one frame range, one rule, one tool call).

---

## Step D — Fix (smallest possible change)

- Fix at the **deepest layer that owns the bug** — never patch a symptom one layer up. Symptom-layer fixes are `FAIL-CTX-002`.
- Touch one file when possible. Justify any cross-file change in the task note.
- The fix must reference the `FAIL-*` ID it closes.

---

## Step E — Prove (gate before declaring done)

- Re-run the Step A reproduction; expect 0/3 failures.
- Run the relevant gate from `06-validation-gates.md` (G-RPL / G-GEN / G-PLN / G-REP).
- Add or update a regression test that would have caught the bug.
- Update the failure taxonomy entry: append `Closed: <commit-sha>` row.

---

## Common AI Anti-Patterns This Replaces

| Anti-pattern | What playbook step prevents it |
|--------------|-------------------------------|
| "Try to fix" loop | Step A demands deterministic repro first |
| Wrapping a symptom in `try/catch` | Step D bans symptom-layer fixes |
| "It works for me" without rerun | Step E requires 0/3 on the original repro |
| Removing `console.log` immediately | Step B keeps logs until close |
| Skipping the question and guessing | Step A forces the exact input to be named |

---

## Loop-Out Conditions

The AI must stop and ask the user when:

- Step A cannot reproduce after 2 attempts and the user-provided trace is the only evidence.
- Step C bisect lands on **two simultaneous causes** (genuine race).
- Step D would require deleting tests or expanding `any` typing.

These map to the `questions--ask_questions` tool, not silent best-effort.

---

*Debugging playbook v1.0.0 — 2026-04-21*