# Phase 2 — Brewfile

Install all formulas and casks from `Brewfile`. This is the longest phase (15–30 min on a fresh Mac).

## Idempotency check

```bash
brew bundle check --verbose --file=Brewfile
```

If output is `The Brewfile's dependencies are satisfied.` → skip phase, mark completed.

## Steps

### 2.1 Pre-check disk space

```bash
df -h /                                     # need at least 10 GB free
```

If less than 10 GB free, warn the user.

### 2.2 Install

```bash
brew bundle install --file=Brewfile
```

This will:

- Add taps: `homebrew/bundle`, `xcodesorg/made`, `leoafarias/fvm`, `tw93/tap`
- Install ~15 formulas (CLI tools)
- Install ~23 casks (GUI apps)

Some casks may prompt for the admin password — that's normal.

### 2.3 Post-install — common gotchas

```bash
# 1Password CLI: enable desktop integration
# Open 1Password.app → Settings → Developer → "Integrate with 1Password CLI" ✓
# This is required for `op` to authenticate via Touch ID.

# pinentry-mac for GPG (used by GPG signing in phase 4)
mkdir -p ~/.gnupg
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
chmod 700 ~/.gnupg
```

### 2.4 Verify

```bash
brew bundle check --verbose --file=Brewfile
# Expected: The Brewfile's dependencies are satisfied.
```

## Completion

Mark phase 2 completed. Note: the Mac may need a logout/login for some casks (especially BetterDisplay, Lunar) to work properly. Tell user this can be deferred.
