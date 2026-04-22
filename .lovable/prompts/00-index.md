# Prompts Index

**Version:** 1.0.0
**Updated:** 2026-04-22

This folder holds **reusable, trigger-keyed AI instructions**. Each file
defines (a) a set of **chat trigger phrases** that fire it and (b) a
**phase-by-phase workflow** the AI must follow when triggered.

---

## How triggers work

When the user writes a message containing any registered trigger phrase
(case-insensitive, anywhere in the message), the AI MUST:

1. Read the entire prompt file.
2. Begin at **Phase 1** (or wherever the prompt says to start).
3. Execute exactly **one phase per turn**.
4. After each phase, list remaining phases and STOP — wait for the user
   to say `next` (or describe a different next step) before continuing.

If the user's message contains the trigger AND additional context
(e.g., "blind audit but skip phase 3"), honor the override.

---

## Registered prompts

| # | File | Trigger phrases | Purpose | Status |
|---|------|-----------------|---------|--------|
| 01 | [01-read-prompt.md](./01-read-prompt.md) | `read memory` | Execute the 4-phase AI onboarding protocol | Active |
| 02 | [02-write-prompt.md](./02-write-prompt.md) | `write memory`, `update memory` | Append to project memory using the established schema | Active |
| 03 | [03-write-prompt.md](./03-write-prompt.md) | (per-file triggers — see file header) | Specialized write/update flows | Active |
| 04 | [04-blind-audit-prompt.md](./04-blind-audit-prompt.md) | `blind audit`, `audit gap`, `gap audit`, `blind ai audit` | Run a blind-AI implementability audit phase-by-phase, produce `spec/17-consolidated-guidelines/NN-blind-ai-audit-vN.md`, bump version, sync | Active |

---

## Adding a new prompt

1. Pick the next free integer (currently `05-`).
2. Create `.lovable/prompts/NN-<name>-prompt.md` using
   `04-blind-audit-prompt.md` as the structural template:
   - `**Trigger phrases:**` line in the header (comma-separated).
   - Hard rules section — include "phase-by-phase, wait for `next`".
   - Phases numbered §3 Phase 1, Phase 2, …
   - Anti-patterns section.
   - Trigger wiring section (§6 in the template).
3. Append a row to the table above.
4. Add a memory rule under `mem://workflow/<name>-trigger.md` so future
   AI sessions know the trigger phrase exists. Update `mem://index.md`
   in the same commit.

---

## Anti-patterns

- Triggering a prompt and then completing all phases in one turn (breaks
  the user's `next`-driven cadence).
- Inventing trigger phrases not registered here.
- Editing a prompt without bumping its `**Version:**` header.
- Adding a prompt without registering it in this index AND in
  `mem://workflow/`.

---

*Prompts index — v1.0.0 — 2026-04-22*
