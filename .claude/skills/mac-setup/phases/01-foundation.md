# Phase 1 — Foundation

Verify the prerequisites that should already exist (from Phase B in the README) and lay down the git identity.

## Idempotency check

Skip this phase entirely if all of the following pass:

```bash
gh auth status >/dev/null 2>&1 && \
ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && \
[ -f ~/.gitconfig ] && grep -q "x401om@gmail.com" ~/.gitconfig
```

## Steps

### 1.1 Verify gh + ssh

```bash
gh auth status
ssh -T git@github.com
```

Expected output:
- `gh`: `✓ Logged in to github.com as x401om` and `Git operations protocol: ssh`
- `ssh`: `Hi x401om! You've successfully authenticated...`

If either fails, abort and tell the user to redo Phase B step 4 (`gh auth login`) before continuing.

### 1.2 Drop .gitconfig

The `dotfiles/.gitconfig` includes identity, GPG signing key id, LFS filter, and Sourcetree mergetool.

```bash
cp dotfiles/.gitconfig ~/.gitconfig
cp dotfiles/.gitignore_global ~/.gitignore_global
cp dotfiles/.stCommitMsg ~/.stCommitMsg
```

### 1.3 Verify git identity

```bash
git config --global user.name
git config --global user.email
git config --global user.signingkey
```

Expected:
- name: `Alexey Goncharov`
- email: `x401om@gmail.com`
- signingkey: `CE5189648157F28F`

## Completion

Mark phase 1 completed in state file. Tell user phase 2 (Brewfile) is next and confirm before starting.
