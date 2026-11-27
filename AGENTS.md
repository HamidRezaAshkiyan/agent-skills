# AGENTS.md — Agent Skills & Rules

## Overview
Reusable **Agent Skills** (`skills/`, open [Agent Skills](https://agentskills.io) `SKILL.md` standard) and **Rules** (`.cursor/rules/`, `.agents/rules/`) compatible with **Cursor**, **Claude Code**, **Antigravity**, and `npx skills`.

## Global Conventions

### Git Commits (Gitmoji)
- Always use the [Gitmoji](https://gitmoji.dev) convention (`<emoji> <Imperative summary>`).
- Keep commits atomic, subjects <= 50-72 characters, imperative mood, no trailing period.
- Refer to `skills/gitmoji-commit/SKILL.md` for the full workflow and reference table.

### .NET 10 & C# 14
- When targeting `net10.0`, prefer C# 14 (`field`, `extension(...)` blocks, `?.=`, implicit spans, lambda modifiers, unbound `nameof`) and .NET 10 platform APIs (ASP.NET Core 10 OpenAPI 3.1/YAML, `AddValidation()`, `TypedResults.ServerSentEvents`, EF Core 10 `LeftJoin`/`RightJoin`, Named Query Filters, file-based apps with `#:package`/`#:sdk`/`#:property`).
- Refer to `skills/dotnet-10/SKILL.md` for complete guidance and references.

## Tech Stack & Requirements
- **Formats:** Markdown with YAML frontmatter (`SKILL.md`, `.mdc`, `.md`)
- **Installer:** Bash (`install.sh`, `bash` with `set -euo pipefail`) or Node.js (`npx skills`)
- **No build step or runtime dependencies.**

## Repository Structure
```text
agent-skills/
├── skills/                             # Cross-agent skills (SKILL.md + references/)
│   ├── adr-writer/                     # MADR Architecture Decision Records
│   ├── api-design-openapi/             # REST API & OpenAPI 3.1 conventions
│   ├── app-dev-checklist/              # Windows, macOS, Android & Web/PWA checklist
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── android.md
│   │       ├── macos.md
│   │       ├── webapp.md
│   │       └── windows.md
│   ├── dotnet-10/                      # .NET 10 & C# 14 core guidance
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── csharp-14.md
│   │       └── aspnet-efcore-runtime.md
│   ├── dotnet-clean-arch/              # Clean Architecture & Vertical Slices for .NET
│   ├── gitmoji-commit/                 # Gitmoji commit workflow & quick-pick table
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── gitmoji-guide.md
│   └── pr-review/                      # Severity-ranked PR & diff code review
├── .cursor/rules/                      # Cursor rules (*.mdc)
├── .agents/rules/                      # Antigravity / .agents standard rules (*.md)
├── install.sh                          # Project or --global installer for Cursor, Claude, Antigravity
├── AGENTS.md                           # Cross-agent root instructions template (this file)
├── CLAUDE.md                           # Claude Code root instructions template
├── README.md                           # Catalog and installation guide
└── LICENSE                             # MIT
```

## Architecture & Authoring Guide
Each capability is distributed across three synchronized layers:
1. **Skill (`skills/<skill-name>/SKILL.md`):**
   - Must start with YAML frontmatter containing `name` (matching the directory name) and `description` (clear trigger criteria).
   - Keep `SKILL.md` concise and procedural; place bulky tables or deep API docs in `skills/<skill-name>/references/*.md`.
2. **Cursor Rule (`.cursor/rules/<rule-name>.mdc`):**
   - YAML frontmatter uses `description`, optional `globs` (YAML list), and `alwaysApply: false`.
3. **Antigravity / `.agents` Rule (`.agents/rules/<rule-name>.md`):**
   - YAML frontmatter uses `trigger` (`glob` or `model_decision`), optional `globs` (comma-separated string), and `description`.
4. **Root Templates (`AGENTS.md`, `CLAUDE.md`) & `README.md`:**
   - Update all three when adding or significantly changing a skill so templates and docs stay consistent.

## Development & Commands
```bash
# Install all skills & rules into a target project
./install.sh --all --target /path/to/project

# Install for specific agents (--cursor, --claude, --antigravity / --agents)
./install.sh --cursor --antigravity --target /path/to/project

# Install skills globally (~/.cursor/skills, ~/.claude/skills, ~/.gemini/config/skills, ~/.agents/skills)
./install.sh --all --global

# Install via npx skills CLI
npx skills add HamidRezaAshkiyan/agent-skills
npx skills add HamidRezaAshkiyan/agent-skills --skill gitmoji-commit
```

## Configuration & Environment
No environment variables or secrets are required. `install.sh` copies into `$TARGET_DIR/{.cursor,.claude,.agents}/` (project mode) or `$HOME/{.cursor,.claude,.gemini/config,.agents}/skills` (global mode).

## Conventions & Gotchas
- **Global install copies skills only:** `install.sh --global` installs `skills/` only; rules (`.cursor/rules/`, `.agents/rules/`) are only copied in project-scoped (`--target`) mode.
- **Frontmatter schema differs by agent:** Cursor `.mdc` uses a YAML array for `globs` + `alwaysApply`, whereas `.agents/rules/*.md` uses `trigger: glob` + a comma-separated `globs` string. Do not copy-paste frontmatter blindly between them.
- **Keep `AGENTS.md` and `CLAUDE.md` aligned:** Both files serve as root instruction templates for downstream repos.
