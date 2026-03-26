# Repository Guidelines

## Project Structure & Module Organization
This repository is a Markdown-based wiki, not an application build. Top-level folders group notes by domain: `Sysadmin/`, `InfoSec/`, `Devel/`, `Notes/`, and `Misc/`. Older or superseded material lives in `Archive/`. The main entry page is `index.md`, and project history is summarized in `CHANGELOG.md`. Utility scripts belong in `bin/`; currently `bin/gen_changelog.sh` is the only contributor-facing helper.

## Build, Test, and Development Commands
There is no compile step. Common contributor commands are:

- `git status` to confirm a clean working tree before generating docs metadata.
- `python3 -m venv venv && venv/bin/pip install -r requirements.txt` to install local tooling.
- `bash bin/gen_changelog.sh` to rebuild `CHANGELOG.md` from Git history. The script expects a clean repository and will create `venv/` if needed.
- `rg -n "term" .` to find related notes before editing or adding a page.

## Coding Style & Naming Conventions
Write in Markdown with short sections, descriptive headings, and fenced code blocks for commands. Match the surrounding file style instead of reformatting unrelated content. Use spaces for indentation in lists and code examples; avoid tabs. File names are mixed legacy names, so prefer updating existing patterns in place, but use clear topic-based names for new pages, for example `Sysadmin/Linux/NewTopic.md`.

## Testing Guidelines
There is no automated test suite in this repository. Validation is manual: check Markdown rendering, confirm internal links still make sense, and review command examples for copy/paste accuracy. For broad documentation updates, run `bash bin/gen_changelog.sh` only when you intend to refresh `CHANGELOG.md`.

## Commit & Pull Request Guidelines
Recent history uses short prefixes such as `chg:`, `fix:`, and `new:`, often with a scope in brackets, for example `chg: [doc] Updated python release information`. Keep commit subjects concise and imperative. Pull requests should describe the affected topic area, call out any renamed or moved pages, and include rendered screenshots only when formatting changes are significant.

## Security & Content Hygiene
Do not commit secrets, hostnames, credentials, or private infrastructure details unless they are already intentionally public. Prefer sanitized examples like `example.com`, and move obsolete or risky historical notes into `Archive/` instead of deleting context outright.
