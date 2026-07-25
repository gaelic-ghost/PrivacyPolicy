#!/usr/bin/env python3
"""Fail a public release when tracked source or Git history contains sensitive data."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent

SECRET_PATTERNS = {
    "private key": re.compile(r"-----BEGIN (?:[A-Z0-9 ]+ )?PRIVATE KEY-----"),
    "AWS access key": re.compile(r"\b(?:AKIA|ASIA)[0-9A-Z]{16}\b"),
    "GitHub token": re.compile(r"\b(?:gh[pousr]_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,})\b"),
    "OpenAI-style API key": re.compile(r"\bsk-(?:proj-|live-|test-)?[A-Za-z0-9_-]{20,}\b"),
    "Slack token": re.compile(r"\bxox[abprs]-[A-Za-z0-9-]{10,}\b"),
    "embedded credential assignment": re.compile(
        r"(?i)\b(?:password|passwd|secret|api[_-]?key|access[_-]?token)\s*[:=]\s*[\"']?[^\s\"']{12,}"
    ),
}

SSN_PATTERN = re.compile(r"\b\d{3}-\d{2}-\d{4}\b")
CARD_PATTERN = re.compile(r"\b(?:\d[ -]?){13,19}\b")


def run(*command: str) -> str:
    return subprocess.check_output(command, cwd=ROOT, text=True)


def is_luhn_valid(value: str) -> bool:
    digits = [int(character) for character in value if character.isdigit()]
    if not 13 <= len(digits) <= 19:
        return False
    total = 0
    for index, digit in enumerate(reversed(digits)):
        total += digit if index % 2 == 0 else (digit * 2 - 9 if digit > 4 else digit * 2)
    return total % 10 == 0


def findings_in_text(source: str, text: str) -> list[str]:
    findings: list[str] = []
    for line_number, line in enumerate(text.splitlines(), start=1):
        for category, pattern in SECRET_PATTERNS.items():
            if pattern.search(line):
                findings.append(f"{source}:{line_number}: possible {category}")
        if SSN_PATTERN.search(line):
            findings.append(f"{source}:{line_number}: possible US Social Security number")
        if any(is_luhn_valid(match.group()) for match in CARD_PATTERN.finditer(line)):
            findings.append(f"{source}:{line_number}: possible payment-card number")
    return findings


def tracked_file_findings() -> list[str]:
    paths = run("git", "ls-files", "-z").split("\0")
    findings: list[str] = []
    for raw_path in filter(None, paths):
        path = ROOT / raw_path
        content = path.read_bytes()
        if b"\0" in content:
            continue
        findings.extend(findings_in_text(raw_path, content.decode("utf-8", errors="ignore")))
    return findings


def history_findings() -> list[str]:
    history = run("git", "log", "--all", "--format=", "-p", "--no-ext-diff")
    return findings_in_text("Git history", history)


def main() -> int:
    findings = sorted(set(tracked_file_findings() + history_findings()))
    if findings:
        print("Public-data scan blocked the release. Remove the sensitive value from source and Git history before publishing.", file=sys.stderr)
        print("\n".join(findings), file=sys.stderr)
        return 1
    print("Public-data scan passed: no high-confidence secrets or sensitive PII were found in tracked files or Git history.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
