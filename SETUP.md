# Setup Guide

Step-by-step instructions for a new Parabola engineer getting fully set up with Claude Code, a configured terminal, and GitHub Codespaces.

---

## 1. Fork this repo

Go to the GitHub page for this repo and click **"Use this template" → "Create a new repository"**.

- Repository name: `dotfiles`
- Visibility: Public (required for Codespaces to pick it up automatically)

Clone your new repo locally:

```bash
git clone git@github.com:<your-username>/dotfiles.git ~/dotfiles
```

---

## 2. Personalize

Edit these two files before running anything:

**`~/dotfiles/.gitconfig`** — replace the placeholder values:
```
name = YOUR_NAME          →  name = Jane Smith
email = YOUR_EMAIL@parabola.io  →  email = jane@parabola.io
```

**`~/dotfiles/.zshrc`** — the Parabola shortcuts (`alias dev`, `alias bob`) should work as-is if your local repo lives at `~/parabola`. Adjust the path if yours is elsewhere.

---

## 3. Install Homebrew (macOS)

If you don't have it:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## 4. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the two custom plugins it needs:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

---

## 5. Run install.sh

```bash
cd ~/dotfiles
./install.sh
```

This will:
- Symlink `.claude/settings.json`, `CLAUDE.md`, and other Claude Code config into `~/.claude/`
- Symlink `.zshrc`, `.zprofile`, `.gitconfig` into `~/`
- Symlink `ghostty/config` into `~/.config/ghostty/`
- Install CLI tools via Homebrew (`eza`, `bat`, `fd`, `fzf`, `ripgrep`, `git-delta`, `thefuck`, `zoxide`, `gh`, `agent-browser`)

Open a new terminal tab after it completes.

---

## 6. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

Then launch and log in:

```bash
claude
```

---

## 7. Install Claude Code skills

```bash
npx skills install agent-browser
```

---

## 8. Configure your terminal

Inside Claude Code, run:

```
Read ~/dotfiles/TERMINAL.md and configure this terminal to match.
```

This sets up the font (MesloLGS Nerd Font Mono), colors (Solarized Dark), and any terminal-emulator-specific settings for whatever you're running (Ghostty, iTerm2, VS Code, etc.).

Then configure keyboard shortcuts — Claude Code can't do this step, you need to run it yourself:

```
/terminal-setup
```

This sets up Shift+Enter for multiline input and other keybindings.

---

## 9. Enable Codespaces

Go to [github.com/settings/codespaces](https://github.com/settings/codespaces):

- Check **"Automatically install dotfiles"**
- Select your `dotfiles` repo

Every new Codespace will now run `install.sh` automatically on creation, giving you your shell config, aliases, and Claude Code settings in the cloud environment.

---

## Keeping things in sync

Your local `~/dotfiles` is a git repo. Changes you make (new aliases, settings tweaks, etc.) push to GitHub and automatically pull into new Codespaces:

```bash
cd ~/dotfiles
git add -A && git commit -m "update settings" && git push
```

Your shell auto-pulls the repo silently in the background every time you open a terminal, so changes propagate to all your machines on the next shell start.
