# parabola-dotfiles

Parabola team dotfiles — terminal and [Claude Code](https://docs.anthropic.com/en/docs/claude-code) settings for Mac and GitHub Codespaces.

## Getting started

**1. Create your own copy**

Use the **"Use this template"** button on GitHub to create a new repo named `dotfiles` under your account (Public visibility required for Codespaces).

**2. Clone it and fill in your identity**

```bash
git clone git@github.com:<your-username>/dotfiles.git ~/dotfiles
```

Edit `.gitconfig` and replace `YOUR_NAME` and `YOUR_EMAIL` with yours.

**3. Run setup**

Open Claude Code and paste:

```
Read ~/dotfiles/SETUP.md and set up this machine.
```

The agent handles the rest. It will tell you the two steps that require your input (keybindings, Codespaces).

## What's synced

| File | Purpose |
|---|---|
| `.zshrc` | Zsh — Oh My Zsh, agnoster, plugins, aliases |
| `.zprofile` | Login shell (Homebrew) |
| `.gitconfig` | Git user, delta pager, LFS |
| `ghostty/config` | Ghostty — Solarized Dark, transparent titlebar, SSH shell integration |
| `.claude/settings.json` | Permissions, plugins, model, effort level |
| `.claude/CLAUDE.md` | Global Claude Code instructions |

## Keeping in sync

On Mac, `install.sh` creates symlinks so edits in `~/dotfiles` are live immediately. Push changes with:

```bash
cd ~/dotfiles && git add -A && git commit -m "update" && git push
```

Your shell silently auto-pulls the repo on each terminal start, so all machines stay in sync.
