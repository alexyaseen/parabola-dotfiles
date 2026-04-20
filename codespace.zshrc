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

# --- Image paste from the Mac clipboard ---
# `pi` fetches the current Mac clipboard image via a reverse SSH tunnel set up
# by the `csh` wrapper on the Mac side, saves it to $CS_PASTE_DIR (default
# /workspaces/parabola/.pasted), and echoes the path. Select the path with
# your mouse or terminal shortcut to use it as an @-reference in Claude.
pi() {
    local dir="${CS_PASTE_DIR:-/workspaces/parabola/.pasted}"
    mkdir -p "$dir"
    local path="$dir/clip-$(date +%Y%m%d-%H%M%S).png"
    local code
    code=$(curl -s -o "$path" -w '%{http_code}' --max-time 3 http://localhost:9876/ 2>/dev/null)

    if [[ "$code" == "200" && -s "$path" ]]; then
        echo "$path"
        return 0
    fi
    rm -f "$path"
    case "$code" in
        204) echo "no image on Mac clipboard" >&2 ;;
        000|"") echo "Mac clipboard server unreachable — did you ssh via 'csh'?" >&2 ;;
        *) echo "clipboard server returned HTTP $code" >&2 ;;
    esac
    return 1
}

# --- Auto-pull dotfiles in background ---
[[ -d "$_dotfiles_dir" ]] && git -C "$_dotfiles_dir" pull --quiet &>/dev/null &
