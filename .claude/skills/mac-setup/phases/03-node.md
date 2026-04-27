# Phase 3 — Node (nvm + Node 22 + corepack + global CLIs)

Replace the bootstrap `brew install node` (from Phase B) with nvm-managed Node, install Node 22 LTS, enable corepack for pnpm, and reinstall global CLIs onto the nvm Node.

## Idempotency check

```bash
command -v nvm >/dev/null 2>&1 && \
nvm version default 2>/dev/null | grep -q "^v22\." && \
command -v claude >/dev/null 2>&1
```

If all pass → skip.

## Steps

### 3.1 Source nvm (it was installed via Brewfile in phase 2 but isn't in PATH yet)

```bash
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
```

(After phase 5 drops `.zshrc`, this happens automatically in new shells.)

### 3.2 Install Node 22 LTS and set as default

```bash
nvm install 22
nvm alias default 22
nvm use default
```

Verify:

```bash
node --version       # → v22.x.x
which node           # → ~/.nvm/versions/node/v22.x.x/bin/node
```

### 3.3 Enable corepack (built into Node 22) — for pnpm in project-eris

```bash
corepack enable
```

This makes `packageManager: pnpm@10.30.2` (declared in `project-eris/package.json`) auto-activate the right pnpm when you `cd` in.

### 3.4 Reinstall global CLIs on the nvm Node

The bootstrap `claude` was installed under `brew install node` — it's now stranded on a different Node. Reinstall:

```bash
npm install -g @anthropic-ai/claude-code firebase-tools
```

(Add other globals if needed: `vercel`, `netlify-cli`, etc. — but only what you use regularly.)

### 3.5 Remove the bootstrap brew node

`Brewfile` does **not** include `node` — but Phase B installed it manually. Remove it now:

```bash
brew uninstall node 2>/dev/null || true
```

Verify `which node` still resolves to `~/.nvm/.../node`.

## Completion

Mark phase 3 completed. Phase 4 (GPG import) is next.
