# brew-bundle

All-you-need software for development in a single Brewfile. This repository contains everything you need to restore your Mac development environment after a full reset.

## Quick Start

To install all apps and packages from the Brewfile:

```bash
brew bundle install
```

## Full Mac Restoration Guide

Follow these steps to completely restore your Mac development environment after a full reset:

### Prerequisites

1. **Install Xcode Command Line Tools** (required for Homebrew):
   ```bash
   xcode-select --install
   ```

2. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Clone this repository** (or copy the Brewfile):
   ```bash
   git clone <your-repo-url> brew-bundle
   cd brew-bundle
   ```

### Step 1: Install All Packages and Apps

Install everything from the Brewfile:

```bash
brew bundle install
```

This will install:
- All CLI tools and development libraries
- All GUI applications (casks)
- All required Homebrew taps

### Step 2: Install Mac App Store Apps (Optional)

If you use `mas-cli` to manage App Store apps, install it first:

```bash
brew install mas
```

Then create a `Masfile` with your App Store apps:
```bash
mas list > Masfile
```

To restore App Store apps:
```bash
mas install $(cat Masfile | awk '{print $1}')
```

### Step 3: Restore Additional Configuration

#### Git Configuration

Set up your Git identity:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### SSH Keys

Restore your SSH keys from backup (if you have them):
```bash
# Copy your SSH keys to ~/.ssh/
# Ensure proper permissions:
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
```

#### Shell Configuration

Restore your shell configuration files (`.zshrc`, `.bash_profile`, etc.) from backup or version control.

#### Node.js Global Packages

If you had global npm packages, reinstall them:
```bash
npm install -g <package1> <package2> ...
```

#### Ruby Gems

If using rbenv, install Ruby versions and gems:
```bash
rbenv install <version>
gem install <gem1> <gem2> ...
```

#### CocoaPods

CocoaPods is already installed via Homebrew. You may need to run:
```bash
pod setup
```

### Step 4: Verify Installation

Check installed versions:
```bash
./generate-versions.sh
cat VERSIONS.md
```

### Step 5: Update Packages

Keep your packages up to date:
```bash
brew update
brew upgrade
brew bundle cleanup  # Remove packages not in Brewfile
```

## Managing the Brewfile

### Adding New Packages

1. Install the package:
   ```bash
   brew install <package>
   # or
   brew install --cask <app>
   ```

2. Add it to the Brewfile manually, or regenerate:
   ```bash
   brew bundle dump --force
   ```

3. Regenerate versions dump:
   ```bash
   ./generate-versions.sh
   ```

### Updating Versions Dump

To update the versions dump with currently installed packages:

```bash
./generate-versions.sh
```

This creates/updates `VERSIONS.md` with all installed package versions from your Brewfile.

## What's Included

### CLI Tools
- Development tools (cocoapods, swiftformat, fastlane, etc.)
- Language runtimes (node, ruby via rbenv)
- Mobile development tools (firebase-cli, fvm, tuist)
- Git tools (git-lfs)
- System libraries and utilities

### GUI Applications
- Development tools (Xcode extensions, terminals, simulators)
- Version control clients
- Browsers
- Productivity apps
- Quick Look plugins

## Backup Checklist

Before resetting your Mac, make sure to backup:

- [ ] This Brewfile repository
- [ ] SSH keys (`~/.ssh/`)
- [ ] Shell configuration files (`.zshrc`, `.bash_profile`, etc.)
- [ ] Git configuration (`~/.gitconfig`)
- [ ] List of global npm packages (`npm list -g --depth=0`)
- [ ] List of Ruby gems (`gem list`)
- [ ] App Store apps list (`mas list > Masfile`)
- [ ] Any custom fonts
- [ ] Xcode preferences and snippets
- [ ] VS Code settings and extensions
- [ ] Other application preferences

## Troubleshooting

### Package Installation Fails

If a package fails to install:
1. Check if the tap is added: `brew tap`
2. Update Homebrew: `brew update`
3. Check for issues: `brew doctor`

### Missing Packages

If packages are missing from the versions dump:
- They may not be installed yet
- Run `brew bundle install` to install missing packages
- Regenerate versions: `./generate-versions.sh`

## License

See [LICENSE](LICENSE) file for details.
