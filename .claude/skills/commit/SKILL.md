---
name: commit
description: Create atomic, semantic git commits grouped by logical concern
allowed-tools: Bash, Read, Glob, Grep
---

Create atomic and semantic git commits for all uncommitted changes.

## Pre-flight

Run SwiftLint before committing. If there are violations, fix them first — do not commit with lint errors or warnings.

```sh
swiftlint
```

If SwiftLint is not installed, note it and continue.

## Steps

1. **Understand what changed**

   Run these in parallel:
   - `git status` — see all tracked and untracked files
   - `git diff` — see unstaged changes
   - `git diff --cached` — see already-staged changes
   - `git log --oneline -5` — understand the existing commit style on this branch

2. **Group changes by logical concern**

   Examine the files and decide how to group them into atomic commits. Good groupings:
   - One feature, fix, or refactor per commit
   - Config/tooling changes separate from source changes
   - Tests separate from the code they test (unless trivially coupled)
   - Documentation separate from code
   - Generated files (e.g. lock files, xcodeproj) together with the spec that produced them

   Do **not** bundle unrelated changes just because they're small.

3. **For each group, stage and commit**

   Stage only the files for that group, then commit with a message that follows this format:

   ```
   <type>(<optional scope>): <short imperative summary>

   <optional body — explain WHY, not just what. Include constraints,
   trade-offs, or context a future reader would need.>

   Co-Authored-By: Claude Sonnet 4.6 (1M context) <noreply@anthropic.com>
   ```

   **Types:** `feat` · `fix` · `chore` · `docs` · `test` · `refactor` · `style` · `perf`

   Rules:
   - Summary line ≤ 72 characters, imperative mood ("add X", not "added X")
   - Body explains _why_, not _what_ — the diff already shows what
   - Always include the `Co-Authored-By` trailer

4. **Verify**

   Run `git log --oneline` and confirm every change is accounted for with no leftover uncommitted files (ignoring intentionally untracked files).
