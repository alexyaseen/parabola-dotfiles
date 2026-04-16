# Terminal Setup Instructions

Read this entire file, then configure this machine's terminal to match the spec below. Adapt to whatever terminal emulator and OS you're running in (iTerm2, Terminal.app, VS Code integrated terminal, Codespaces, etc.).

**Ghostty users (macOS):** `install.sh` symlinks this repo's `ghostty/config` to `~/.config/ghostty/config`, applying Solarized Dark (section 4), transparent titlebar, and session restore. Ghostty's bundled default font is used instead of MesloLGS — add `font-family = "MesloLGS Nerd Font Mono"` to the config if you want section 3's exact spec. Install with `brew install --cask ghostty`.

## 1. Shell Framework

Install Zsh and Oh My Zsh:

- If Oh My Zsh is not installed, install it: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Theme: **agnoster**
- Plugins: `git`, `npm`, `node`, `brew`, `macos`, `history-substring-search`, `zsh-autosuggestions`, `zsh-syntax-highlighting`

Install the custom plugins that aren't bundled with Oh My Zsh:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## 2. CLI Tools

Install all of these via Homebrew (macOS) or the appropriate package manager for your OS:

| Tool | Package name | Replaces | Purpose |
|---|---|---|---|
| bat | `bat` | cat | Syntax-highlighted file viewer |
| eza | `eza` | ls | Modern ls with git integration |
| fd | `fd` | find | Fast file finder |
| fzf | `fzf` | — | Fuzzy finder (run `$(brew --prefix)/opt/fzf/install` after) |
| ripgrep | `ripgrep` | grep | Fast search |
| git-delta | `git-delta` | — | Better git diffs |
| thefuck | `thefuck` | — | Correct previous command |
| zoxide | `zoxide` | cd | Smarter directory jumping |
| gh | `gh` | — | GitHub CLI |
| agent-browser | `agent-browser` | — | Browser automation CLI for Claude Code |

On macOS with Homebrew:

```bash
brew install bat eza fd fzf ripgrep git-delta thefuck zoxide gh agent-browser
$(brew --prefix)/opt/fzf/install
```

## 3. Font

**MesloLGS Nerd Font Mono, 12pt** with ligatures enabled.

```bash
brew install --cask font-meslo-lg-nerd-font
```

Then set this font in your terminal emulator's preferences.

## 4. Terminal Color Scheme

**Solarized Dark** color scheme.

In iTerm2: **Settings > Profiles > Colors > Color Presets... > Solarized Dark** (built-in, no import needed).

## 5. Shell Configuration

Add the following to `~/.zprofile`:

```bash
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
```

Add the following to `~/.zshrc` (replace the default one Oh My Zsh created):

```bash
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(
  git
  npm
  node
  brew
  macos
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Thefuck alias
eval $(thefuck --alias)

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Tool replacements
alias ls='eza'
alias ll='eza -la --git'
alias la='eza -la'
alias tree='eza --tree'
alias cat='bat'
alias grep='rg'
alias find='fd'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'

# Development shortcuts
alias y='yarn'
alias nr='npm run'

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

## 6. Git Configuration

Add to `~/.gitconfig` (fill in your own name and email):

```gitconfig
[user]
    name = YOUR_NAME
    email = YOUR_EMAIL@parabola.io
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true
    light = false
[filter "lfs"]
    clean = git-lfs clean -- %f
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
    required = true
```

## 7. Claude Code Configuration

Run `install.sh` from this dotfiles repo — it symlinks `.claude/settings.json` automatically.

If setting up manually, copy `.claude/settings.json` from this repo to `~/.claude/settings.json`.

## 8. Claude Code Skills

Install the agent-browser skill for browser automation:

```bash
npx skills install agent-browser
```

## 9. Terminal Keybindings

**Tell the user to run `/terminal-setup` inside Claude Code.** You cannot do this step — it's an interactive Claude Code command that the user must run themselves. It configures Shift+Enter for multiline input and other terminal-specific keybindings, auto-detecting their terminal emulator (iTerm2, VS Code, Terminal.app, etc.).

## 10. Verify

After setup, open a new terminal session and confirm:
- The agnoster prompt renders correctly (no broken glyphs)
- `eza`, `bat`, `fd`, `rg`, `fzf`, `delta`, `thefuck`, `zoxide`, `gh`, `agent-browser` are all available
- `git diff` shows delta-formatted output
- `z` command works for directory jumping (zoxide)
- Shift+Enter creates a new line in Claude Code (Enter submits)
