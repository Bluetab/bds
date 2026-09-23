#!/usr/bin/env python3
"""Block Cursor Agent shell commands that branch or rewrite remotes in BDS."""

from __future__ import annotations

import json
import re
import sys

BDS_MARKERS = (
    "/apps/bia/bds",
    "apps/bia/bds",
    "/Users/euclydes.young/apps/bia/bds",
)

RESTORE_SSH = re.compile(
    r"git(?:\s+-C\s+\S+)?\s+remote\s+set-url\s+origin\s+"
    r"['\"]?git@github\.com:Bluetab/bds\.git['\"]?",
    re.IGNORECASE,
)

FORBIDDEN = [
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+checkout\s+-b\b", re.I),
        "Creating a new git branch in BDS is forbidden. Stay on the current branch.",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+switch\s+-c\b", re.I),
        "Creating/switching to a new git branch in BDS is forbidden. Stay on the current branch.",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+worktree\s+add\b", re.I),
        "Creating a git worktree for BDS is forbidden. Edit the existing checkout in place.",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+remote\s+set-url\b", re.I),
        "Changing BDS remotes is forbidden. origin must stay git@github.com:Bluetab/bds.git",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+remote\s+add\b", re.I),
        "Adding git remotes in BDS is forbidden.",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+remote\s+(?:remove|rm)\b", re.I),
        "Removing git remotes in BDS is forbidden.",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+config\b[^\n]*remote\.origin\.url", re.I),
        "Rewriting remote.origin.url in BDS is forbidden.",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+config\b[^\n]*insteadOf", re.I),
        "Git insteadOf rewrites that can swap SSH↔HTTPS are forbidden for BDS.",
    ),
    (
        re.compile(r"https://github\.com/Bluetab/bds(?:\.git)?", re.I),
        "HTTPS origin for BDS is forbidden. Use SSH: git@github.com:Bluetab/bds.git",
    ),
    (
        re.compile(r"git(?:\s+-C\s+\S+)?\s+init\b", re.I),
        "git init in/around BDS is forbidden.",
    ),
]


def deny(message: str) -> None:
    payload = {
        "permission": "deny",
        "user_message": message,
        "agent_message": (
            message
            + " Edit BDS in place on the current branch. "
            "Never create branches or rewrite origin. "
            "If origin is already HTTPS, restore with: "
            "git remote set-url origin git@github.com:Bluetab/bds.git"
        ),
    }
    print(json.dumps(payload))
    sys.exit(0)


def allow() -> None:
    print(json.dumps({"permission": "allow"}))
    sys.exit(0)


def is_bds_context(cwd: str, command: str) -> bool:
    haystack = f"{cwd}\n{command}"
    return any(marker in haystack for marker in BDS_MARKERS)


def main() -> None:
    try:
        raw = sys.stdin.read()
        data = json.loads(raw) if raw.strip() else {}
    except json.JSONDecodeError:
        deny("BDS git policy hook received invalid JSON; blocking shell command.")

    command = str(data.get("command") or data.get("cmd") or "")
    cwd = str(data.get("cwd") or data.get("working_directory") or data.get("workdir") or "")

    if not command:
        allow()

    if not is_bds_context(cwd, command):
        allow()

    if RESTORE_SSH.search(command):
        allow()

    for pattern, message in FORBIDDEN:
        if pattern.search(command):
            deny(message)

    allow()


if __name__ == "__main__":
    main()
