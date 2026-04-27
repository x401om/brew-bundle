# =============================================================================
# Brewfile — Aleksei's Mac development environment
# =============================================================================
# Usage:
#   brew bundle install
#
# This file is the source of truth for what Homebrew installs on a fresh Mac.
# To regenerate from current state: brew bundle dump --force
# To diff current vs tracked:        brew bundle check --verbose
# =============================================================================

# -----------------------------------------------------------------------------
# Taps
# -----------------------------------------------------------------------------
tap "homebrew/bundle"
tap "xcodesorg/made"
tap "leoafarias/fvm"

# -----------------------------------------------------------------------------
# CLI tools
# -----------------------------------------------------------------------------

# Shell + Git
brew "gh"                              # GitHub CLI
brew "git-lfs"                         # Git Large File Storage
brew "gnupg"                           # GPG signing
brew "pinentry-mac"                    # GPG passphrase entry on macOS

# Node version manager (single source of truth — no brew node*)
brew "nvm"

# Ruby version manager (CocoaPods, Fastlane, gem-based tooling)
brew "rbenv"

# Mobile dev
brew "cocoapods"                       # iOS dependency manager
brew "fastlane"                        # iOS/Android release automation
brew "swiftformat"                     # Swift code formatter
brew "xcodesorg/made/xcodes"           # Xcode version manager (CLI)
brew "leoafarias/fvm/fvm"              # Flutter version manager

# Google
brew "gogcli"                          # Multi-account Google CLI (Gmail/Calendar)

# Utilities
brew "aria2"                           # Segmented downloader
brew "asciidoctor"                     # AsciiDoc → HTML/PDF (universal-gallery docs)
brew "tw93/tap/mole"                   # macOS cleanup utility (ad-hoc)

# -----------------------------------------------------------------------------
# GUI applications (casks)
# -----------------------------------------------------------------------------

# Password manager
cask "1password"
cask "1password-cli"

# Terminal + editors
cask "warp"                            # Primary terminal
cask "visual-studio-code"
cask "cursor"

# Browsers
cask "arc"
cask "google-chrome"

# AI tools
cask "claude"
cask "chatgpt"
cask "codex"
cask "cmux"

# Productivity
cask "obsidian"                        # Cortex vault
cask "dropbox"
cask "spotify"

# Networking + remote
cask "nordvpn"
cask "splashtop-business"

# Display
cask "betterdisplay"                   # Display config
cask "lunar"                           # Display brightness/profiles

# Cloud / dev services
cask "gcloud-cli"

# Xcode helpers
cask "xcodes-app"                      # Xcode version manager (GUI)
cask "swiftformat-for-xcode"
cask "devcleaner"                      # Xcode derived data cleanup

# Git GUI
cask "sourcetree"                      # Used as git mergetool in .gitconfig
