# Phase 5 — Dotfiles

Copy `.zshrc`, `.zprofile`, and re-source the shell so subsequent phases use the final environment.

## Idempotency check

```bash
diff -q dotfiles/.zshrc ~/.zshrc >/dev/null 2>&1 && \
diff -q dotfiles/.zprofile ~/.zprofile >/dev/null 2>&1
```

If both match → skip.

## Steps

### 5.1 Backup any existing dotfiles

```bash
ts=$(date +%Y%m%d-%H%M%S)
mkdir -p ~/.dotfiles-backup-$ts
for f in .zshrc .zprofile; do
    [ -f ~/$f ] && cp ~/$f ~/.dotfiles-backup-$ts/$f
done
```

### 5.2 Copy dotfiles in

```bash
cp dotfiles/.zshrc ~/.zshrc
cp dotfiles/.zprofile ~/.zprofile
# .gitconfig, .gitignore_global, .stCommitMsg already copied in phase 1
```

### 5.3 Verify nothing was lost

`.zprofile` might have had a `brew shellenv` line added by Phase B step 2. The dotfile version includes it too, so we're good. Confirm:

```bash
grep -q "brew shellenv" ~/.zprofile
```

### 5.4 Re-source

```bash
source ~/.zprofile
source ~/.zshrc
```

(Note: this only affects the current shell. New terminals will pick it up automatically.)

## Completion

Mark phase 5 completed. Tell user to restart their terminal at some point to pick up the new config cleanly.
