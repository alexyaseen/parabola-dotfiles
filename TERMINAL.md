# Terminal Setup

Configure the current terminal to match this spec. Adapt to whatever terminal emulator and OS you're running in (iTerm2, Terminal.app, VS Code integrated terminal, Codespaces, etc.).

## Reference configs

The following files are in this repo and should be symlinked or copied into `~`:

- **`.zshrc`** — Oh My Zsh, agnoster theme, plugins, aliases, history settings, fzf/nvm/bun config
- **`.zprofile`** — Homebrew shellenv
- **`.gitconfig`** — User info, delta pager, LFS
- **`ghostty/config`** (macOS, optional) — if you use [Ghostty](https://ghostty.org/), symlink to `~/.config/ghostty/config`. Handles colors, transparent titlebar, and session restore. Ghostty's bundled default font is used instead of MesloLGS.

Running `install.sh` handles all of the above automatically.

After linking those, configure the terminal emulator itself using the spec below.

## Shell

- Zsh with Oh My Zsh
- Theme: agnoster
- Plugins: git, npm, node, brew, macos, history-substring-search, zsh-autosuggestions, zsh-syntax-highlighting

## Font

- MesloLGS Nerd Font Mono, 12pt
- Ligatures enabled
- Install if missing: Homebrew `font-meslo-lg-nerd-font`

## Colors

**Solarized Dark** color scheme. In iTerm2: Settings > Profiles > Colors > Color Presets... > Solarized Dark (built-in).

## CLI Tools

Install if missing. Prefer Homebrew on macOS, apt/cargo/binary releases on Linux.

| Tool | Replaces | Purpose |
|---|---|---|
| bat | cat | Syntax-highlighted file viewer |
| eza | ls | Modern ls with git integration |
| fd | find | Fast file finder |
| fzf | — | Fuzzy finder |
| ripgrep (rg) | grep | Fast search |
| git-delta | — | Better git diffs |
| thefuck | — | Correct previous command |
| zoxide | cd | Smarter directory jumping |
| gh | — | GitHub CLI |
| agent-browser | — | Browser automation CLI for Claude Code |

## Aliases

```sh
# Tool replacements
alias ls='eza'
alias ll='eza -la --git'
alias la='eza -la'
alias tree='eza --tree'
alias cat='bat'
alias grep='rg'
alias find='fd'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
```

## History

```sh
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
```
