# Phase 6 — MAS apps + Setapp + manual GUI

Install Mac App Store apps from `Masfile`, then walk the user through a manual checklist for things that aren't on brew (Setapp suite, Firefoo, checkra1n, Collaborator).

## Idempotency check

For MAS:
```bash
brew list mas >/dev/null 2>&1 && \
mas account >/dev/null 2>&1
```

For manual: there's no good check — just print the checklist, let the user mark them done.

## Steps

### 6.1 Install mas

```bash
brew install mas
```

(Not in Brewfile because it's only used here once.)

### 6.2 Sign into App Store

Tell the user to open **App Store.app** and sign in with their Apple ID. (`mas signin` is broken on modern macOS.) Wait for confirmation.

### 6.3 Install MAS apps

```bash
awk '/^[ ]*[0-9]/ {print $1}' Masfile | while read id; do
    mas install "$id"
done
```

If any `mas install` fails with "could not find app" — open App Store, search the app once (this registers it on the account), retry.

### 6.4 Setapp (manual)

Print this checklist for the user:

```
1. Install Setapp:
   brew install --cask setapp     (or download from setapp.com)
2. Open Setapp.app, sign in
3. Install from Setapp catalog (one-by-one, or use Setapp's bulk install):
   - CleanMyMac
   - CleanShot X
   - Dato
   - NotePlan
   - Paste
   - Proxyman
   - Spark Mail
```

The list lives in `Setappfile`. Display its contents:

```bash
cat Setappfile
```

Wait for "done".

### 6.5 Manual GUI apps not on brew

Print this checklist:

```
- Firefoo:       https://firefoo.app/  (Firestore client, Pro license)
- checkra1n:     manual install (jailbreak — only when needed)
- Collaborator:  manual install (only when needed)
```

These don't block — the user can install later when needed. Don't wait for confirmation.

## Completion

Mark phase 6 completed.
