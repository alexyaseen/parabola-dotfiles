# Portable zsh config — sourced in Codespaces alongside the devcontainer default.
# macOS-specific things (brew, eza, bat, thefuck, bun, etc.) live in .zshrc only.

_dotfiles_dir="${0:A:h}"

# --- Shared aliases (git + dev shortcuts) ---
source "$_dotfiles_dir/aliases.zsh"

# --- FZF configuration ---
if command -v fzf &>/dev/null; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- History settings ---
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# --- Completion ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# --- Zoxide (smarter cd) ---
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# --- Auto-pull dotfiles in background ---
[[ -d "$_dotfiles_dir" ]] && git -C "$_dotfiles_dir" pull --quiet &>/dev/null &
