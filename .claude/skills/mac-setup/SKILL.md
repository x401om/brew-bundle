---
name: mac-setup
description: Drive a fresh Mac through 9 phases of bootstrap (brew, dotfiles, GPG, auth, repos). State persists across runs in .mac-setup-state.json. Triggered by "/mac-setup" or when user says "set up new mac", "продолжи установку мака", "переезд на новый мак".
---

# /mac-setup — Mac bootstrap driver

## Purpose

Bring a fresh Mac to a fully working dev environment by walking through 9 phases. State is persisted between runs so you can interrupt and resume.

## How to use it

When invoked:

1. **Read state.** Look for `<repo-root>/.mac-setup-state.json`. If missing, create it with `{"current_phase": 1, "completed": []}`.
2. **Show progress.** Print a one-line summary of what's done and what's next.
3. **Run the next pending phase.** Read the matching `phases/NN-*.md` file and follow it step by step.
4. **Be idempotent.** Each phase begins with a check — if everything is already done, mark it completed and move on without re-doing work.
5. **Update state.** After a phase finishes successfully, append it to `completed` and increment `current_phase`. Write back to `.mac-setup-state.json`.
6. **Stop after each phase.** Don't run multiple phases in one go. Print a summary, ask the user to confirm before starting the next.

## Phase index

| # | File | Title |
|---|---|---|
| 1 | `phases/01-foundation.md` | Foundation (gh, ssh, git identity) |
| 2 | `phases/02-brewfile.md` | Install Brewfile |
| 3 | `phases/03-node.md` | nvm + Node 22 + corepack + global CLIs |
| 4 | `phases/04-gpg.md` | Import GPG signing key from migration bundle |
| 5 | `phases/05-dotfiles.md` | Drop dotfiles into `~` |
| 6 | `phases/06-mas-gui.md` | MAS apps + Setapp + manual GUI checklist |
| 7 | `phases/07-per-domain.md` | iOS / Flutter / Web toolchains (user-selected) |
| 8 | `phases/08-auth.md` | Service auth (gcloud, gogcli, firebase, Strava, Slack, Xcode) |
| 9 | `phases/09-repos.md` | Clone repos from `repos.txt` |

## State file format

`<repo-root>/.mac-setup-state.json`:

```json
{
  "current_phase": 3,
  "completed": [1, 2],
  "domain_choices": {
    "ios": true,
    "flutter": true,
    "web": true
  },
  "notes": []
}
```

`.mac-setup-state.json` is in `.gitignore` — it's machine-local.

## Communication style

- Speak Russian to the user (per Cortex rule). Phase files are in English (so they read cleanly), but your messages to the user are in Russian.
- Be direct. Print what you're about to do, do it, print result, ask before next phase.
- If a step fails, surface the error clearly and ask user how to proceed. Don't paper over it.
- If a step is already done (idempotency check passes), say so and skip — don't re-run.

## Safety rules

- **Never** run destructive commands without explicit user confirmation (`rm -rf`, `git reset --hard`, etc.).
- **Never** push commits unless the user asks.
- For OAuth flows that open a browser, tell the user what's about to happen first.
- If a phase produces a long output (e.g. `brew bundle install`), let it run — don't truncate or interrupt.
