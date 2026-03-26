# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Markdown-based personal wiki and technical knowledge base covering system administration (FreeBSD, Linux, macOS, OpenBSD, Windows), information security, software development, and networking. There is no application to build or test suite to run.

## Common Commands

```bash
# Install tooling (gitchangelog for CHANGELOG.md generation)
python3 -m venv venv && venv/bin/pip install -r requirements.txt

# Regenerate CHANGELOG.md from git history (requires clean working tree)
bash bin/gen_changelog.sh

# Search for existing notes before adding new content
rg -n "term" .
```

## Architecture

- `index.md` — central navigation hub and table of contents; update it when adding major new categories
- `Sysadmin/` — organized by OS (`FreeBSD/`, `Linux/`, `MacOS/`, `OpenBSD/`, `Windows/`) and service type
- `InfoSec/` — security frameworks, tools, and protection notes
- `Devel/` — software development notes (Python, Git, OpenCV)
- `Notes/` — cheat sheets (bash, zsh, mutt, find, etc.)
- `Misc/` — miscellaneous topics
- `Archive/` — deprecated/historical content; move obsolete notes here instead of deleting them
- `bin/` — repo maintenance scripts (`gen_changelog.sh`)

## Conventions

**Commit messages** use short prefixes with optional scope in brackets:
- `new: [doc] Added FreeBSD ZFS notes`
- `chg: [doc] Updated python release information`
- `fix: [locale] Fixed localegen update`

**Markdown style**: short sections, descriptive headings, fenced code blocks for commands. Match surrounding file style rather than reformatting unrelated content. Use spaces (not tabs) for indentation.

**File naming**: use clear, topic-based names for new pages (e.g., `Sysadmin/Linux/NewTopic.md`). Some legacy files use mixed naming — prefer updating existing patterns in place.

**Multi-OS accuracy**: when updating commands, verify against the specific target system — the wiki covers multiple distinct environments (e.g., FreeBSD vs. Debian have different package managers, paths, and conventions).

**Security hygiene**: use `example.com` and placeholder values instead of real hostnames, credentials, or private infrastructure details.
