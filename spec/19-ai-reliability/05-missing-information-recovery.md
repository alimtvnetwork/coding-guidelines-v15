# Missing Information Recovery

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Premise

When the AI (or replay player) discovers that something it needs is **not present**, the default must be **recover deterministically**, not improvise. Improvising = hallucination.

Three legal recoveries: **detect → log → either (a) fetch, (b) substitute with explicit placeholder, or (c) fail loudly**. Silent skip is forbidden.

---

## M1 — Dropped Replay Event

**Detect:** `recorder.dropCount > 0` at end of capture, or a gap >500 ms with no events between two interactions.

**Recover:**
1. Log `FAIL-RPL-002 dropped=<n> at t=<ms>` to the player console.
2. Insert a synthetic `placeholder` event that pauses playback and renders a thin yellow bar at the gap.
3. Player exposes `onGap(gap => ...)` so the host UI can show "data missing".
4. Never interpolate — interpolation would be hallucinated state.

---

## M2 — Missing Initial Snapshot

**Detect:** First event in the buffer is not a `FullSnapshot`.

**Recover:**
1. Refuse to start playback.
2. Surface `FAIL-RPL-003` with a remediation hint: "re-record with `recordAfter: 'load'`".
3. Provide a "play partial" escape hatch behind a confirm dialog — never default to it.

---

## M3 — Cross-Origin Iframe

**Detect:** Iframe element captured but its DOM tree is `null`.

**Recover:**
1. Render the iframe slot with a hatched placeholder + the original `src` URL as alt text.
2. Log `FAIL-RPL-005`.
3. Document the limitation in `spec/19-ai-reliability/02-failure-taxonomy.md` row.

---

## M4 — Empty Canvas / Video

**Detect:** Canvas paint events absent though the original DOM had a `<canvas>` with `width>0`.

**Recover:**
1. Render an SVG placeholder with the canvas dimensions.
2. Suggest enabling `recordCanvas: true` in capture config.
3. FAIL-RPL-007.

---

## M5 — Network Trace Missing

**Detect:** XHR/fetch events present in DOM (e.g. spinner shown) but no `network` events in the recording.

**Recover:**
1. Replace fetch responses with synthetic `pending` state that resolves with a placeholder body after the original wall-clock delta.
2. Watermark the placeholder body so it's never confused with real data.
3. FAIL-RPL-008.

---

## M6 — Code Generation: Missing File in Context

**Detect:** Tool call returns "file not found" or context shows a referenced symbol the AI didn't read.

**Recover:**
1. Stop. Do **not** synthesize the file's content.
2. Run `code--view` or `code--search_files` to fetch real contents.
3. Only then continue. Skipping = FAIL-CTX-003.

---

## M7 — Plan: Missing Acceptance Criteria

**Detect:** A task is in `in_progress` but has no measurable "done" condition.

**Recover:**
1. Add a `task_note` declaring the acceptance criterion before continuing.
2. If the criterion can't be stated, ask the user via `questions--ask_questions`.
3. Never silently mark such a task `done`.

---

## General Rule

> If you cannot point to the byte/frame/file that justifies a state, you are hallucinating it.

The recovery actions above turn that rule into runnable code paths.

---

*Missing-info recovery v1.0.0 — 2026-04-21*