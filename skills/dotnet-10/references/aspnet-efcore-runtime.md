# .NET 10 Platform Reference: ASP.NET Core 10, EF Core 10, Runtime & File-Based Apps

Idiomatic examples for the major .NET 10 (LTS) platform additions.

---

## 1. File-Based Apps (Single-File C# Execution)

Run, build, and publish a single `.cs` file without a `.csproj` using top-of-file `#:` directives.

```csharp
#:sdk Microsoft.NET.Sdk.Web
#:package Dapper@2.1.66
#:property PublishAot=true

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new { status = "healthy" }));

app.Run();
```

CLI commands:
```bash
dotnet run app.cs              # Restore packages & run
dotnet publish app.cs          # Publish (supports Native AOT)
dotnet project convert app.cs  # Upgrade to a full .csproj when it grows
```

Rules:
- All `#:sdk`, `#:package`, and `#:property` directives must appear at the **top of the file** before any C# statements or `using` directives.
- `#:package Name@Version` (or `#:package Name Version`) pins a NuGet dependency.

---

## 2. ASP.NET Core 10

### OpenAPI 3.1 (JSON & YAML)
Built-in OpenAPI defaults to **OpenAPI 3.1** (with full JSON Schema 2020-12 support) and natively serves YAML when the route ends in `.yaml` or `.yml`.

```csharp
builder.Services.AddOpenApi();

var app = builder.Build();

app.MapOpenApi();                               // /openapi/v1.json
app.MapOpenApi("/openapi/{documentName}.yaml"); // /openapi/v1.yaml
```

### Built-in Minimal API Validation
Enable automatic `DataAnnotations` / `IValidatableObject` validation across Minimal APIs (returns RFC 9457 `HttpValidationProblemDetails` with HTTP 400 on failure).

```csharp
using System.ComponentModel.DataAnnotations;

builder.Services.AddValidation();

app.MapPost("/orders", (CreateOrderRequest request) =>
    TypedResults.Created($"/orders/{Guid.CreateVersion7()}", request));

public record CreateOrderRequest(
    [property: Required, StringLength(64)] string Sku,
    [property: Range(1, 1000)] int Quantity);
```

Opt out on a specific endpoint with `.DisableValidation()`.

### Native Server-Sent Events (SSE)
Stream strongly typed events via `TypedResults.ServerSentEvents` and `System.Net.ServerSentEvents.SseItem<T>`.

```csharp
using System.Net.ServerSentEvents;
using System.Runtime.CompilerServices;

app.MapGet("/events/prices", (CancellationToken ct) =>
{
    async IAsyncEnumerable<SseItem<PriceTick>> StreamTicks(
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var id = 0L;
        while (!cancellationToken.IsCancellationRequested)
        {
            var tick = new PriceTick("BTC", 95_000m, DateTimeOffset.UtcNow);
            yield return new SseItem<PriceTick>(tick, eventType: "price-update")
            {
                EventId = (++id).ToString()
            };
            await Task.Delay(TimeSpan.FromSeconds(2), cancellationToken);
        }
    }

    return TypedResults.ServerSentEvents(StreamTicks(ct));
});

public record PriceTick(string Symbol, decimal Price, DateTimeOffset Timestamp);
```

### Other ASP.NET Core 10 Highlights
- **Passkeys in Identity**: Built-in WebAuthn / FIDO2 passkey support in ASP.NET Core Identity for passwordless sign-in.
- **Native JSON Patch**: `System.Text.Json`-backed `JsonPatchDocument<T>` (no `Newtonsoft.Json` required).
- **Blazor**: Preloaded framework static assets, automatic memory pool eviction, and enhanced form validation.

---

## 3. Entity Framework Core 10

### Native `LeftJoin` and `RightJoin`
Replaces the legacy `GroupJoin` + `SelectMany` + `DefaultIfEmpty()` boilerplate and translates directly to SQL `LEFT JOIN` / `RIGHT JOIN`.

```csharp
var results = await db.Orders
    .LeftJoin(
        db.Customers,
        order => order.CustomerId,
        customer => customer.Id,
        (order, customer) => new
        {
            order.Id,
            order.Total,
            CustomerName = customer != null ? customer.Name : "Guest"
        })
    .ToListAsync(ct);
```

### Named Query Filters
Register multiple independent global filters per entity and selectively disable specific filters per query.

```csharp
// In OnModelCreating
modelBuilder.Entity<Document>()
    .HasQueryFilter("SoftDelete", d => !d.IsDeleted)
    .HasQueryFilter("Tenant", d => d.TenantId == _tenantContext.TenantId);

// Disable only SoftDelete while keeping Tenant isolation active!
var archived = await db.Documents
    .IgnoreQueryFilters(["SoftDelete"])
    .ToListAsync(ct);
```

### `ExecuteUpdateAsync` Enhancements
Supports regular (non-expression) lambdas for conditional/dynamic updates without building expression trees manually, plus improved JSON column updates:

```csharp
await db.Products
    .Where(p => p.CategoryId == categoryId)
    .ExecuteUpdateAsync(setters =>
    {
        setters.SetProperty(p => p.UpdatedAt, DateTimeOffset.UtcNow);
        if (applyDiscount)
        {
            setters.SetProperty(p => p.Price, p => p.Price * 0.9m);
        }
    }, ct);
```

### Complex Types Improvements
Improved column naming uniquification and nested path mapping for value objects mapped as Complex Types, plus better JSON column support.

---

## 4. Runtime & Base Class Library (BCL)

- **JIT & Runtime**: Enhanced devirtualization (including array interface methods), improved inlining and loop optimizations, and stack allocation of small arrays to reduce GC pressure.
- **`System.Text.Json`**:
  - `JsonSerializerOptions.Strict` preset and `AllowDuplicateProperties = false` to reject duplicate JSON keys.
  - Native `PipeReader` deserialization support for high-throughput streaming pipelines.
- **Networking (`WebSocketStream`)**: Stream-based abstraction over `WebSocket` (`WebSocketStream.Create(...)`) that simplifies framing and `StreamReader`/`StreamWriter`/`System.Text.Json` integration.
- **Post-Quantum Cryptography**: Expanded ML-DSA, HashML-DSA, SLH-DSA, and ML-KEM APIs, plus AES KeyWrap with Padding.
- **UUIDv7**: Continue using `Guid.CreateVersion7()` for time-ordered, index-friendly database primary keys.
