---
trigger: model_decision
description: Design, review, and evolve REST APIs and OpenAPI 3.1 specifications with RFC 9457 ProblemDetails, cursor pagination, idempotency, and backward compatibility.
---

# REST API & OpenAPI 3.1 Rules

- Use plural lowercase kebab-case resource URLs, accurate HTTP status codes, and RFC 9457 `application/problem+json` error responses.
- Never return unbounded lists — use object envelopes (`items`, `nextCursor`, `hasMore`) with a server-enforced `limit` cap.
- Support `Idempotency-Key` on state-changing `POST` endpoints and keep changes backward-compatible within a major version.
- Use OpenAPI 3.1 / JSON Schema 2020-12 (`type: ["string", "null"]`), unique `operationId`s, and explicit `4xx` schemas.
- Activate the `api-design-openapi` skill for copy-ready YAML and JSON patterns.
