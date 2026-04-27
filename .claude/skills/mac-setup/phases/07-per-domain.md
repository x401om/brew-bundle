# Phase 7 — Per-domain toolchains

Install only the toolchains the user actually needs. Ask once, store the answers in state under `domain_choices`.

## Domain matrix

| Domain | What's needed | Repos served |
|---|---|---|
| **iOS** | Xcode (via xcodes), swiftly, CocoaPods, fastlane (already in Brewfile) | ios-sdk, adapty-swift-app, universal-gallery, universal-devtool, ios-devtools, twins-ios, project-eris (Capacitor iOS) |
| **Flutter** | FVM (already in Brewfile), Flutter SDK versions per project | flutter-sdk, twins-flutter, twins-admin, glamai, tea-flutter |
| **Web** | corepack/pnpm (done in phase 3), turbo (auto-installed by project-eris) | project-eris, twins-back, cosmic-back, mindbots-operations |
| **Android** | (skipped — user said not needed for now) | — |

## Idempotency check

For each domain, if the relevant tools already exist, skip that domain.

## Steps

### 7.1 Ask which domains to set up

Ask the user (Russian): "Какие домены настраиваем? iOS / Flutter / Web (Android пока скип)?"

Store choices in `state.domain_choices`.

### 7.2 iOS domain

If `domain_choices.ios` is true:

```bash
# Xcode — install latest stable via xcodes (this takes 30-60 min, very large download)
# DO NOT auto-run — show command and ask user to run when ready
echo "Run when ready: xcodes install --latest"
echo "Or pick a specific version: xcodes install 16.2"

# swiftly — Swift toolchain manager (for projects on alternate Swift versions)
curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash
# Restart shell, then:
swiftly install latest

# CocoaPods is already installed via Brewfile
pod --version

# Trunk auth (only needed when publishing pods)
echo "If you publish pods: pod trunk register x401om@gmail.com 'Alexey Goncharov'"
```

### 7.3 Flutter domain

If `domain_choices.flutter` is true:

Read the active Flutter repos and find their declared Flutter versions:

```bash
for r in twins-flutter twins-admin flutter-sdk; do
    f=~/repos/$r/.fvmrc
    [ -f "$f" ] && echo "$r → $(cat $f)"
done
```

Install the unique versions found, plus latest stable:

```bash
fvm install stable
# fvm install <version>  per .fvmrc
```

Set a default:

```bash
fvm global stable
```

Note: Android Studio is **not** installed (user opted out). Flutter projects will only build for iOS until Android Studio is added.

### 7.4 Web domain

If `domain_choices.web` is true:

corepack was enabled in phase 3 — pnpm will auto-activate. Just sanity-check:

```bash
cd ~/repos/project-eris 2>/dev/null && {
    corepack prepare --activate
    pnpm --version
}
```

If `~/repos/project-eris` doesn't exist yet — that's fine, it will after phase 9.

## Completion

Mark phase 7 completed. Some installs (Xcode in particular) the user kicks off manually after this phase finishes.
