---
name: api-design-openapi
description: >-
  Design, review, and evolve consistent REST APIs and OpenAPI 3.1
  specifications. Covers resource-oriented URLs, RFC 9457 ProblemDetails
  errors, cursor-based pagination, idempotency keys, versioning, and
  backward-compatible schema evolution. Use when designing new HTTP endpoints,
  writing OpenAPI YAML/JSON specs, or reviewing API DTOs and contracts.
---

# REST API Design & OpenAPI 3.1 Skill

Design predictable, evolvable HTTP APIs with clean OpenAPI 3.1 contracts that work seamlessly with code generators, gateways, and client SDKs.

## Core Design Principles

1. **Resource-oriented URLs**:
   - Use plural nouns in lowercase kebab-case: `/v1/orders`, `/v1/order-items/{itemId}`.
   - Avoid verbs in paths (`/getOrders`, `/createUser`). Use HTTP methods (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`) for standard CRUD; reserve sub-resource actions (`/v1/orders/{id}/cancel`) only for non-CRUD state transitions.
2. **Accurate HTTP status codes**:
   - `200 OK` (reads, updates returning representation), `201 Created` (with `Location` header), `202 Accepted` (async jobs), `204 No Content` (deletes / empty updates).
   - `400 Bad Request` (malformed syntax), `401 Unauthorized` (missing/invalid auth), `403 Forbidden` (insufficient permissions), `404 Not Found`, `409 Conflict` (state conflict / duplicate), `422 Unprocessable Content` (semantic validation errors), `429 Too Many Requests` (with `Retry-After`).
3. **Standardized errors (RFC 9457 Problem Details)**:
   - Return `application/problem+json` with `type`, `title`, `status`, `detail`, `instance`, and structured `errors` for validation failures. Never leak stack traces or internal SQL errors.
4. **Pagination, filtering & sorting**:
   - Never return unbounded lists. Default to **cursor-based pagination** (`cursor`, `limit` with sensible default and hard max) for large or frequently mutated collections; use offset pagination only for small admin tables that require random page jumps.
   - Return an envelope (`{ "items": [...], "nextCursor": "..." }`) rather than a raw top-level JSON array so metadata can be added without breaking clients.
5. **Idempotency & Concurrency**:
   - Support an `Idempotency-Key` header on state-changing `POST` endpoints (payments, order creation, bookings).
   - Use `ETag` / `If-Match` for optimistic concurrency on updates (`412 Precondition Failed` on stale writes).
6. **Backward-compatible evolution**:
   - Additive changes only within a major version (adding optional fields, new endpoints, new enum values clients tolerate).
   - Never remove, rename, or change the type/nullability of existing fields without a new version or a documented deprecation window (`Deprecation` + `Sunset` headers).

## Detailed Patterns & OpenAPI 3.1 Reference

For concrete JSON payloads, OpenAPI 3.1 YAML snippets (RFC 9457, cursor pagination, idempotency, security schemes), and schema hygiene rules, read `references/rest-and-openapi-patterns.md`.

## Contract Review Checklist

- Every endpoint has a unique `operationId`, concise `summary`, explicit request/response schemas, and documented `4xx` error responses (`ProblemDetails`).
- Timestamps use ISO-8601 UTC (`2026-11-24T00:00:00Z`), durations use ISO-8601 or explicit units (`timeoutSeconds`), and money uses integer minor units or decimal + ISO-4217 currency code (`{ "amount": "19.99", "currency": "EUR" }`).
- Sensitive fields (passwords, tokens, secrets) are write-only (`writeOnly: true`) and never returned in responses or logged.
- IDs are opaque strings or UUIDv7 (avoid exposing sequential auto-increment integers publicly when enumeration is a risk).
