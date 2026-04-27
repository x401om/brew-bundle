# brew-bundle — Aleksei's Mac bootstrap

Everything needed to bring a fresh Mac to a fully working dev environment for:

- **iOS** — Adapty SDK, devtools, gallery, native apps
- **Flutter** — Adapty Flutter SDK, Twins, side projects
- **Web / Capacitor** — project-eris (pnpm + turbo + Vite)
- **Backend** — Firebase Cloud Functions (TypeScript)

The hard parts (`brew bundle`, dotfiles, repos clone, OAuth flows) are automated by the `/mac-setup` skill that lives in this repo. You only do ~10 manual commands before launching it.

---

## Phase A — On the OLD Mac (5 min, before migration)

The only thing that can't be re-generated on the new Mac is the **GPG signing key** (id: `CE5189648157F28F`). Export it before reset.

```bash
mkdir -p ~/Desktop/migration

# Export GPG private key + ownertrust
gpg --export-secret-keys --armor CE5189648157F28F > ~/Desktop/migration/gpg-private.asc
gpg --export-ownertrust > ~/Desktop/migration/gpg-trust.txt

# Make sure the latest Brewfile is pushed
cd ~/repos/brew-bundle
brew bundle dump --force                # snapshot current state into Brewfile
git diff Brewfile                        # review changes
git add -A && git commit -m "snapshot before migration"
git push
```

**Transfer:** AirDrop the `~/Desktop/migration/` folder to the new Mac. It contains 2 small files (~10 KB).

---

## Phase B — On the NEW Mac (10–15 min, manual)

Fresh macOS, just past the setup assistant (Apple ID, iCloud, Wi-Fi, FileVault on).

Open **Terminal.app** (built-in) and run:

```bash
# 1. Xcode Command Line Tools (needed for git, Homebrew, everything)
xcode-select --install
# → GUI dialog → "Install" → wait 5–10 min
```

```bash
# 2. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH for login shells
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

```bash
# 3. Minimum tools to bootstrap further
brew install gh node
```

### 4. SSH key + GitHub auth (one command, generates fresh key)

```bash
gh auth login
```

Answer the prompts:

| Prompt | Answer |
|---|---|
| `What account do you want to log into?` | **GitHub.com** |
| `What is your preferred protocol for Git operations?` | **SSH** |
| `Generate a new SSH key to add to your GitHub account?` | **Yes** |
| `Enter a passphrase for your new SSH key` | empty (Enter) or set one |
| `Title for your SSH key` | e.g. `MacBook 2026` |
| `How would you like to authenticate GitHub CLI?` | **Login with a web browser** |
| `Copy your one-time code: XXXX-XXXX` | copy → Enter → browser opens → authorize |

**What this does automatically:**

- Generates `~/.ssh/id_ed25519` + `id_ed25519.pub`
- Uploads the public key to your GitHub account
- Logs `gh` in for API operations
- Configures git to use SSH

Verify:

```bash
ssh -T git@github.com
# → Hi x401om! You've successfully authenticated...

gh auth status
# → ✓ Logged in to github.com as x401om
# → ✓ Git operations protocol: ssh
```

### 5. Clone this repo and launch the setup skill

```bash
gh repo clone x401om/brew-bundle ~/repos/brew-bundle
cd ~/repos/brew-bundle

npm install -g @anthropic-ai/claude-code

claude
```

Inside Claude:

```
/mac-setup
```

The skill takes over from here.

---

## Phase C — Inside `/mac-setup` (the skill drives)

State is persisted in `.mac-setup-state.json` (gitignored). If you stop and re-run `/mac-setup`, it picks up where it left off.

| Phase | What happens | Manual touch |
|---|---|---|
| 1. Foundation | verifies `gh`, `ssh`, drops `.gitconfig` from `dotfiles/` into `~` | none if already done in Phase B |
| 2. Brewfile | `brew bundle install` (formulas + casks) | wait 15–30 min |
| 3. nvm + Node 22 | install nvm, Node 22 LTS, `nvm alias default 22`, reinstall Claude Code on the nvm node, `corepack enable` | none |
| 4. GPG import | imports `~/Downloads/migration/gpg-private.asc` + ownertrust, sets ultimate trust | "is the bundle in place? (y/n)" |
| 5. Dotfiles | copies `.zshrc`, `.zprofile`, `.gitignore_global`, `.stCommitMsg` from `dotfiles/` into `~`, sources `.zshrc` | none |
| 6. MAS + manual GUI | `mas signin`, installs from `Masfile`, prints checklist for Setapp / Firefoo / checkra1n / Collaborator | sign into Setapp.app |
| 7. Per-domain | only what you need: `xcodes install <ver>`, `swiftly init`, `fvm install <vers>`, etc. | choose chunks |
| 8. Service auth | walks through `gcloud auth login`, `gogcli auth me/work`, `firebase login`, Strava OAuth, Slack, Cursor, Xcode → Apple ID | each flow opens a browser |
| 9. Repos | clones from `repos.txt` into `~/repos/` | confirm list |

---

## Files in this repo

| File | Purpose |
|---|---|
| `Brewfile` | formulas + casks (source of truth) |
| `Masfile` | Mac App Store apps |
| `Setappfile` | Setapp catalog checklist (manual install) |
| `repos.txt` | repos to clone (must / on-demand) |
| `dotfiles/` | `.zshrc`, `.zprofile`, `.gitconfig`, `.gitignore_global`, `.stCommitMsg` |
| `.claude/skills/mac-setup/` | the bootstrap skill (drives Phase C) |
| `.claude/skills/mac-sync/` | run periodically to diff current state vs tracked Brewfile/Masfile/etc. |
| `generate-versions.sh` | snapshot installed package versions into `VERSIONS.md` |

---

## Keeping the repo fresh

Run `/mac-sync` from time to time (e.g. monthly). It will:

1. `brew bundle dump --force` and diff against tracked `Brewfile`
2. `mas list` and diff against `Masfile`
3. `ls /Applications/Setapp/` and diff against `Setappfile`
4. `npm list -g --depth=0` and diff against tracked globals
5. Ask you per added/removed item: keep / drop / ignore
6. Commit + push the curated changes

This way the bootstrap stays in sync with your real environment, without dragging in everything you tried once.
