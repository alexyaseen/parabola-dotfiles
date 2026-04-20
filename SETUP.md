# Machine Setup

The dotfiles repo should already be cloned at `~/dotfiles` before you start.

## Steps

**1. Run `install.sh`**

```bash
cd ~/dotfiles && ./install.sh
```

It bootstraps Homebrew + Oh My Zsh if they're missing, installs all the CLI tools (`gh`, `ripgrep`, `fd`, etc.), installs Claude Code via npm, and symlinks every config. Safe to re-run.

**2. Authenticate `gh` with the Codespaces scope**

```bash
gh auth login -s codespace
```

Required for the `csh` wrapper (Codespaces SSH + image paste). `install.sh` prompts you to run this at the end if it detects the scope is missing.

**3. Launch Claude Code**

```bash
claude
```

It will open a browser for first-time login.

**4. Terminal setup**

Read `~/dotfiles/TERMINAL.md` and configure this terminal to match — font, colors, and keybindings.

## Steps requiring human action

These cannot be done by an agent — tell the user:

- **`.gitconfig`** — fill in their name and email (replace `YOUR_NAME` and `YOUR_EMAIL`)
- **Keybindings** — run `/terminal-setup` inside Claude Code to configure Shift+Enter and other shortcuts
- **Codespaces dotfiles integration** — go to [github.com/settings/codespaces](https://github.com/settings/codespaces), enable "Automatically install dotfiles", select their `dotfiles` repo
