# Phase 9 — Clone repos

Read `repos.txt` and clone all "must-clone" entries into `~/repos/<dirname>`.

## Idempotency check

For each entry, if `~/repos/<dirname>` already exists and is a git repo → skip.

## Steps

### 9.1 Show the user the planned list

```bash
echo "Will clone these repos into ~/repos/:"
grep -E '^[^#].*\S' repos.txt | awk '{printf "  %s → %s\n", $1, $2}'
```

Ask: "Continue? (y/n)" — if no, abort phase.

### 9.2 Clone each

```bash
mkdir -p ~/repos
while IFS= read -r line; do
    # skip comments and empty
    case "$line" in ''|'#'*) continue;; esac
    repo=$(echo "$line" | awk '{print $1}')
    dir=$(echo "$line" | awk '{print $2}')
    target=~/repos/$dir
    if [ -d "$target/.git" ]; then
        echo "✓ exists: $dir"
        continue
    fi
    echo "→ cloning $repo to $dir"
    gh repo clone "$repo" "$target" || echo "✗ failed: $repo"
done < repos.txt
```

### 9.3 Recreate adapty-sdk-workspace (if user uses it)

This is a local Xcode/SwiftPM workspace, no remote. After cloning the SDKs, the user can recreate it manually:

```bash
mkdir -p ~/repos/adapty-sdk-workspace
# user opens Xcode, creates workspace, drag-drops sibling SDK folders
```

### 9.4 Drop `.nvmrc=22` into repos that need pinning

These node-using repos don't pin their Node version — drop a `.nvmrc` (committed change, but only for repos owned by the user):

```bash
# Only for repos where the user is the owner — otherwise this needs a PR
for r in twins-back cosmic-back mindbots-operations; do
    if [ -d ~/repos/$r ] && [ ! -f ~/repos/$r/.nvmrc ]; then
        echo "22" > ~/repos/$r/.nvmrc
        echo "  → ~/repos/$r/.nvmrc=22 (commit when convenient)"
    fi
done
```

(For `universal-gallery` — adaptyteam org, requires PR. Skip auto-write, just print a reminder.)

### 9.5 Run a sanity install in the most active repo

```bash
cd ~/repos/project-eris && pnpm install
```

If this works without errors, the whole web stack is good.

## Completion

Mark phase 9 completed. Phase 9 is the last one — congratulate the user, suggest running `/mac-sync` periodically.
