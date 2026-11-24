# .NET Clean Architecture Patterns Reference

Concrete, pragmatic C# 14 / .NET 10 examples illustrating Clean Architecture with feature-sliced Application organization.

---

## 1. Recommended Solution Layout

```text
src/
├── MyApp.Domain/
│   ├── Common/                 # Entity, AggregateRoot, ValueObject, Result, Error, IDomainEvent
│   └── Orders/
│       ├── Order.cs
│       ├── OrderLine.cs
│       ├── Money.cs
│       └── OrderErrors.cs
├── MyApp.Application/
│   ├── Abstractions/           # IOrderRepository, IUnitOfWork, IReadDbContext
│   └── Orders/
│       ├── CreateOrder/
│       │   ├── CreateOrderCommand.cs
│       │   └── CreateOrderHandler.cs
│       └── GetOrderById/
│           ├── GetOrderByIdQuery.cs
│           └── GetOrderByIdHandler.cs
├── MyApp.Infrastructure/
│   ├── Persistence/
│   │   ├── AppDbContext.cs
│   │   ├── Configurations/OrderConfiguration.cs
│   │   └── Repositories/OrderRepository.cs
│   └── DependencyInjection.cs
└── MyApp.Api/
    ├── Endpoints/OrderEndpoints.cs
    ├── Extensions/ResultExtensions.cs
    └── Program.cs
tests/
├── MyApp.Domain.Tests/
├── MyApp.Application.Tests/
├── MyApp.Architecture.Tests/   # Enforces layer dependency rules
└── MyApp.Api.IntegrationTests/
```

---

## 2. Rich Domain Aggregate (Zero Framework Dependencies)

```csharp
namespace MyApp.Domain.Orders;

public sealed class Order
{
    private readonly List<OrderLine> _lines = [];

    public Guid Id { get; private set; }
    public Guid CustomerId { get; private set; }
    public OrderStatus Status { get; private set; }
    public IReadOnlyCollection<OrderLine> Lines => _lines.AsReadOnly();

    private Order() { } // Required by EF Core

    public static Result<Order> Create(Guid customerId, IEnumerable<OrderLine> lines)
    {
        var lineList = lines.ToList();
        if (lineList.Count == 0)
            return Result<Order>.Failure(OrderErrors.EmptyOrder);

        var order = new Order
        {
            Id = Guid.CreateVersion7(),
            CustomerId = customerId,
            Status = OrderStatus.Pending
        };
        order._lines.AddRange(lineList);
        return Result<Order>.Success(order);
    }

    public Result Cancel()
    {
        if (Status == OrderStatus.Shipped)
            return Result.Failure(OrderErrors.AlreadyShipped);

        Status = OrderStatus.Cancelled;
        return Result.Success();
    }
}
```

---

## 3. Application Feature Handler

```csharp
namespace MyApp.Application.Orders.CreateOrder;

public sealed record CreateOrderCommand(Guid CustomerId, IReadOnlyList<OrderLineDto> Lines);

public sealed class CreateOrderHandler(
    IOrderRepository orders,
    IUnitOfWork unitOfWork)
{
    public async Task<Result<Guid>> HandleAsync(
        CreateOrderCommand command,
        CancellationToken ct)
    {
        var lines = command.Lines
            .Select(l => new OrderLine(l.ProductId, l.Quantity, l.UnitPrice));

        var orderResult = Order.Create(command.CustomerId, lines);
        if (orderResult.IsFailure)
            return Result<Guid>.Failure(orderResult.Error);

        await orders.AddAsync(orderResult.Value, ct);
        await unitOfWork.SaveChangesAsync(ct);

        return Result<Guid>.Success(orderResult.Value.Id);
    }
}
```

---

## 4. Thin Minimal API Endpoint

```csharp
public static class OrderEndpoints
{
    public static IEndpointRouteBuilder MapOrderEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/v1/orders").WithTags("Orders");

        group.MapPost("/", async (
            CreateOrderCommand command,
            CreateOrderHandler handler,
            CancellationToken ct) =>
        {
            var result = await handler.HandleAsync(command, ct);
            return result.Match(
                onSuccess: id => TypedResults.Created($"/v1/orders/{id}", new { id }),
                onFailure: error => error.ToProblem());
        });

        return app;
    }
}
```

---

## 5. Architecture Boundary Test (`NetArchTest.Rules`)

```csharp
[Fact]
public void Domain_Should_Not_Depend_On_Other_Layers()
{
    var result = Types.InAssembly(typeof(Order).Assembly)
        .ShouldNot()
        .HaveDependencyOnAny(
            "MyApp.Application",
            "MyApp.Infrastructure",
            "MyApp.Api",
            "Microsoft.EntityFrameworkCore",
            "Microsoft.AspNetCore")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```
