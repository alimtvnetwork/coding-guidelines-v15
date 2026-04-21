#!/usr/bin/env python3
"""check-collisions.py — Pattern 03 (Cross-File Collision Audit).

Scans files matching CI_GUARDS_COLLISIONS_FILE_GLOB and reports
identifiers declared in more than one file (the sort of duplicate
that produces "redeclared in this block" build breaks).

Spec: spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/03-cross-file-collision-audit.md
Contract: exit 0 clean | 1 violation | 2 tool error
"""

from __future__ import annotations

import glob
import os
import re
import sys
from collections import defaultdict

EXIT_OK = 0
EXIT_VIOLATION = 1
EXIT_TOOL_ERROR = 2

FILE_GLOB = os.environ.get(
    "CI_GUARDS_COLLISIONS_FILE_GLOB", "gitmap/constants/constants*.go"
)
IDENT_REGEX = os.environ.get(
    "CI_GUARDS_COLLISIONS_IDENT_REGEX", r"^[A-Z][A-Za-z0-9_]*"
)
RAWSTRING_DELIM = os.environ.get("CI_GUARDS_COLLISIONS_RAWSTRING_DELIM", "`")
BLOCK_OPEN = os.environ.get(
    "CI_GUARDS_COLLISIONS_BLOCK_OPEN_REGEX", r"^\s*const\s*\("
)
BLOCK_CLOSE = os.environ.get(
    "CI_GUARDS_COLLISIONS_BLOCK_CLOSE_REGEX", r"^\s*\)"
)


def list_target_files() -> list[str]:
    return sorted(glob.glob(FILE_GLOB, recursive=True))


def is_block_open(line: str) -> bool:
    return re.match(BLOCK_OPEN, line) is not None


def is_block_close(line: str) -> bool:
    return re.match(BLOCK_CLOSE, line) is not None


def extract_identifier(line: str) -> str | None:
    stripped = line.lstrip()
    match = re.match(IDENT_REGEX, stripped)
    if match is None:
        return None
    return match.group(0)


def collect_idents_in_file(path: str) -> set[str]:
    idents: set[str] = set()
    in_block = False
    in_rawstr = False
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        for line in fh:
            in_rawstr ^= line.count(RAWSTRING_DELIM) % 2 == 1
            if in_rawstr:
                continue
            if is_block_open(line):
                in_block = True
                continue
            if in_block and is_block_close(line):
                in_block = False
                continue
            if not in_block:
                continue
            ident = extract_identifier(line)
            if ident is not None:
                idents.add(ident)
    return idents


def build_collision_index(files: list[str]) -> dict[str, list[str]]:
    index: dict[str, list[str]] = defaultdict(list)
    for path in files:
        for ident in collect_idents_in_file(path):
            index[ident].append(path)
    return {name: paths for name, paths in index.items() if len(paths) > 1}


def report_collisions(collisions: dict[str, list[str]]) -> None:
    for name in sorted(collisions):
        files = ", ".join(collisions[name])
        print(f"::error::identifier {name} declared in multiple files: {files}")


def main() -> int:
    files = list_target_files()
    if not files:
        print(f"::warning::no files matched glob {FILE_GLOB}", file=sys.stderr)
        return EXIT_OK
    collisions = build_collision_index(files)
    if not collisions:
        return EXIT_OK
    report_collisions(collisions)
    return EXIT_VIOLATION


if __name__ == "__main__":
    sys.exit(main())