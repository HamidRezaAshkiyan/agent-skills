---
trigger: glob
globs: "**/*.cs,**/*.csproj,**/*.slnx,**/Directory.Build.props"
description: Prefer idiomatic .NET 10 (LTS) and C# 14 features when working on C# and .NET files.
---

# .NET 10 & C# 14 Rules

For projects targeting `net10.0`:
- Prefer C# 14 `field`-backed properties, `extension(...)` blocks (instance/static properties, methods, operators), null-conditional assignment (`?.=`), implicit `Span<T>`/`ReadOnlySpan<T>` conversions, simple lambda parameter modifiers, and unbound generic `nameof(...)`.
- Prefer ASP.NET Core 10 built-in OpenAPI 3.1 (JSON & `.yaml`), `AddValidation()` for Minimal APIs, `TypedResults.ServerSentEvents` (`SseItem<T>`), and native `System.Text.Json` JSON Patch.
- Prefer EF Core 10 native `LeftJoin`/`RightJoin`, Named Query Filters (`HasQueryFilter("Name", ...)`), and conditional `ExecuteUpdateAsync` lambdas.
- Use .NET 10 file-based apps (`dotnet run app.cs` with `#:sdk`, `#:package`, `#:property`) for standalone scripts.
- Verify `<TargetFramework>net10.0</TargetFramework>` before applying C# 14 syntax to existing projects.
- Activate the `dotnet-10` skill for detailed examples and migration patterns.
