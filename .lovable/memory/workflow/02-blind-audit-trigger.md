---
name: Blind-AI Audit Trigger
description: Chat triggers that invoke the phase-by-phase blind-AI implementability audit prompt
type: workflow
---

# Blind-AI Audit Trigger

When the user's message contains any of these phrases (case-insensitive,
anywhere in the message), the AI MUST execute the blind-audit prompt:

- `blind audit`
- `audit gap`
- `gap audit`
- `blind ai audit`

## What to do on trigger

1. Open `.lovable/prompts/04-blind-audit-prompt.md` and read it fully.
2. Execute **Phase 1 only**, then list remaining phases and STOP.
3. Wait for the user to say `next` before continuing to Phase 2.
4. Repeat: one phase per `next`, until Phase 5 (publish) is complete.

## What NOT to do

- Do not run all 5 phases in one turn — the user wants step-by-step
  control.
- Do not invent additional trigger phrases.
- Do not skip Phase 3 (validator snapshot) — without it the audit has no
  empirical backing.
- Do not forget to bump `package.json` and run sync scripts in Phase 5.

## Output cadence (every phase)

End every phase with:

> Say `next` to continue, or describe a different next step.

This is the literal handoff signal the user expects.

## Cross-references

- Prompt body: `.lovable/prompts/04-blind-audit-prompt.md`
- Index: `.lovable/prompts/00-index.md`
- Audit lineage: `spec/17-consolidated-guidelines/{25,26,29}-…audit*.md`
