# Agent Skills & Rules

Ready-to-use **Agent Skills** (`SKILL.md` standard) and **Rules** for **Cursor**, **Claude Code**, **Antigravity**, and any agent supporting the open [Agent Skills](https://agentskills.io) format.

## Included Skills

| Skill | Path | Description |
| :--- | :--- | :--- |
| **`gitmoji-commit`** | [`skills/gitmoji-commit/`](./skills/gitmoji-commit/SKILL.md) | Atomic Git commits following the [Gitmoji](https://gitmoji.dev) specification, with a quick-pick table, formatting guardrails, and full categorized 70+ emoji reference. |
| **`dotnet-10`** | [`skills/dotnet-10/`](./skills/dotnet-10/SKILL.md) | Idiomatic **.NET 10 (LTS)** & **C# 14** development: `field` keyword, `extension(...)` blocks, null-conditional assignment, implicit `Span<T>`, ASP.NET Core 10 (OpenAPI 3.1/YAML, Minimal API `AddValidation()`, `TypedResults.ServerSentEvents`, Passkeys), EF Core 10 (`LeftJoin`/`RightJoin`, Named Query Filters, `ExecuteUpdateAsync`), and file-based apps (`#:package`/`#:sdk`/`#:property`). |

## Included Rules

- **Cursor** (`.cursor/rules/`):
  - [`gitmoji-commits.mdc`](./.cursor/rules/gitmoji-commits.mdc) — Agent-requested rule for Git commits.
  - [`dotnet-10.mdc`](./.cursor/rules/dotnet-10.mdc) — Glob-scoped rule (`*.cs`, `*.csproj`, `*.slnx`, `Directory.Build.props`).
- **Antigravity / Cross-Agent** (`.agents/rules/`):
  - [`gitmoji-commits.md`](./.agents/rules/gitmoji-commits.md) — Model-decision rule for Git commits.
  - [`dotnet-10.md`](./.agents/rules/dotnet-10.md) — Glob-scoped rule for .NET 10 files.
- **Root Templates**: [`AGENTS.md`](./AGENTS.md) and [`CLAUDE.md`](./CLAUDE.md).

---

## Quick Install

### Option 1: Using `npx skills` (Recommended for Cursor, Claude Code & more)

```bash
npx skills add HamidRezaAshkiyan/agent-skills
```

Or install a single skill:

```bash
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
│   ├── gitmoji-commit/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── gitmoji-guide.md
│   └── dotnet-10/
│       ├── SKILL.md
│       └── references/
│           ├── csharp-14.md
│           └── aspnet-efcore-runtime.md
├── .cursor/
│   └── rules/
│       ├── gitmoji-commits.mdc
│       └── dotnet-10.mdc
├── .agents/
│   └── rules/
│       ├── gitmoji-commits.md
│       └── dotnet-10.md
├── AGENTS.md
├── CLAUDE.md
├── install.sh
├── LICENSE
└── README.md
```

## License

MIT
