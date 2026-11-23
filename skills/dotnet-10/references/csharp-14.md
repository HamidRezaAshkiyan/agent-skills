# C# 14 Language Features Reference (.NET 10)

Concise, copy-ready patterns for C# 14. Default language version when `<TargetFramework>net10.0</TargetFramework>`.

---

## 1. The `field` Contextual Keyword (Field-Backed Properties)

Access the compiler-synthesized backing field directly inside `get` / `set` / `init` without declaring a manual `_backingField`.

```csharp
// Before (C# 13 and earlier)
private string _name = string.Empty;
public string Name
{
    get => _name;
    set => _name = string.IsNullOrWhiteSpace(value)
        ? throw new ArgumentException("Name is required.", nameof(value))
        : value.Trim();
}

// After (C# 14)
public string Name
{
    get;
    set => field = string.IsNullOrWhiteSpace(value)
        ? throw new ArgumentException("Name is required.", nameof(value))
        : value.Trim();
} = string.Empty;
```

> **Note:** If a class already has a member named `field`, disambiguate with `@field` (for the existing member) or `this.field`.

---

## 2. Extension Members (`extension(...)` Blocks)

Define **extension properties**, **extension methods**, **static extension members**, and **user-defined operators** inside a `static class` using `extension(...)` blocks.

### Instance Extension Members
```csharp
public static class EnumerableExtensions
{
    extension<T>(IEnumerable<T> source)
    {
        // Extension property -> items.IsEmpty
        public bool IsEmpty => !source.Any();

        // Extension method -> items.WhereNotNull()
        public IEnumerable<T> WhereNotNull() => source.Where(x => x is not null);
    }
}
```

### Static Extension Members & Operators
Omit the parameter name to extend the type itself:

```csharp
public static class EnumerableStaticExtensions
{
    extension<T>(IEnumerable<T>)
    {
        // Static extension property -> IEnumerable<int>.EmptySequence
        public static IEnumerable<T> EmptySequence => [];

        // Static extension method -> IEnumerable<int>.Combine(a, b)
        public static IEnumerable<T> Combine(IEnumerable<T> first, IEnumerable<T> second)
            => first.Concat(second);

        // User-defined operator -> first + second
        public static IEnumerable<T> operator +(IEnumerable<T> left, IEnumerable<T> right)
            => left.Concat(right);
    }
}
```

---

## 3. Null-Conditional Assignment (`?.=` / `?[]=`)

Assign to a property, field, or indexer only when the left-hand side is non-null. The right-hand side is **not evaluated** if the receiver is `null`.

```csharp
// Before
if (customer is not null)
{
    customer.Order = GetCurrentOrder();
    customer.LoyaltyPoints += 10;
}

// After (C# 14)
customer?.Order = GetCurrentOrder();
customer?.LoyaltyPoints += 10;
```

Works with compound assignments (`+=`, `-=`, `*=`, etc.) as well as `=`, but **not** with `++` or `--`.

---

## 4. First-Class Implicit `Span<T>` / `ReadOnlySpan<T>` Conversions

Arrays and spans convert implicitly in more contexts (method overload resolution, generic type inference, extension member receivers), reducing `.AsSpan()` noise while preserving zero-allocation performance.

```csharp
static bool StartsWithHeader(ReadOnlySpan<byte> payload) =>
    payload.StartsWith("HDR"u8);

byte[] buffer = GetBuffer();
bool ok = StartsWithHeader(buffer); // Implicit conversion to ReadOnlySpan<byte>
```

---

## 5. Modifiers on Simple Lambda Parameters

Use `ref`, `in`, `out`, `scoped`, or `ref readonly` on lambda parameters **without** repeating explicit parameter types.

```csharp
delegate bool TryParse<T>(string text, out T result);

// Before
TryParse<int> parse1 = (string text, out int result) => int.TryParse(text, out result);

// After (C# 14)
TryParse<int> parse2 = (text, out result) => int.TryParse(text, out result);
```

---

## 6. Unbound Generic Types in `nameof`

Use `nameof` with open/unbound generic types without dummy type arguments.

```csharp
string listName = nameof(List<>);         // "List"
string dictName = nameof(Dictionary<,>);  // "Dictionary"
```

---

## 7. `partial` Constructors and `partial` Events

Useful for source generators and interop layers that split declarations from generated implementations.

```csharp
public partial class OrderService
{
    public partial OrderService(ILogger<OrderService> logger);
    public partial event EventHandler? OrderPlaced;
}

public partial class OrderService
{
    private readonly ILogger<OrderService> _logger;
    private EventHandler? _orderPlaced;

    public partial OrderService(ILogger<OrderService> logger) => _logger = logger;

    public partial event EventHandler? OrderPlaced
    {
        add => _orderPlaced += value;
        remove => _orderPlaced -= value;
    }
}
```

---

## 8. User-Defined Compound Assignment Operators

Types can define `operator +=`, `operator -=`, etc. directly to mutate in place (avoiding extra allocations for large structs or tensors/vectors).

```csharp
public struct Counter(int value)
{
    public int Value { get; private set; } = value;

    public void operator +=(int delta) => Value += delta;
}
```
