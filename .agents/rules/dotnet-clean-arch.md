---
trigger: model_decision
description: Enforce Clean Architecture and feature-sliced boundaries in .NET solutions (Domain, Application, Infrastructure, API).
---

# .NET Clean Architecture Rules

- Enforce strict inward dependencies: `API` and `Infrastructure` depend on `Application`, which depends on `Domain`. `Domain` has zero framework/EF Core dependencies.
- Model rich aggregates with private setters and factory/behavior methods; return explicit `Result<T>` for expected domain failures.
- Organize Application use cases by feature folder and avoid leaky `IGenericRepository<T>` abstractions.
- Keep Minimal API endpoints thin and map domain failures to `TypedResults` / `ProblemDetails`.
- Activate the `dotnet-clean-arch` skill for concrete folder layouts, C# patterns, and architecture tests.
