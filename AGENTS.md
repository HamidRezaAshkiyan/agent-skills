# Agent Instructions

This repository provides reusable **Agent Skills** (`skills/`) and **Rules** (`.cursor/rules/`, `.agents/rules/`) compatible with **Cursor**, **Claude Code**, **Antigravity**, and `npx skills`.

## Global Conventions

### Git Commits (Gitmoji)
- Always use the [Gitmoji](https://gitmoji.dev) convention (`<emoji> <Imperative summary>`).
- Keep commits atomic, subjects <= 50-72 characters, imperative mood, no trailing period.
- Refer to `skills/gitmoji-commit/SKILL.md` for the full workflow and reference table.

### .NET 10 & C# 14
- When targeting `net10.0`, prefer C# 14 (`field`, `extension(...)` blocks, `?.=`, implicit spans, lambda modifiers, unbound `nameof`) and .NET 10 platform APIs (ASP.NET Core 10 OpenAPI 3.1/YAML, `AddValidation()`, `TypedResults.ServerSentEvents`, EF Core 10 `LeftJoin`/`RightJoin`, Named Query Filters, file-based apps with `#:package`/`#:sdk`/`#:property`).
- Refer to `skills/dotnet-10/SKILL.md` for complete guidance and references.
