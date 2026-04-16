# Machine Setup

Read this entire file, then set up this machine. The dotfiles repo should already be cloned at `~/dotfiles` before you start.

## Steps

**1. Homebrew (macOS)**

If not installed:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Oh My Zsh**

If not installed:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**3. Run install.sh**

```bash
cd ~/dotfiles && ./install.sh
```

This symlinks Claude Code config, shell dotfiles, and Ghostty config, and installs CLI tools via Homebrew.

**4. Claude Code**

If not installed:
```bash
npm install -g @anthropic-ai/claude-code
```

Then launch and log in: `claude`

**5. Claude Code skills**

```bash
npx skills install agent-browser
```

**6. Terminal**

Read `~/dotfiles/TERMINAL.md` and configure this terminal to match — font, colors, shell framework, and CLI tools.

## Steps requiring human action

These cannot be done by an agent — tell the user:

- **`.gitconfig`** — fill in their name and email (replace `YOUR_NAME` and `YOUR_EMAIL`)
- **Keybindings** — run `/terminal-setup` inside Claude Code to configure Shift+Enter and other shortcuts
- **Codespaces** — go to [github.com/settings/codespaces](https://github.com/settings/codespaces), enable "Automatically install dotfiles", select their `dotfiles` repo
