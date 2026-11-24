---
name: adr-writer
description: >-
  Write, update, or supersede Architecture Decision Records (ADRs) in Markdown
  using a clear MADR-inspired structure (Context, Decision, Alternatives
  Considered, Consequences). Use when choosing a database, framework, messaging
  broker, authentication strategy, major refactoring, or when the user asks to
  document an architectural decision.
---

# Architecture Decision Record (ADR) Writer Skill

Capture significant technical decisions as lightweight, version-controlled Markdown files so future engineers and AI agents understand *why* the system is built the way it is.

## Workflow

1. **Locate existing ADRs**:
   - Check common directories: `docs/adr/`, `docs/decisions/`, `adr/`, or `architecture/decisions/`.
   - If an ADR directory exists, match its numbering scheme (`0001-`, `001-`, etc.), naming convention, and template style.
   - If none exists, default to `docs/adr/0001-<kebab-case-title>.md` (and optionally create `docs/adr/README.md` as an index).
2. **Determine next sequence number**:
   - Find the highest existing ADR number and increment by 1, zero-padded to 4 digits (e.g., `0004-use-postgresql-for-orders.md`).
3. **Gather context before drafting**:
   - Inspect relevant code, config files, and existing ADRs to avoid contradicting prior decisions.
   - If the new decision replaces an older ADR, note `Supersedes ADR-XXXX` and update the old ADR's status to `Superseded by ADR-YYYY`.
4. **Draft the ADR**:
   - Load `references/adr-template.md` for the complete template and quality criteria.
   - Keep it concise (1–2 pages max), objective, and focused on **trade-offs and rationale**, not implementation step-by-step tutorials.
5. **Update the index** (if `docs/adr/README.md` exists) with a new row linking to the ADR.

## Required Sections

- **Metadata**: Status (`Proposed` | `Accepted` | `Deprecated` | `Superseded by ADR-XXXX`), Date (`YYYY-MM-DD`), Deciders (optional), Supersedes (optional).
- **Context & Problem Statement**: What forces, constraints, or requirements necessitate a decision *now*?
- **Decision Drivers**: 3–5 concrete criteria (e.g., latency SLA, team familiarity, operational cost, compliance).
- **Decision**: Clear, active-voice statement of what was chosen ("We will use...").
- **Alternatives Considered**: At least 2 realistic alternatives with honest pros/cons and why each was rejected.
- **Consequences**: Positive outcomes, negative trade-offs / risks, and mitigation or follow-up actions.

## Quality Guardrails

- **Immutable history**: Never silently rewrite an `Accepted` ADR when changing direction — write a new ADR that supersedes it.
- **No strawman alternatives**: Give every rejected option a fair assessment of its strengths.
- **Concrete, not vague**: Avoid "better performance" or "more scalable" without specifying *what* scales or *which* bottleneck matters.
- **Keep code minimal**: Include small schema/API snippets only if they clarify the architectural boundary.
