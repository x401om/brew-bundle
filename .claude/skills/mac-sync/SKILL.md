---
name: mac-sync
description: Periodically reconcile installed apps/CLIs with the tracked Brewfile, Masfile, Setappfile. Surfaces what's been added or removed since the last sync, lets the user decide keep/drop/ignore per item, then commits the curated changes. Triggered by "/mac-sync" or when user says "обнови brew-bundle", "что у меня нового стоит", "почистить bootstrap".
---

# /mac-sync — Bootstrap reconciliation

## Purpose

Over time the user installs new tools and stops using old ones. This skill keeps `Brewfile`/`Masfile`/`Setappfile` aligned with the user's actual Mac, with curation — not a blind dump.

## How to use it

When invoked (run from `~/repos/brew-bundle`):

1. **Snapshot current state** of brew formulas, casks, MAS apps, Setapp apps, npm globals.
2. **Diff against tracked files**.
3. **Show the user the additions and removals** as a table.
4. **Per item, ask: keep / drop / ignore.**
   - **keep** = add to tracked file (for additions) or do nothing (for removals — means user wants to reinstall it)
   - **drop** = remove from tracked file (for additions, means "I tried it once, don't want to bootstrap with it") or do nothing (for removals, means "I don't need this anymore")
   - **ignore** = mark in `.mac-sync-ignore` so this item doesn't surface again next sync
5. **Apply the curated changes** to `Brewfile`, `Masfile`, `Setappfile`.
6. **Commit + push** (after user confirmation).

## Detection commands

```bash
# Brew formulas (user-installed only, not deps)
brew leaves

# Brew casks
brew list --cask

# MAS
mas list   # format: <id> <name>  (<version>)

# Setapp
ls /Applications/Setapp/ 2>/dev/null | grep '\.app$' | sed 's/\.app$//'

# Global npm packages (excluding npm itself)
npm list -g --depth=0 --json 2>/dev/null | jq -r '.dependencies | keys[]' | grep -v '^npm$'

# Global gems (top-level user gems, skip system)
gem list --no-default
```

## Diff logic per file

### Brewfile

Track lines like `brew "name"` and `cask "name"`. Compare set of names with `brew leaves` + `brew list --cask`.

- **In Brewfile but not installed** = removal candidate (probably uninstalled manually). Ask: keep (re-install on next bootstrap) / drop (remove from Brewfile).
- **Installed but not in Brewfile** = addition candidate. Ask: keep (add to Brewfile) / drop (uninstall) / ignore (track in `.mac-sync-ignore`, leave installed).

### Masfile

Tracked: lines starting with digits (`1234567890  Name`). Compare ids with `mas list`.

### Setappfile

Tracked: non-comment lines = app names. Compare with `ls /Applications/Setapp/`.

## Ignore file

`.mac-sync-ignore` (committed, **not** in `.gitignore`):

```
# items intentionally not in Brewfile but installed
# format: <type>:<name>
brew:postgresql@14
cask:firefox
```

If something is in `.mac-sync-ignore`, don't surface it again.

## Output format for the user

Speak Russian. Show as a table:

```
Изменения с прошлого sync:

Brew formulas:
  + ripgrep        (новое)
  + jq             (новое)
  - asciidoctor    (удалено вручную)

Casks:
  + figma          (новое)

MAS:
  - WhatsApp       (удалено вручную)

Setapp:
  + TablePlus      (новое)
```

Then iterate item by item, asking decision.

## Apply

After all decisions:

1. Update `Brewfile`, `Masfile`, `Setappfile` with the curated changes.
2. Show diff:
   ```bash
   git diff Brewfile Masfile Setappfile .mac-sync-ignore
   ```
3. Ask user to confirm.
4. Commit:
   ```bash
   git add -A
   git commit -m "sync: <brief summary, e.g. 'add jq + figma, drop asciidoctor'>"
   ```
5. Ask user before pushing:
   ```bash
   git push
   ```

## Safety rules

- Never `brew uninstall` automatically — only print the command and let user run it.
- Never push without explicit confirmation.
- Never modify `.mac-sync-ignore` without asking.
