# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
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

# === CUSTOM DEVELOPMENT SETUP ===

# Resolve the dotfiles repo dir from this symlinked file
_dotfiles_dir="${${(%):-%x}:A:h}"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd for fzf file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Better fzf shortcuts
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Thefuck alias
eval $(thefuck --alias)

# Better aliases using our new tools
alias ls='eza'
alias ll='eza -la --git'
alias la='eza -la'
alias tree='eza --tree'
alias cat='bat'
alias grep='rg'
alias find='fd'

# Shared aliases (git + dev shortcuts)
source "$_dotfiles_dir/aliases.zsh"

# Parabola shortcuts
alias dev="cd $HOME/parabola"
alias bob="$HOME/parabola/bob.py"

# Quick file editing
alias zshconfig='code ~/.zshrc'
alias gitconfig='code ~/.gitconfig'

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Auto-pull dotfiles in background (silent, no-op if dir missing)
[[ -d "$_dotfiles_dir" ]] && git -C "$_dotfiles_dir" pull --quiet &>/dev/null &
