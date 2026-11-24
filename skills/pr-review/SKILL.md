---
name: pr-review
description: >-
  Perform a structured, high-signal code review on a Git diff, branch, or Pull
  Request. Evaluates correctness, edge cases, security, concurrency, API
  compatibility, performance, and test coverage, returning findings ranked by
  severity. Use whenever the user asks to review a PR, review changes, audit a
  branch, or check code before merging.
---

# Pull Request Review Skill

Deliver thorough, constructive, low-noise code reviews that catch real bugs and architectural risks without nitpicking style that linters should handle.

## Workflow

1. **Gather the full diff & context**:
   - For a local branch: run `git diff main...HEAD` (or the target base branch) and `git log main..HEAD --oneline`.
   - For staged/unstaged work: run `git diff --staged` and `git diff`.
   - For a GitHub PR (if `gh` is available): run `gh pr view <num>` and `gh pr diff <num>`.
   - Read surrounding code for modified functions when diff context alone is insufficient to verify callers, invariants, or error handling.
2. **Understand intent first**:
   - Summarize what the change is trying to accomplish in 1–2 sentences before critiquing details.
3. **Audit systematically** using `references/review-checklist.md`:
   - Correctness & edge cases (nulls, empty collections, boundaries, off-by-one, error paths)
   - Security & data safety (authz/IDOR, injection, secret leaks, input validation)
   - Concurrency & lifecycle (`CancellationToken`, async/await deadlocks, race conditions, resource disposal)
   - Backward compatibility & migrations (API contracts, DB schema safety, feature flags)
   - Performance (N+1 queries, unbounded loops/allocations, missing pagination/indexes)
   - Tests (are critical paths and regressions actually tested?)
4. **Report findings clearly** ranked by severity:
   - **🔴 Blocker** — Must fix before merge (bugs, data loss, security vulnerabilities, breaking changes).
   - **🟠 Major** — Strong recommendation (edge cases, performance regressions, missing tests for core logic, maintainability risks).
   - **🟡 Minor / Suggestion** — Optional improvement (clarity, simplification, idiomatic API usage).
   - **❓ Question** — Clarifying intent or assumptions without assuming the author is wrong.

## Output Format

```markdown
## Review Summary
<1–2 sentence summary of the PR and overall verdict: Approve / Approve with comments / Request changes>

## Findings

### 🔴 Blockers
- **`path/to/file.cs:42`** — <Concise issue description>.
  **Why:** <Concrete failure mode or impact>.
  **Fix:** <Specific, minimal code suggestion>.

### 🟠 Major
- ...

### 🟡 Minor / Suggestions
- ...

### ❓ Questions
- ...

## Verification & Test Coverage
- <Note what is well-tested and any missing test scenarios>
```

## Review Principles

- **Verify before claiming**: Never flag a bug without confirming the surrounding types, nullability, or call sites.
- **Concrete fixes over vague criticism**: Show *how* to fix it, not just *what* is wrong.
- **Skip formatter noise**: Do not comment on indentation, import order, or trivial naming unless it causes genuine confusion.
- **Call out good work**: Briefly acknowledge clean designs or thorough tests when warranted.
