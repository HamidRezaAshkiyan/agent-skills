---
name: dotnet-10
description: >-
  Write idiomatic modern .NET 10 (LTS) and C# 14 code across ASP.NET Core 10,
  EF Core 10, BCL/Runtime, and single-file apps. Use when creating, refactoring,
  reviewing, or migrating C# / .NET projects targeting net10.0, or when the user
  asks to use the latest .NET 10 or C# 14 features.
---

# .NET 10 & C# 14 Modern Development Skill

Apply idiomatic **.NET 10 (LTS)** and **C# 14** patterns instead of legacy .NET 6/8 boilerplate.

## First Step: Verify Target Framework

Before applying .NET 10 / C# 14 syntax, check the project's `.csproj`, `Directory.Build.props`, or `global.json`:
- Ensure `<TargetFramework>net10.0</TargetFramework>` (or `net10.0-*` for platform targets).
- C# 14 is the default language version for `net10.0` — do not unnecessarily hardcode `<LangVersion>preview</LangVersion>` unless using preview-only features.
- If the project targets an older TFM (e.g., `net8.0`), ask before upgrading or stick to the project's TFM.

## Prefer Modern .NET 10 / C# 14 Patterns

| Legacy Pattern | Modern .NET 10 / C# 14 Pattern |
| :--- | :--- |
| Manual private backing field `_name` just for validation | **`field` keyword** inside property accessors |
| Repeating `this T source` across static extension methods (and inability to add extension properties/operators) | **C# 14 `extension(...)` blocks** for instance & static extension methods, properties, and operators |
| `if (obj is not null) { obj.Prop = val; }` | **Null-conditional assignment**: `obj?.Prop = val;` |
| `arr.AsSpan()` boilerplate everywhere | **First-class implicit `Span<T>` / `ReadOnlySpan<T>` conversions** |
| `(string text, out int value) => int.TryParse(text, out value)` | **Modifiers on simple lambda parameters**: `(text, out value) => ...` |
| `GroupJoin` + `SelectMany` + `DefaultIfEmpty` for SQL LEFT JOIN | **Native LINQ / EF Core 10 `LeftJoin` and `RightJoin`** |
| Combining soft-delete + tenant filters into one `HasQueryFilter` | **EF Core 10 Named Query Filters** + selective `IgnoreQueryFilters("Name")` |
| Hand-rolled SSE response headers & manual `data:` flushing | **ASP.NET Core 10 `TypedResults.ServerSentEvents`** with `SseItem<T>` |
| Third-party Minimal API validation filters for DataAnnotations | **Built-in Minimal API validation** (`builder.Services.AddValidation()`) |
| Swashbuckle for basic OpenAPI spec generation | **Built-in OpenAPI 3.1** (`AddOpenApi()` + `MapOpenApi()` with JSON & `.yaml` output) |
| Scaffolding a full `.csproj` for a quick utility or script | **.NET 10 File-Based Apps** (`dotnet run app.cs` with `#:package`, `#:sdk`, `#:property`) |
| `Newtonsoft.Json` for JSON Patch (`JsonPatchDocument`) | **Native `System.Text.Json`-based JSON Patch** in ASP.NET Core 10 |

## Detailed References (Load On Demand)

Read only the reference needed for the current task:
- **C# 14 Language Features** (`field`, `extension(...)` blocks, null-conditional assignment, implicit `Span<T>`, unbound generic `nameof`, lambda parameter modifiers, `partial` constructors/events):
  Read `references/csharp-14.md`.
- **ASP.NET Core 10, EF Core 10, Runtime/BCL & File-Based Apps** (OpenAPI 3.1 YAML, Minimal API validation, SSE, Passkeys, `LeftJoin`/`RightJoin`, Named Query Filters, `ExecuteUpdateAsync`, `System.Text.Json`, `WebSocketStream`, `#:package`/`#:sdk`/`#:property`):
  Read `references/aspnet-efcore-runtime.md`.

## Code Quality Checklist for .NET 10

- Prefer **primary constructors**, **collection expressions** (`[]`), **`field`-backed properties**, and **file-scoped namespaces** for concise, readable code.
- Prefer **AOT-friendly** APIs (`System.Text.Json` source generation, built-in OpenAPI, Minimal APIs, `TypedResults`) over reflection-heavy libraries when building APIs or CLI tools.
- Use `CancellationToken` propagation across all async endpoints, EF Core queries, and `IAsyncEnumerable<T>` streams (`[EnumeratorCancellation]`).
- When writing quick scripts or prototypes, prefer a single `.cs` file with `#:package` / `#:sdk` directives, and mention `dotnet project convert app.cs` if it outgrows a single file.
- Run `dotnet build` and `dotnet test` after changes to verify compilation and tests pass on `net10.0`.
