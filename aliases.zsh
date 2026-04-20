# Shared aliases — sourced by both .zshrc (macOS) and codespace.zshrc (Codespaces).

# --- Git ---
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'

# --- Development ---
alias y='yarn'
alias nr='npm run'
alias npmr='npm run'

# --- Codespace SSH wrapper (macOS only — `gh` usually isn't in Codespaces) ---
# `csh [codespace-name]` wraps `gh codespace ssh` with three conveniences for
# the image-paste flow and beyond:
#   1. Reverse-tunnels the Mac's clipboard server (port 9876) into the Codespace
#      so the codespace-side `pi` function can fetch Mac clipboard images.
#   2. Lazy-starts $HOME/bin/clipboard-server if nothing is already listening,
#      so there's no LaunchAgent to manage.
#   3. If a name is passed and that Codespace is Shutdown, starts it first.
# Preflights that `gh` has the `codespace` scope and prints a fix if missing.
csh() {
    if ! command -v gh >/dev/null 2>&1; then
        echo "gh not installed — run ~/dotfiles/install.sh" >&2
        return 1
    fi
    if ! gh auth status 2>&1 | grep -q "'codespace'"; then
        echo "gh missing 'codespace' scope — run: gh auth refresh -h github.com -s codespace" >&2
        return 1
    fi
    if ! lsof -iTCP:9876 -sTCP:LISTEN -nP >/dev/null 2>&1; then
        if [[ -x "$HOME/bin/clipboard-server" ]]; then
            "$HOME/bin/clipboard-server" >/dev/null 2>&1 &
            disown
        fi
    fi
    if [[ $# -gt 0 && "$1" != -* ]]; then
        local state
        state=$(gh codespace view -c "$1" --json state -q .state 2>/dev/null)
        if [[ "$state" == "Shutdown" ]]; then
            echo "Starting $1…"
            gh codespace start -c "$1" >/dev/null
        fi
    fi
    gh codespace ssh "$@" -- -R 9876:localhost:9876
}
