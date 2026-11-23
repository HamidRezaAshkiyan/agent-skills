# CLAUDE.md

Project instructions for Claude Code.

## Skills
Install or keep the skills in `skills/` available under `.claude/skills/` (or `~/.claude/skills/`):
- `skills/gitmoji-commit/` — Gitmoji commit workflow and complete emoji catalog.
- `skills/dotnet-10/` — Modern .NET 10 (LTS) & C# 14 development patterns.

## Rules
- **Commits**: Always format Git commits using the Gitmoji convention (`✨`, `🐛`, `♻️`, `📝`, `✅`, `🔧`, `💥`, etc.) with a concise imperative subject line (<= 50-72 chars, no trailing period). Never commit secrets.
- **.NET 10**: When editing `net10.0` projects, use C# 14 (`field` keyword, `extension(...)` blocks, null-conditional assignment, implicit `Span<T>`) and .NET 10 APIs (built-in OpenAPI 3.1, Minimal API `AddValidation()`, `TypedResults.ServerSentEvents`, EF Core 10 `LeftJoin`/`RightJoin`, Named Query Filters, file-based apps with `#:` directives).
