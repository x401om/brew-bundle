# =============================================================================
# .zshrc — interactive shell config
# =============================================================================

# Flutter (FVM-managed default version)
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"

# GPG signing
export GPG_TTY=$(tty)

# NVM (Node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Local user bin
export PATH="$HOME/.local/bin:$PATH"

# Cortex personal assistant
alias axel="cd ~/Obsidian && claude"
