# Agent Skills & Rules

Ready-to-use **Agent Skills** (`SKILL.md` standard) and **Rules** for **Cursor**, **Claude Code**, **Antigravity**, and any agent supporting the open [Agent Skills](https://agentskills.io) format.

## Included Skills

| Skill | Path | Description |
| :--- | :--- | :--- |
| **`app-dev-checklist`** | [`skills/app-dev-checklist/`](./skills/app-dev-checklist/SKILL.md) | Production readiness and polish checklist for **Windows**, **macOS**, **Android**, and **Web / PWA** apps — icons, manifests, dark mode, DPI/viewport scaling, permissions, RTL/a11y, storage paths, installers, and signing. |
| **`gitmoji-commit`** | [`skills/gitmoji-commit/`](./skills/gitmoji-commit/SKILL.md) | Atomic Git commits following the [Gitmoji](https://gitmoji.dev) specification, with a quick-pick table, formatting guardrails, and full categorized 70+ emoji reference. |
| **`dotnet-10`** | [`skills/dotnet-10/`](./skills/dotnet-10/SKILL.md) | Idiomatic **.NET 10 (LTS)** & **C# 14** development: `field` keyword, `extension(...)` blocks, null-conditional assignment, implicit `Span<T>`, ASP.NET Core 10 (OpenAPI 3.1/YAML, Minimal API `AddValidation()`, `TypedResults.ServerSentEvents`, Passkeys), EF Core 10 (`LeftJoin`/`RightJoin`, Named Query Filters, `ExecuteUpdateAsync`), and file-based apps (`#:package`/`#:sdk`/`#:property`). |
| **`dotnet-clean-arch`** | [`skills/dotnet-clean-arch/`](./skills/dotnet-clean-arch/SKILL.md) | Clean Architecture and pragmatic Vertical Slice boundaries in .NET solutions (`Domain`, `Application`, `Infrastructure`, `Presentation/API`). |
| **`api-design-openapi`** | [`skills/api-design-openapi/`](./skills/api-design-openapi/SKILL.md) | REST API design and OpenAPI 3.1 conventions (resource URLs, RFC 9457 `ProblemDetails`, cursor pagination, idempotency, schema evolution). |
| **`pr-review`** | [`skills/pr-review/`](./skills/pr-review/SKILL.md) | Severity-ranked Pull Request & diff reviews evaluating correctness, security, concurrency, compatibility, performance, and tests. |
| **`adr-writer`** | [`skills/adr-writer/`](./skills/adr-writer/SKILL.md) | Lightweight MADR-style Architecture Decision Records (`Context`, `Decision`, `Alternatives Considered`, `Consequences`). |

## Included Rules

- **Cursor** (`.cursor/rules/`):
  - [`app-dev-checklist.mdc`](./.cursor/rules/app-dev-checklist.mdc) — Agent-requested checklist for Windows, macOS, Android, and Web / PWA apps.
  - [`gitmoji-commits.mdc`](./.cursor/rules/gitmoji-commits.mdc) — Agent-requested rule for Git commits.
  - [`dotnet-10.mdc`](./.cursor/rules/dotnet-10.mdc) — Glob-scoped rule (`*.cs`, `*.csproj`, `*.slnx`, `Directory.Build.props`).
  - [`dotnet-clean-arch.mdc`](./.cursor/rules/dotnet-clean-arch.mdc) — Glob-scoped Clean Architecture boundaries for .NET projects.
  - [`api-design-openapi.mdc`](./.cursor/rules/api-design-openapi.mdc) — REST & OpenAPI 3.1 contract rules.
  - [`pr-review.mdc`](./.cursor/rules/pr-review.mdc) — Agent-requested PR review workflow.
  - [`adr-writer.mdc`](./.cursor/rules/adr-writer.mdc) — Agent-requested ADR authoring rules.
- **Antigravity / Cross-Agent** (`.agents/rules/`):
  - [`app-dev-checklist.md`](./.agents/rules/app-dev-checklist.md) — Model-decision checklist for Windows, macOS, Android, and Web / PWA apps.
  - [`gitmoji-commits.md`](./.agents/rules/gitmoji-commits.md) — Model-decision rule for Git commits.
  - [`dotnet-10.md`](./.agents/rules/dotnet-10.md) — Glob-scoped rule for .NET 10 files.
  - [`dotnet-clean-arch.md`](./.agents/rules/dotnet-clean-arch.md) — Glob-scoped Clean Architecture rule.
  - [`api-design-openapi.md`](./.agents/rules/api-design-openapi.md) — REST & OpenAPI 3.1 contract rule.
  - [`pr-review.md`](./.agents/rules/pr-review.md) — Model-decision PR review rule.
  - [`adr-writer.md`](./.agents/rules/adr-writer.md) — Model-decision ADR authoring rule.
- **Root Templates**: [`AGENTS.md`](./AGENTS.md) and [`CLAUDE.md`](./CLAUDE.md).

---

## Quick Install

### Option 1: Using `npx skills` (Recommended for Cursor, Claude Code & more)

```bash
npx skills add HamidRezaAshkiyan/agent-skills
```

Or install a single skill:

```bash
npx skills add HamidRezaAshkiyan/agent-skills --skill app-dev-checklist
npx skills add HamidRezaAshkiyan/agent-skills --skill gitmoji-commit
npx skills add HamidRezaAshkiyan/agent-skills --skill dotnet-10
```

### Option 2: Using `install.sh` (Skills + Rules)

Clone the repository and run the installer script:

```bash
git clone https://github.com/HamidRezaAshkiyan/agent-skills.git
cd agent-skills

# Install skills & rules for Cursor, Claude Code, and Antigravity into a project
./install.sh --all --target /path/to/your-project

# Or install skills globally across all your projects
./install.sh --all --global
```

You can also target specific agents with `--cursor`, `--claude`, or `--antigravity`.

---

## Repository Structure

```text
agent-skills/
├── skills/
│   ├── adr-writer/
│   ├── api-design-openapi/
│   ├── app-dev-checklist/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── android.md
│   │       ├── macos.md
│   │       ├── webapp.md
│   │       └── windows.md
│   ├── dotnet-10/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── csharp-14.md
│   │       └── aspnet-efcore-runtime.md
│   ├── dotnet-clean-arch/
│   ├── gitmoji-commit/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── gitmoji-guide.md
│   └── pr-review/
├── .cursor/
│   └── rules/*.mdc
├── .agents/
│   └── rules/*.md
├── AGENTS.md
├── CLAUDE.md
├── install.sh
├── LICENSE
└── README.md
```

## License

MIT
