---
name: feature-branch
description: Create a feature branch from the latest trunk
allowed-tools: Bash, AskUserQuestion
---

Create a new feature branch from an up-to-date `trunk`. The branch name is derived from what you're about to work on.

## Steps

1. **Confirm current state**

   Run in parallel:
   - `git status` — make sure there are no uncommitted changes (warn the user and stop if there are)
   - `git branch --show-current` — note the current branch

2. **Switch to trunk and pull latest**

   ```sh
   git checkout trunk
   git pull --ff-only origin trunk
   ```

   If `--ff-only` fails (trunk has diverged), stop and tell the user — do not force-merge.

3. **Derive a branch name**

   Use the args passed to this skill (i.e. what the user said they want to work on) to create a short, lowercase, hyphen-separated branch name. Strip articles and filler words. Keep it under 40 characters.

   Examples:
   - "add expiration date picker to KitchenItem detail" → `feat/expiration-date-picker`
   - "fix crash when household has no items" → `fix/household-no-items-crash`
   - "refactor CoreData stack into its own file" → `refactor/coredata-stack`
   - "update README with build instructions" → `docs/readme-build-instructions`

   Use the conventional-commit type as a prefix (`feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`).

4. **Create and switch to the branch**

   ```sh
   git checkout -b <branch-name>
   ```

5. **Confirm**

   Tell the user:
   - The branch name that was created
   - That they are now on it and ready to work
   - That trunk is at the commit it was pulled to (show the short SHA and message)
