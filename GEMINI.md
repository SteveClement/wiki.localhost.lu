# GEMINI.md - Project Context

## Project Overview
This repository is a personal wiki and technical knowledge base belonging to Steve Clement. It contains a vast collection of notes, tutorials, and documentation covering various IT domains, including System Administration (FreeBSD, Linux, MacOS), Information Security, Software Development, and Networking.

The project is primarily a **Non-Code Project**, consisting of Markdown files organized by topic. However, it includes minimal Python-based tooling for repository maintenance.

## Directory Structure
- `index.md`: The main entry point and table of contents for the wiki.
- `Sysadmin/`: Technical notes on various operating systems and services (FreeBSD, Linux, Databases, Networking, etc.).
- `InfoSec/`: Notes on security frameworks, tools, and general protection.
- `Devel/`: Documentation related to software development (Python, Git, OpenCV).
- `Notes/`: General technical notes and cheat sheets (Bash, Zsh, Mutt, etc.).
- `Misc/`: Miscellaneous topics ranging from audio tools to specific project notes.
- `Archive/`: Deprecated or historical notes preserved for context.
- `bin/`: Utility scripts for repository management.
- `AGENTS.md`: Internal guidelines for contributors/agents regarding project structure and conventions.

## Tooling and Maintenance
The repository uses `gitchangelog` to maintain a history of changes based on Git commit messages.

### Setup Environment
To install the necessary tooling:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Generating Changelog
A helper script is provided to automate the `CHANGELOG.md` update:
```bash
bash bin/gen_changelog.sh
```
*Note: This script requires a clean Git working directory and will automatically commit the updated `CHANGELOG.md`.*

## Development Conventions
- **Markdown Style**: Use short sections, descriptive headings, and fenced code blocks for commands. Follow existing file patterns.
- **Naming**: File names are generally descriptive and topic-based. Some legacy files use mixed naming conventions; prefer consistent, lowercase, hyphen-separated names for new files where possible.
- **Commit Messages**: Use short prefixes:
  - `new:` for new pages or content.
  - `chg:` for updates to existing content.
  - `fix:` for corrections.
  - Example: `chg: [doc] Updated FreeBSD sysctl tips`
- **Security**: Never commit real credentials, private hostnames, or sensitive infrastructure details. Use `example.com` or similar placeholders.

## Usage Guidelines
- Use `grep_search` or `rg` to find existing notes before adding new ones to avoid duplication.
- When updating technical commands, verify their accuracy against the target system (e.g., FreeBSD vs. Debian) as the wiki covers multiple distinct environments.
- Maintain the `index.md` as the central navigation hub if adding major new categories.
