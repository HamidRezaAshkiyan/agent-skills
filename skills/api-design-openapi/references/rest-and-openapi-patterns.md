# REST & OpenAPI 3.1 Patterns Reference

Copy-ready patterns for OpenAPI 3.1 specifications and HTTP API contracts.

---

## 1. RFC 9457 Problem Details Schema

```yaml
components:
  schemas:
    ProblemDetails:
      type: object
      required:
        - type
        - title
        - status
      properties:
        type:
          type: string
          format: uri
          example: https://api.example.com/errors/validation-failed
        title:
          type: string
          example: One or more validation errors occurred.
        status:
          type: integer
          example: 422
        detail:
          type: string
          example: The 'quantity' field must be between 1 and 100.
        instance:
          type: string
          example: /v1/orders
        traceId:
          type: string
          example: 00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01
        errors:
          type: object
          additionalProperties:
            type: array
            items:
              type: string
```

---

## 2. Cursor-Based Pagination Envelope

Request: `GET /v1/orders?limit=25&cursor=eyJpZCI6IjAxOTM...`

Response (`200 OK`):
```json
{
  "items": [
    {
      "id": "01935b1c-8a42-7f2a-9c10-6c4d1f2e3a4b",
      "status": "confirmed",
      "total": { "amount": "49.50", "currency": "USD" },
      "createdAt": "2026-11-24T00:30:00Z"
    }
  ],
  "nextCursor": "eyJpZCI6IjAxOTM1YjFjLThhNDItN2YyYSJ9",
  "hasMore": true
}
```

Guidelines:
- Treat `cursor` as an **opaque** Base64URL-encoded token (never document internal cursor structure as part of the public contract).
- Enforce a server-side `limit` cap (e.g., default `20`, max `100`).

---

## 3. Idempotent `POST` Endpoint (OpenAPI 3.1)

```yaml
openapi: 3.1.0
info:
  title: Orders API
  version: 1.0.0
paths:
  /v1/orders:
    post:
      operationId: createOrder
      summary: Create a new order
      parameters:
        - name: Idempotency-Key
          in: header
          required: true
          description: Unique client-generated UUID to safely retry requests.
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201':
          description: Order created
          headers:
            Location:
              description: Canonical URL of the created order
              schema:
                type: string
                format: uri
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderResponse'
        '409':
          description: Idempotency key reused with a different payload
          content:
            application/problem+json:
              schema:
                $ref: '#/components/schemas/ProblemDetails'
        '422':
          description: Validation error
          content:
            application/problem+json:
              schema:
                $ref: '#/components/schemas/ProblemDetails'
```

---

## 4. OpenAPI 3.1 vs 3.0 Key Differences

- **Nullable types**: OpenAPI 3.1 uses JSON Schema 2020-12 type arrays instead of `nullable: true`:
  ```yaml
  cancelledAt:
    type: ["string", "null"]
    format: date-time
  ```
- **Webhooks**: Top-level `webhooks:` section natively documents outbound webhook payloads.
- **Examples**: Prefer `examples` (JSON Schema array) over legacy single `example` where tooling supports it.

---

## 5. Deprecation & Versioning Headers

When deprecating an endpoint or version without breaking existing callers:
```http
Deprecation: true
Sunset: Sat, 01 Aug 2027 00:00:00 GMT
Link: <https://api.example.com/docs/migrations/v2>; rel="deprecation"
```
