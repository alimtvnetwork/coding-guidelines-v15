# Anti-Flicker Rules

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Definition

**Flicker** = any visible state oscillation between two paint cycles that the user did not cause and that doesn't exist in the source recording. Detected by frame-diff sampling at 60 Hz; >2% pixel delta between frames N and N+2 with N+1 being a near-blank/styled-flash counts as flicker.

---

## A1 — Apply Diffs, Never Replay Snapshots

❌ **Never** re-apply a full DOM snapshot once playback has started.
✅ **Always** apply incremental mutations between snapshots.

- Snapshots are entry points only (start, seek). Between them, only `incrementalSnapshot` events run.
- A re-snapshot mid-playback causes a teardown→rebuild cycle = flicker.

Linter signal: any `applyFullSnapshot()` call in playback path that is not preceded by a `seek` is FAIL-RPL-001.

---

## A2 — Inline Stylesheets at Capture Time

❌ **Never** rely on the network to fetch CSS during replay.
✅ **Always** inline external `<link rel=stylesheet>` content into the recording.

- Use `inlineStylesheet: true` on the recorder.
- Player must refuse to start if any stylesheet hash is unresolved (FAIL-RPL-004).

---

## A3 — Use Recorded Timestamps, Not Wall-Clock

❌ **Never** schedule next event with `setTimeout(playNext, FIXED_MS)`.
✅ **Always** schedule with `setTimeout(playNext, event.timestamp - playerStart)`.

- Wall-clock drift is the #1 cause of jitter (FAIL-RPL-006).
- Reset `playerStart` on every `seek`.

---

## A4 — Preload Fonts Before First Frame

❌ **Never** start playback before `document.fonts.ready` resolves.
✅ **Always** await `document.fonts.ready` after stylesheet inline + before first paint.

- Catches FAIL-RPL-009.
- Add a 1500 ms hard timeout; if exceeded, surface a warning and proceed (do not hang).

---

## A5 — Pin Color Scheme & Reduced Motion

❌ **Never** let the player inherit the host's `prefers-color-scheme`.
✅ **Always** wrap the player root in `<div data-theme="{recorded}">` and override media queries via a CSS shadow scope.

- Theme oscillation = FAIL-RPL-010.
- Same rule for `prefers-reduced-motion` — pin to recorded value.

---

## A6 — Quiet the First 100 ms

❌ **Never** allow user input or auto-focus during the first 100 ms after mount.
✅ **Always** apply `pointer-events: none` + `inert` on the player root for 100 ms warmup.

- Prevents focus-ring flash and accidental click-through.

---

## A7 — Frame-Time Budget

- Apply ≤ 16 ms of mutations per `requestAnimationFrame` tick.
- If a tick would exceed budget, split mutations across the next tick(s).
- Implementation: a microtask queue with deadline check via `performance.now()`.

Failure to chunk = visible jank, scored as FAIL-RPL-001.

---

## Validation

Each rule is checked by `tests/replay/anti-flicker.spec.ts`:

| Rule | Test name |
|------|-----------|
| A1 | `does_not_apply_full_snapshot_mid_playback` |
| A2 | `refuses_unresolved_stylesheet_hash` |
| A3 | `schedules_using_recorded_timestamps` |
| A4 | `awaits_document_fonts_ready` |
| A5 | `pins_color_scheme_to_recorded_value` |
| A6 | `inert_during_warmup_window` |
| A7 | `splits_mutations_over_frame_budget` |

CI gate G-RPL requires all 7 to pass per release.

---

*Anti-flicker rules v1.0.0 — 2026-04-21*