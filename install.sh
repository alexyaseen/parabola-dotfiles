#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude"

# Symlink everything except settings.json (handled separately below)
for item in keybindings.json CLAUDE.md skills rules agents; do
    src="$SCRIPT_DIR/.claude/$item"
    dest="$HOME/.claude/$item"
    [ -e "$src" ] && ln -sf "$src" "$dest"
done

# Settings: symlink locally, generate with overrides in Codespaces
if [ "$CODESPACES" = "true" ]; then
    cp "$SCRIPT_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
    echo ""
    echo "Claude Code config installed (Codespace mode: copied, not symlinked)."

    # Install CLI tools in the background so install.sh exits fast.
    # Shell config guards each tool with `command -v`, so missing tools are fine.
    nohup bash -c '
        sudo rm -f /var/lib/man-db/auto-update   # skip 17s man-db trigger rebuild
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get update -qq
        sudo apt-get install -y -qq --no-install-recommends ripgrep fd-find fzf bat &
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh &
        wait

        # Debian/Ubuntu ships fd and bat under alternate names
        [ ! -L /usr/local/bin/fd ] && sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd 2>/dev/null
        [ ! -L /usr/local/bin/bat ] && sudo ln -s "$(command -v batcat)" /usr/local/bin/bat 2>/dev/null

        echo "$(date +%T) dotfiles tool install complete" > /tmp/dotfiles-bg-install.done
    ' > /tmp/dotfiles-bg-install.log 2>&1 &
else
    ln -sf "$SCRIPT_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
    echo ""
    echo "Claude Code config symlinked."
fi

# --- Shell dotfiles ---

if [ "$CODESPACES" = "true" ]; then
    # Codespace: don't replace the devcontainer .zshrc — just source portable extras
    MARKER="# >>> dotfiles/codespace.zshrc >>>"
    if ! grep -qF "$MARKER" "$HOME/.zshrc" 2>/dev/null; then
        cat >> "$HOME/.zshrc" <<EOF

# >>> dotfiles/codespace.zshrc >>>
[ -f "$SCRIPT_DIR/codespace.zshrc" ] && source "$SCRIPT_DIR/codespace.zshrc"
# <<< dotfiles/codespace.zshrc <<<
EOF
    fi
    echo "Shell: codespace.zshrc sourced from existing .zshrc."
else
    # macOS: install CLI tools via Homebrew
    brew install ripgrep fd fzf bat eza thefuck zoxide git-delta agent-browser

    # macOS: symlink all shell dotfiles
    ln -sf "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$SCRIPT_DIR/.zprofile" "$HOME/.zprofile"
    echo "Shell: .gitconfig, .zshrc, .zprofile symlinked."

    # Ghostty
    mkdir -p "$HOME/.config/ghostty"
    ln -sf "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"
    echo "Ghostty: config symlinked."
fi

echo ""
echo "To finish terminal setup, paste this into Claude Code:"
echo ""
echo "  Read $SCRIPT_DIR/TERMINAL.md and configure this terminal to match."
echo ""
echo "To install the agent-browser discovery skill (CLI already installed):"
echo ""
echo "  npx skills add vercel-labs/agent-browser"
echo ""
