---
trigger: model_decision
description: Enforce Gitmoji commit conventions whenever staging, drafting, amending, or creating Git commits.
---

# Gitmoji Commit Rules

When creating or drafting Git commits, follow the [Gitmoji](https://gitmoji.dev) convention:

1. Inspect `git status --short`, `git diff --staged`, and `git log -n 5 --oneline` first. Match Unicode emoji (default) or shortcodes to repo history.
2. Use **one Gitmoji** matching the primary intent. Keep commits atomic.
3. Write an imperative, capitalized subject line (<= 50-72 chars, no trailing period).
4. Use `💥` + a `BREAKING CHANGE:` footer for breaking changes.
5. Never stage or commit secrets (`.env`, private keys, tokens).
6. Activate the `gitmoji-commit` skill for the full workflow and categorized Gitmoji reference.
