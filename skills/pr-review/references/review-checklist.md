# PR Review Checklist Reference

Consult this checklist during step 3 of the `pr-review` workflow. Only report items that genuinely apply to the diff.

## 1. Correctness & Edge Cases
- [ ] Null / `undefined` / empty collections / zero / negative values handled safely.
- [ ] Error paths do not silently swallow exceptions or leave partial state behind.
- [ ] Timezones, UTC vs. local time, and floating-point vs. `decimal` money math are correct.
- [ ] Off-by-one boundaries in pagination, slicing, retries, or date ranges.
- [ ] State transitions validate preconditions (cannot double-submit, double-charge, or transition from terminal states).

## 2. Security & Privacy
- [ ] Authorization checked at the resource level (prevents IDOR / cross-tenant access), not just authentication.
- [ ] User input validated and parameterized (no SQL/command/template injection, path traversal, or open redirects).
- [ ] No secrets, tokens, API keys, or PII leaked in code, logs, error responses, or committed config files.
- [ ] External webhooks/callbacks verify signatures and enforce timeouts.

## 3. Concurrency, Async & Resource Management
- [ ] `CancellationToken` (or `AbortSignal` / `context.Context`) propagated through I/O calls.
- [ ] No blocking on async code (`.Result`, `.Wait()`) or unobserved fire-and-forget tasks.
- [ ] Shared mutable state is properly synchronized or avoided; DB updates handle optimistic concurrency where needed.
- [ ] Streams, connections, HTTP clients, file handles, and timers are properly disposed/closed.

## 4. API & Database Compatibility
- [ ] Public API changes are backward-compatible (no removed/renamed fields or changed types without versioning).
- [ ] Database migrations are safe for zero-downtime deploys (avoid destructive drops/renames in the same release as code changes; watch for table locks on large tables).
- [ ] Default values and feature flags degrade safely on rollback.

## 5. Performance & Scalability
- [ ] No N+1 database queries or unbounded `ToList()` / `SELECT *` on growing tables.
- [ ] Appropriate indexes exist for new filter/sort columns.
- [ ] Large payloads are streamed or paginated rather than buffered entirely in memory.
- [ ] Caching has clear invalidation / TTL and avoids cache stampedes.

## 6. Testing & Observability
- [ ] New behavior and bug fixes have targeted tests covering both happy path and failure/edge cases.
- [ ] Tests assert behavior, not brittle internal implementation details.
- [ ] Structured logging and metrics provide enough context to diagnose failures without logging sensitive data.
