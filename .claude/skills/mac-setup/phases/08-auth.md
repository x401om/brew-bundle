# Phase 8 — Service auth checklist

Walk the user through OAuth / login flows for services Cortex and work depend on. Each step opens a browser; the user authorizes; we verify.

## Order matters

Some auths unlock others (1Password CLI unlocks YNAB; gh already done in Phase B).

## Idempotency check

For each service, run the "verify" command. Skip the ones that already pass.

## Steps

### 8.1 1Password CLI

```bash
# Verify desktop app is installed and CLI integration is on
op whoami
```

If fails → tell user: "Open 1Password.app → Settings → Developer → ✓ Integrate with 1Password CLI". Then retry.

### 8.2 Google personal account (gogcli)

```bash
gogcli auth list
# If x401om@gmail.com (alias `me`) not present:
gogcli auth add me --scopes calendar.readonly,gmail.readonly
# → opens browser → authorize → tokens stored in macOS Keychain
```

### 8.3 Google Adapty account (gogcli)

```bash
gogcli auth add work --scopes calendar.readonly,gmail.readonly
# → use agoncharov@adapty.io
```

Verify both:

```bash
gogcli calendar list --account me
gogcli calendar list --account work
```

### 8.4 gcloud

```bash
gcloud auth login
# → browser → authorize
gcloud config set project cortex-personal
```

### 8.5 Firebase

```bash
firebase login
# → browser → authorize Google account
```

### 8.6 Strava (Cortex skill)

The Strava OAuth tokens live in `~/.config/cortex/strava.json`. Re-create:

```bash
# Tell user to run /strava connect in Cortex (Obsidian) — it walks through OAuth
echo "Open Cortex (Obsidian) and run: /strava connect"
```

### 8.7 Slack workspaces

Manual — sign in via Slack.app:
- Adapty workspace
- Mindbots workspace (if applicable)

### 8.8 Cursor / Claude / Codex sign-ins

Manual:
- Open Cursor.app → sign in (Anthropic / Cursor account)
- Open Claude.app → sign in
- Open Codex.app → sign in
- `claude` CLI → auth prompt on first prompt

### 8.9 Xcode → Apple Developer account

Once Xcode is installed (phase 7):
- Xcode → Settings → Accounts → Add Apple ID
- Required for code signing, simulator certs, App Store Connect API

### 8.10 CocoaPods Trunk (only if publishing)

```bash
pod trunk register x401om@gmail.com 'Alexey Goncharov'
# → confirmation email, click link
```

## Completion

Mark phase 8 completed.
