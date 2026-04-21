#!/bin/bash
# Install dotfiles — macOS or GitHub Codespaces.
#
# macOS: bootstraps Homebrew + Oh My Zsh if missing, installs CLI tools
# (including `gh`), installs Claude Code via npm, symlinks configs, and
# prints the one interactive step left (gh auth).
#
# Codespaces: copies Claude Code config, sources codespace.zshrc into the
# devcontainer's .zshrc, background-installs CLI tools via apt.

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
    # macOS: bootstrap Homebrew if missing (requires sudo on first install)
    if ! command -v brew >/dev/null 2>&1; then
        echo ""
        echo "Homebrew not found — installing (will prompt for your password)…"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if   [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew    ]; then eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    # macOS: install CLI tools via Homebrew
    brew install ripgrep fd fzf bat eza thefuck zoxide git-delta agent-browser pngpaste gh

    # Bootstrap Oh My Zsh if missing
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo ""
        echo "Oh My Zsh not found — installing…"
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
        git clone -q https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
        git clone -q https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

    # Install Claude Code via npm if missing
    if ! command -v claude >/dev/null 2>&1; then
        if command -v npm >/dev/null 2>&1; then
            echo "Installing Claude Code (npm install -g @anthropic-ai/claude-code)…"
            npm install -g @anthropic-ai/claude-code
        else
            echo "npm not found — install Node.js, then: npm install -g @anthropic-ai/claude-code"
        fi
    fi

    # macOS: symlink all shell dotfiles
    ln -sf "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$SCRIPT_DIR/.zprofile" "$HOME/.zprofile"
    echo "Shell: .gitconfig, .zshrc, .zprofile symlinked."

    # Ghostty
    mkdir -p "$HOME/.config/ghostty"
    ln -sf "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"
    echo "Ghostty: config symlinked."

    # bin/ — user scripts symlinked into ~/bin
    mkdir -p "$HOME/bin"
    for script in "$SCRIPT_DIR/bin/"*; do
        [ -f "$script" ] || continue
        ln -sf "$script" "$HOME/bin/$(basename "$script")"
    done
    echo "Bin: scripts symlinked into ~/bin."
fi

echo ""
echo "Done. Open a new shell to pick up the config."
echo ""

if [ "$CODESPACES" != "true" ]; then
    if ! gh auth status 2>&1 | grep -q "'codespace'"; then
        echo "One last step — authenticate gh with the Codespaces scope:"
        echo ""
        echo "  gh auth login -s codespace"
        echo ""
        echo "(Pick HTTPS + browser. Enables the 'csh' wrapper and image paste.)"
        echo ""
    fi
fi

echo "To install the agent-browser discovery skill (CLI already installed):"
echo ""
echo "  npx skills add vercel-labs/agent-browser"
echo ""
