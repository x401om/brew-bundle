# =============================================================================
# .zprofile — login shell config
# =============================================================================

# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM for login shells (VS Code tasks, scripts)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Swiftly (Swift toolchain manager)
[ -f "$HOME/.swiftly/env.sh" ] && . "$HOME/.swiftly/env.sh"
