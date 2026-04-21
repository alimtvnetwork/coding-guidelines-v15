# Edge Condition Checklist

**Version:** 1.0.0
**Updated:** 2026-04-21

---

## Purpose

The "programmer-style edge cases" a senior dev mentally runs before saying *done*. Each item is a yes/no question; any "no" or "didn't check" requires action before output.

---

## Inputs

- [ ] What happens with `null`?
- [ ] What happens with `undefined`?
- [ ] What happens with empty string `""`?
- [ ] What happens with empty array `[]` / empty object `{}`?
- [ ] What happens with a single-element collection?
- [ ] What happens with an extremely large collection (10⁶+)?
- [ ] What happens with Unicode (emoji, RTL, combining marks)?
- [ ] What happens with whitespace-only input?
- [ ] What happens with leading/trailing whitespace?
- [ ] What happens at the type boundary (`Number.MAX_SAFE_INTEGER`, negative, zero)?

---

## Time / Concurrency

- [ ] What happens at midnight / DST transition?
- [ ] What happens across timezones (user is UTC+8, server UTC)?
- [ ] What happens if two requests race on the same key?
- [ ] What happens if the user navigates away mid-fetch?
- [ ] What happens on slow 3G (5s+ latency)?
- [ ] What happens offline?
- [ ] What happens if the clock jumps (NTP correction)?

---

## State

- [ ] First render after mount
- [ ] After hot-reload
- [ ] After cache hit vs cache miss
- [ ] After auth-token expiry
- [ ] After feature flag toggle mid-session
- [ ] After window resize / orientation change

---

## Replay-Specific

- [ ] Recording shorter than 1 s
- [ ] Recording longer than 1 h
- [ ] Recording with no user interactions
- [ ] Recording with rapid (60+/s) input bursts
- [ ] Recording captured on Safari then played in Chrome
- [ ] Recording with system zoom != 100%
- [ ] Recording with browser dev tools open (different viewport)

---

## Code-Generation-Specific

- [ ] Function called with default args only
- [ ] Function called with all args explicit
- [ ] Function called with one arg `undefined`
- [ ] Module imported in CommonJS *and* ESM consumer
- [ ] Component rendered in StrictMode (double-effect)
- [ ] Component rendered server-side (no `window`)

---

## How to Use

1. Before output, walk the relevant section(s) for the change being made.
2. For any unchecked box, either (a) add a test, (b) handle the case, or (c) document why it's out of scope in a `task_note`.
3. Never tick a box without evidence.

---

*Edge condition checklist v1.0.0 — 2026-04-21*