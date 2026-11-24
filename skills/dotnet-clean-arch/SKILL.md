---
name: dotnet-clean-arch
description: >-
  Enforce Clean Architecture and Pragmatic Vertical Slice boundaries in .NET
  solutions (Domain, Application, Infrastructure, Presentation/API). Guides
  dependency direction, rich domain models, Result<T> error handling, CQRS
  use-case handlers, and Minimal API endpoints. Use when scaffolding .NET
  projects, adding new features/modules, refactoring layered code, or reviewing
  project references.
---

# .NET Clean Architecture Skill

Keep .NET codebases modular, testable, and decoupled from infrastructure details while avoiding unnecessary ceremony and over-abstraction.

## Layering & Dependency Rule

Dependencies **always point inward** toward the Domain:

```text
Presentation (API / Web / Worker) ──► Application ──► Domain
Infrastructure (EF Core / HTTP / MQ) ──► Application ──► Domain
```

| Layer | Owns | Must NOT Reference |
| :--- | :--- | :--- |
| **Domain** | Entities, Aggregates, Value Objects, Domain Events, Domain Errors, Core Invariants | EF Core, ASP.NET Core, HTTP clients, DI containers, Infrastructure |
| **Application** | Use Cases (Commands/Queries + Handlers), DTOs, Validation, Port Interfaces (`IOrderRepository`, `IClock`, `IUnitOfWork`) | EF Core `DbContext` concrete types, ASP.NET Core `HttpContext`, external SDKs |
| **Infrastructure** | EF Core `DbContext` & Configurations, Repositories, External API clients, Messaging, File/Cache adapters | Presentation/API types |
| **Presentation (API)** | Minimal API Endpoints / Controllers, Request/Response mapping, Auth middleware, OpenAPI, DI composition root | Domain internals directly for business mutations (route through Application use cases) |

## Core Practices

1. **Rich Domain, Not Anemic Models**:
   - Protect invariants with private setters, factory methods (`Order.Create(...)`), and behavior methods (`order.Cancel(...)`) rather than public `set` properties mutated across services.
   - Use strongly typed Value Objects (e.g., `Money`, `Email`, `OrderId`) for concepts with validation or rules.
2. **Explicit `Result<T>` Over Exception Control Flow**:
   - Return typed `Result` / `Result<T>` with domain `Error` codes for expected business failures (not found, validation, conflict, forbidden).
   - Reserve exceptions for truly unexpected/unrecoverable failures (DB outage, bugs).
3. **Pragmatic CQRS & Feature Organization**:
   - Organize `Application/` by **feature/use-case folder** (e.g., `Orders/CreateOrder/`, `Orders/GetOrderById/`), not giant `Services/` or `Managers/` buckets.
   - Keep read queries lightweight (direct projection DTOs with `AsNoTracking()`, no need to hydrate full domain aggregates for read-only views).
4. **Avoid Generic Repository Bloat**:
   - Do not wrap EF Core `DbSet<T>` in a leaky `IGenericRepository<T>` returning `IQueryable<T>`.
   - Either define focused, aggregate-specific repository interfaces (`IOrderRepository`) or expose a narrow `IApplicationDbContext` interface for read-side projections.
5. **Thin Endpoints**:
   - Minimal API endpoints only bind input, invoke the Application use case, and map `Result<T>` to `TypedResults` (`200`, `201`, `400`, `404`, `409`, `ProblemDetails`).

## Reference Patterns

For concrete C# examples (layer folder structure, rich aggregate, `Result<T>` mapping, feature handler, Minimal API endpoint, and `NetArchTest` boundary verification), read `references/architecture-patterns.md`.

## Architecture Review Checklist

- Does `Domain.csproj` have **zero** NuGet dependencies on EF Core, ASP.NET Core, or external SDKs?
- Are EF Core entities/configurations kept out of `Domain` (fluent `IEntityTypeConfiguration<T>` in `Infrastructure` instead of `[Table]`/`[Column]` attributes polluting Domain)?
- Is every state-changing operation guarded by domain invariants and executed via a dedicated use-case handler?
- Are `CancellationToken`s threaded from the endpoint all the way to persistence/HTTP calls?
- Is there an architecture test verifying dependency rules automatically in CI?
