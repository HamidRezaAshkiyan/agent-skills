---
name: gitmoji-commit
description: >-
  Write and create Git commits using the Gitmoji convention (emoji prefix +
  concise imperative subject + optional body). Use whenever the user asks to
  commit changes, stage and commit, draft a commit message, amend a commit,
  or summarize staged git diffs into commit messages.
---

# Gitmoji Commit Skill

Create clean, atomic, scannable Git commits following the [Gitmoji](https://gitmoji.dev) specification.

## Workflow

1. **Inspect repository state** before writing any commit message:
   - Run `git status --short` and `git diff --staged` (or `git diff` if nothing is staged yet).
   - Check recent commit style with `git log -n 5 --oneline` to match whether the repo uses **Unicode emojis** (e.g., `✨`) or **shortcodes** (e.g., `:sparkles:`), and whether it uses optional scopes (e.g., `✨ (auth): ...`). Default to **Unicode emojis** without scope unless the repo history shows otherwise.
2. **Ensure atomic commits**:
   - If staged/unstaged changes span multiple unrelated concerns (e.g., a bug fix plus an unrelated refactor), suggest or stage them as separate focused commits rather than combining them.
3. **Select the single best Gitmoji** representing the *primary intent* of the change:
   - Use the quick-pick table below for common changes.
   - For less common categories (accessibility, i18n, database, security, CI, etc.), read `references/gitmoji-guide.md`.
4. **Format the commit message**:
   ```text
   <emoji> <imperative summary in <= 50-72 chars>

   <optional body explaining WHY, not just WHAT>

   <optional footer: BREAKING CHANGE / Closes #123>
   ```
5. **Execute the commit**:
   - Stage only the intended files (never blindly `git add -A` if untracked secrets, `.env`, or build artifacts exist).
   - Run `git commit -m "..."` (or pass multiple `-m` flags for subject + body).
   - Verify with `git status` and `git log -n 1`.

## Quick-Pick Gitmoji Table

| Emoji | Shortcode | When to use |
| :--- | :--- | :--- |
| ✨ | `:sparkles:` | Introduce a new feature |
| 🐛 | `:bug:` | Fix a bug |
| 🚑️ | `:ambulance:` | Critical hotfix |
| ♻️ | `:recycle:` | Refactor code (no behavior change) |
| ⚡️ | `:zap:` | Improve performance |
| 📝 | `:memo:` | Add or update documentation |
| 🎨 | `:art:` | Improve structure / format of code |
| 🔥 | `:fire:` | Remove code or files |
| ✅ | `:white_check_mark:` | Add, update, or pass tests |
| 🔒️ | `:lock:` | Fix security or privacy issues |
| 💄 | `:lipstick:` | Add or update UI and style files |
| 🔧 | `:wrench:` | Add or update configuration files |
| ⬆️ | `:arrow_up:` | Upgrade dependencies |
| ⬇️ | `:arrow_down:` | Downgrade dependencies |
| ➕ | `:heavy_plus_sign:` | Add a dependency |
| ➖ | `:heavy_minus_sign:` | Remove a dependency |
| 🚀 | `:rocket:` | Deploy stuff |
| 🎉 | `:tada:` | Begin a project |
| 🔖 | `:bookmark:` | Release / version tags |
| 🚧 | `:construction:` | Work in progress |
| 💥 | `:boom:` | Introduce breaking changes |
| 👷 | `:construction_worker:` | Add or update CI build system |
| 💚 | `:green_heart:` | Fix CI build |
| 🚨 | `:rotating_light:` | Fix compiler / linter warnings |
| 🚚 | `:truck:` | Move or rename resources (files, paths, routes) |
| 🔀 | `:twisted_rightwards_arrows:` | Merge branches |
| ⏪️ | `:rewind:` | Revert changes |
| 🩹 | `:adhesive_bandage:` | Simple fix for a non-critical issue |
| 🏷️ | `:label:` | Add or update types |

For the full categorized catalog (70+ gitmojis), consult `references/gitmoji-guide.md`.

## Formatting Rules

- **Imperative mood**: Write `✨ Add OAuth2 login` — not `Added`, `Adds`, or `Adding`.
- **Capitalize first word** after the emoji (or after optional scope): `🐛 Fix null reference in parser` or `🐛 (parser): Fix null reference`.
- **No trailing period** on the subject line.
- **Keep subject concise**: Aim for <= 50 characters (hard cap 72 characters).
- **One emoji per commit**: Never chain multiple emojis like `✨🐛♻️`. Pick the primary intent or split into multiple commits.
- **Breaking changes**: Use `💥` as the prefix and include a `BREAKING CHANGE:` footer describing migration steps.
- **Never commit secrets**: Abort and warn the user if `.env`, private keys, tokens, or credentials appear in the diff.

## Examples

```text
✨ Add passkey authentication support
```

```text
🐛 Prevent duplicate order submission on double-click

Disable the submit button while the checkout mutation is in flight and
enforce an idempotency key on the server endpoint.

Closes #412
```

```text
💥 Migrate API responses to OpenAPI 3.1 error format

BREAKING CHANGE: Validation failures now return RFC 9457 ProblemDetails
instead of `{ errors: string[] }`.
```
