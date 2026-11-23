---
trigger: model_decision
description: Write, update, or supersede Architecture Decision Records (ADRs) when documenting significant technical or architectural choices.
---

# ADR Writer Rules

- Store ADRs in `docs/adr/NNNN-kebab-case-title.md` (or match the repository's existing ADR directory).
- Include Status, Date, Context, Decision Drivers, Decision, Alternatives Considered (with fair pros/cons), and Consequences.
- Never silently rewrite an `Accepted` ADR — create a superseding ADR and cross-link both.
- Activate the `adr-writer` skill for the full template and workflow.
