# Global Instructions

You're working with Josh — a founder and principal-level engineer. He ships
full-stack TypeScript/Node: Cloudflare (Workers, Hono, D1, Drizzle, Pages),
React, and Node services, with the occasional Go/Python/Rust. Adapt to
whatever project you're in; match it rather than imposing a house style.

## Working style

- **KISS.** Small functions, clear intent. Boring and obvious beats clever.
- **Read before writing.** Explore the relevant code and match existing
  patterns, naming, and architecture — don't introduce new ones unprompted.
- **Small, atomic commits.** Each one leaves the tree in a working state.
- **Let errors bubble** to one high-level handler. Don't swallow failures in
  silent try/catch fallbacks.
- **Don't abstract early.** Duplication is cheaper than the wrong abstraction;
  wait until the pattern is real.
- **Be direct and concise.** Lead with a recommendation and why. State your
  assumption and proceed — don't block on small decisions.
- Never mention Claude/AI in commit messages or PR descriptions.

## Toolchain — always respect

- **Package manager: detect, never guess.** `pnpm-lock.yaml` → pnpm ·
  `yarn.lock` → yarn · `package-lock.json` → npm · `bun.lockb` → bun. Run every
  install and script through that manager only.
- **Versions via mise.** If `.mise.toml` / `mise.toml` / `.tool-versions`
  exists, use the pinned toolchain (`mise install`, `mise exec -- …`). Don't
  hand-install global language runtimes.

## New work → worktree first

Before starting any new unit of work that writes code (feature, fix,
experiment, ticket) — i.e. anything outside plan or read-only mode — set up an
isolated worktree first and work there. This is the default: briefly say you're
creating one and go ahead, don't make Josh ask.

Use `new-worktree` (on PATH at `~/.local/bin`):

```
new-worktree <repo-dir> <branch> [base-ref]
```

It creates a sibling worktree named `<repo>-<id>`, symlinks the source
checkout's git-ignored `.env*` files into it, and installs deps for every
lockfile found (pnpm/yarn/npm, per lockfile). `base-ref` defaults to
`origin/main` — pass `origin/master` for repos whose default is master. If
`new-worktree` isn't available, fall back to `git worktree add`, link/copy the
`.env*` files, and install deps yourself.

Skip the worktree when: continuing in-progress work on the current branch,
amending an open PR, already inside a worktree, making a trivial edit, or just
answering questions. Tear down with `git worktree remove <dir>`.

## Safety

- Never commit `.env`, secrets, or credentials; never print their contents.
- Never force-push or rebase shared branches (main/master/develop) without an
  explicit OK.
- For deletes, infra (terraform), or CI changes touching more than a few
  files, summarise what will change and confirm before proceeding.
