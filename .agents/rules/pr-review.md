---
trigger: model_decision
description: Perform structured, severity-ranked code reviews on diffs, branches, or Pull Requests focusing on bugs, security, concurrency, compatibility, and tests.
---

# PR Review Rules

- Inspect the full diff and surrounding call sites before reporting findings.
- Audit correctness, security/authz, concurrency/cancellation, API/DB compatibility, performance, and test coverage.
- Rank findings by severity (Blocker, Major, Minor, Question) with exact `file:line` references and concrete fixes.
- Skip linter-level style nitpicks and end with a clear merge verdict.
- Activate the `pr-review` skill for the full checklist and output format.
