#!/usr/bin/env python3
"""lint-suggest.py — Pattern 05 (Actionable Lint Suggestions).

For each NEW lint finding (vs baseline), emit a remediation hint
drawn from a built-in suggester table. Output is appended to
GITHUB_STEP_SUMMARY (or the path passed via --out) as Markdown.

Spec: spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/05-actionable-lint-suggestions.md
Contract: exit 0 always (advisory only) | 2 tool error
"""

from __future__ import annotations

import argparse
import json
import os
import sys

EXIT_OK = 0
EXIT_TOOL_ERROR = 2

SUGGESTER_TABLES: dict[str, dict[str, str]] = {
    "golangci": {
        "errcheck": "Wrap with `if err := X; err != nil { return err }` or assign to `_`.",
        "gosimple": "Apply the suggested simplification (often `if x { return true }; return false` -> `return x`).",
        "ineffassign": "Remove the unused assignment or use the value before reassignment.",
        "unused": "Delete the unused identifier or export it if intentional.",
        "staticcheck": "Follow the SA-rule reference: https://staticcheck.dev/docs/checks",
        "govet": "Address the vet warning; common fixes involve printf format strings and lock copies.",
    },
    "eslint": {
        "no-unused-vars": "Remove the unused binding or prefix with `_` if intentional.",
        "no-console": "Replace with the project logger.",
        "react-hooks/exhaustive-deps": "Add the missing dependency or memoize the value.",
        "@typescript-eslint/no-explicit-any": "Replace `any` with a precise type or `unknown` + narrowing.",
    },
}


def load_json(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as fh:
        return json.load(fh)


def normalize_golangci(report: dict) -> list[tuple[str, int, str]]:
    items: list[tuple[str, int, str]] = []
    for issue in report.get("Issues") or []:
        pos = issue.get("Pos") or {}
        items.append((pos.get("Filename", ""), int(pos.get("Line", 0)),
                      issue.get("FromLinter", "")))
    return items


def normalize_eslint(report: list) -> list[tuple[str, int, str]]:
    items: list[tuple[str, int, str]] = []
    for entry in report or []:
        path = entry.get("filePath", "")
        for msg in entry.get("messages") or []:
            items.append((path, int(msg.get("line", 0)), msg.get("ruleId") or ""))
    return items


NORMALIZERS = {"golangci": normalize_golangci, "eslint": normalize_eslint}


def select_table(name: str) -> dict[str, str]:
    table = SUGGESTER_TABLES.get(name)
    if table is None:
        print(f"::error::unknown suggester table: {name}", file=sys.stderr)
        sys.exit(EXIT_TOOL_ERROR)
    return table


def diff_new_findings(
    current: list[tuple[str, int, str]],
    baseline: list[tuple[str, int, str]],
) -> list[tuple[str, int, str]]:
    seen = set(baseline)
    return [item for item in current if item not in seen]


def render_markdown(
    findings: list[tuple[str, int, str]], table: dict[str, str]
) -> str:
    if not findings:
        return "<!-- repo-lint-suggestions -->\n_No new lint findings._\n"
    lines = ["<!-- repo-lint-suggestions -->",
             "### Lint suggestions",
             "",
             "| File | Line | Rule | Suggestion |",
             "|------|------|------|------------|"]
    for path, line, rule in findings:
        hint = table.get(rule, "Consult the linter documentation for this rule.")
        lines.append(f"| `{path}` | {line} | `{rule}` | {hint} |")
    return "\n".join(lines) + "\n"


def write_output(content: str, out_path: str) -> None:
    if out_path == "/dev/stdout" or not out_path:
        sys.stdout.write(content)
        return
    with open(out_path, "a", encoding="utf-8") as fh:
        fh.write(content)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Actionable lint suggestions")
    parser.add_argument("--current", required=True)
    parser.add_argument("--baseline", default="")
    parser.add_argument("--out", default=os.environ.get("GITHUB_STEP_SUMMARY", "/dev/stdout"))
    parser.add_argument(
        "--table",
        default=os.environ.get("CI_GUARDS_LINT_SUGGEST_SUGGESTER_TABLE", "golangci"),
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not os.path.isfile(args.current):
        print(f"::error::current report not found: {args.current}", file=sys.stderr)
        return EXIT_TOOL_ERROR
    normalizer = NORMALIZERS.get(args.table, normalize_golangci)
    current = normalizer(load_json(args.current))
    baseline: list[tuple[str, int, str]] = []
    if args.baseline and os.path.isfile(args.baseline):
        baseline = normalizer(load_json(args.baseline))
    new_findings = diff_new_findings(current, baseline)
    table = select_table(args.table)
    write_output(render_markdown(new_findings, table), args.out)
    return EXIT_OK


if __name__ == "__main__":
    sys.exit(main())