# ADR Template (MADR-Inspired)

Use this template when creating a new Architecture Decision Record (e.g., `docs/adr/0001-short-kebab-title.md`).

```markdown
# ADR-0001: <Short, Imperative Title>

- **Status:** Proposed | Accepted | Deprecated | Superseded by [ADR-XXXX](./XXXX-title.md)
- **Date:** YYYY-MM-DD
- **Deciders:** <Team or owners>
- **Supersedes:** <Link to prior ADR, or omit if N/A>

## Context and Problem Statement

Describe the technical or business problem in 2–4 sentences. Include current constraints (traffic, team size, compliance, existing stack) that shape the decision.

## Decision Drivers

- <Driver 1, e.g., Sub-50ms p99 read latency>
- <Driver 2, e.g., Zero-downtime schema evolution>
- <Driver 3, e.g., Minimal operational overhead for a 4-person team>

## Decision

We will adopt **<chosen option>** because <1–2 sentence core rationale>.

## Alternatives Considered

### Option A: <Chosen Option> *(Selected)*
- **Pros:**
  - ...
- **Cons:**
  - ...

### Option B: <Alternative 1>
- **Pros:**
  - ...
- **Cons:**
  - ...
- **Why not chosen:** <Concrete reason tied to decision drivers>

### Option C: <Alternative 2 / Do Nothing>
- **Pros:**
  - ...
- **Cons:**
  - ...
- **Why not chosen:** <Concrete reason tied to decision drivers>

## Consequences

### Positive
- ...

### Negative / Trade-offs
- ...

### Follow-ups & Mitigations
- [ ] <Actionable follow-up, e.g., Add monitoring alert for replication lag>

## References

- <Links to RFCs, benchmarks, docs, or PRs>
```

---

## Optional Index (`docs/adr/README.md`)

```markdown
# Architecture Decision Records

| ID | Title | Status | Date |
| :--- | :--- | :--- | :--- |
| [0001](./0001-example-decision.md) | Example Decision | Accepted | YYYY-MM-DD |
```
