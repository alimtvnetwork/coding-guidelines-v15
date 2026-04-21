#!/usr/bin/env python3
"""
check-context-hygiene.py — G-CTX validation gate.

Spec: spec/19-ai-reliability/06-validation-gates.md (Gate G-CTX)
Version: 1.0.0

Parses a JSONL tool-call log (one JSON object per line) and flags any
`code--view` invocation whose `file_path` was already present in the
same loop's `<current-code>` block. This catches the FAIL-CTX-001
"redundant re-read" anti-pattern that the gate is designed to block.

Expected log shape (one record per line):

    {"loop": 17, "kind": "current_code", "files": ["src/a.tsx", "src/b.tsx"]}
    {"loop": 17, "kind": "tool_call", "name": "code--view",
     "args": {"file_path": "src/a.tsx"}}

`loop` groups records that share a single AI response. `kind` is one of
`current_code` (manifest of files already in context) or `tool_call`
(one tool invocation).

Exit codes:
    0  → PASS  (zero violations)
    1  → FAIL  (one or more violations; G-CTX is non-negotiable per spec)
    2  → ERROR (log file missing / malformed)

Usage:
    check-context-hygiene.py --log .gctx/tool-calls.jsonl
    check-context-hygiene.py --log -            # read stdin
"""
from __future__ import annotations

import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Iterable

VERSION = "1.0.0"
GATE_ID = "G-CTX"


def is_redundant_view(call: dict, in_context: set[str]) -> bool:
    """True when a `code--view` re-reads a file already in <current-code>."""
    if call.get("name") != "code--view":
        return False
    file_path = (call.get("args") or {}).get("file_path")
    return bool(file_path) and file_path in in_context


def iter_records(source: Iterable[str]) -> Iterable[dict]:
    for line_no, raw in enumerate(source, start=1):
        stripped = raw.strip()
        if not stripped:
            continue
        try:
            yield json.loads(stripped)
        except json.JSONDecodeError as exc:
            raise SystemExit(
                _error(f"malformed JSON on line {line_no}: {exc}")
            )


def scan(records: Iterable[dict]) -> list[dict]:
    """Return a list of violation dicts: {loop, file, line_index}."""
    by_loop: dict[int, dict] = defaultdict(
        lambda: {"context": set(), "violations": []}
    )
    for index, rec in enumerate(records):
        loop = rec.get("loop", 0)
        bucket = by_loop[loop]
        if rec.get("kind") == "current_code":
            bucket["context"].update(rec.get("files") or [])
            continue
        if rec.get("kind") == "tool_call" and is_redundant_view(rec, bucket["context"]):
            bucket["violations"].append(
                {
                    "loop": loop,
                    "file": (rec.get("args") or {}).get("file_path"),
                    "record_index": index,
                }
            )
    flat: list[dict] = []
    for bucket in by_loop.values():
        flat.extend(bucket["violations"])
    return flat


def _error(message: str) -> str:
    return (
        f"GATE: {GATE_ID}\n"
        f"RESULT: ERROR\n"
        f"EVIDENCE: {message}\n"
        f"ATTRIBUTED-TO: FAIL-CTX-000\n"
        f"NEXT-ACTION: fix invocation and rerun\n"
    )


def render_report(violations: list[dict], log_path: str) -> str:
    if not violations:
        return (
            f"GATE: {GATE_ID}\n"
            f"RESULT: PASS\n"
            f"EVIDENCE: zero redundant code--view in {log_path}\n"
        )
    sample = violations[0]
    return (
        f"GATE: {GATE_ID}\n"
        f"RESULT: FAIL\n"
        f"EVIDENCE: {len(violations)} redundant code--view "
        f'(first: loop={sample["loop"]} file={sample["file"]})\n'
        f"LOG: {log_path}\n"
        f"ATTRIBUTED-TO: FAIL-CTX-001\n"
        f"NEXT-ACTION: stop re-reading files already shown in <current-code>\n"
    )


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description="G-CTX context-hygiene check")
    parser.add_argument("--log", required=True, help="JSONL tool-call log, or '-' for stdin")
    parser.add_argument("--version", action="version", version=f"check-context-hygiene {VERSION}")
    args = parser.parse_args(argv)

    if args.log == "-":
        records = list(iter_records(sys.stdin))
        log_label = "<stdin>"
    else:
        log_path = Path(args.log)
        if not log_path.is_file():
            sys.stderr.write(_error(f"log file not found: {args.log}"))
            return 2
        with log_path.open("r", encoding="utf-8") as fh:
            records = list(iter_records(fh))
        log_label = str(log_path)

    violations = scan(records)
    sys.stdout.write(render_report(violations, log_label))
    return 1 if violations else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))