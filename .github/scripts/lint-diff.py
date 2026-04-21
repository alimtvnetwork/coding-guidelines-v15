#!/usr/bin/env python3
"""lint-diff.py — Pattern 04 (Baseline-Diff Lint Gate).

Compares a current lint report (golangci-lint JSON by default) against
a frozen baseline. Only NEW findings (file+line+rule not in baseline)
fail the build. Existing findings are grandfathered.

Spec: spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/04-baseline-diff-lint-gate.md
Contract: exit 0 clean | 1 violation | 2 tool error
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from typing import Iterable

EXIT_OK = 0
EXIT_VIOLATION = 1
EXIT_TOOL_ERROR = 2


def load_json(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as fh:
        return json.load(fh)


def normalize_golangci(report: dict) -> set[tuple[str, int, str]]:
    findings: set[tuple[str, int, str]] = set()
    for issue in report.get("Issues") or []:
        pos = issue.get("Pos") or {}
        path = pos.get("Filename", "")
        line = int(pos.get("Line", 0))
        rule = issue.get("FromLinter", "")
        findings.add((path, line, rule))
    return findings


def normalize_eslint(report: list) -> set[tuple[str, int, str]]:
    findings: set[tuple[str, int, str]] = set()
    for file_entry in report or []:
        path = file_entry.get("filePath", "")
        for msg in file_entry.get("messages") or []:
            findings.add((path, int(msg.get("line", 0)), msg.get("ruleId") or ""))
    return findings


NORMALIZERS = {
    "golangci": normalize_golangci,
    "eslint": normalize_eslint,
}


def diff_findings(
    current: Iterable[tuple[str, int, str]],
    baseline: Iterable[tuple[str, int, str]],
) -> list[tuple[str, int, str]]:
    return sorted(set(current) - set(baseline))


def emit_violations(new_findings: list[tuple[str, int, str]]) -> None:
    for path, line, rule in new_findings:
        print(f"::error file={path},line={line}::new lint finding ({rule})")


def select_normalizer(name: str):
    fn = NORMALIZERS.get(name)
    if fn is None:
        print(f"::error::unknown normalizer: {name}", file=sys.stderr)
        sys.exit(EXIT_TOOL_ERROR)
    return fn


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Baseline-diff lint gate")
    parser.add_argument("--current", required=True, help="current lint report path")
    parser.add_argument("--baseline", default="", help="baseline lint report path")
    parser.add_argument(
        "--normalizer",
        default=os.environ.get("CI_GUARDS_LINT_DIFF_NORMALIZER", "golangci"),
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not os.path.isfile(args.current):
        print(f"::error::current report not found: {args.current}", file=sys.stderr)
        return EXIT_TOOL_ERROR
    normalizer = select_normalizer(args.normalizer)
    current = normalizer(load_json(args.current))
    baseline: set[tuple[str, int, str]] = set()
    if args.baseline and os.path.isfile(args.baseline):
        baseline = normalizer(load_json(args.baseline))
    new_findings = diff_findings(current, baseline)
    if not new_findings:
        return EXIT_OK
    emit_violations(new_findings)
    print(f"::error::{len(new_findings)} new lint finding(s) above baseline")
    return EXIT_VIOLATION


if __name__ == "__main__":
    sys.exit(main())