# parabola-dotfiles

Parabola team dotfiles — terminal and [Claude Code](https://docs.anthropic.com/en/docs/claude-code) settings for Mac and GitHub Codespaces.

## Getting started

**1. Create your own copy**

Use the GitHub "Use this template" button to create a new repo named `dotfiles` under your account. Or fork it — either works.

**2. Customize the two personal files**

```bash
# Fill in your name and email
.gitconfig

# Add any personal aliases or shortcuts
.zshrc
```

Specifically in `.gitconfig`, replace:
```
name = YOUR_NAME
email = YOUR_EMAIL@parabola.io
```

**3. Enable Codespaces**

Go to [github.com/settings/codespaces](https://github.com/settings/codespaces), check **Automatically install dotfiles**, and point it at your `dotfiles` repo. Every new Codespace will run `install.sh` automatically on creation.

**4. Local Mac setup (optional)**

```bash
git clone git@github.com:<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then ask Claude Code to configure your terminal:

```
Read ~/dotfiles/TERMINAL.md and configure this terminal to match.
```

## What's synced

### Terminal
| File | Purpose |
|---|---|
| `.zshrc` | Zsh config — Oh My Zsh, agnoster theme, plugins, aliases |
| `.zprofile` | Login shell setup (Homebrew) |
| `.gitconfig` | Git user, delta pager, LFS |
| `ghostty/config` | Ghostty config (macOS) — Solarized Dark, transparent titlebar |
| `TERMINAL.md` | Full terminal spec — read by Claude Code to configure any environment |

### Claude Code
| File | Purpose |
|---|---|
| `.claude/settings.json` | Permissions, plugins, model, effort level |
| `.claude/CLAUDE.md` | Global instructions loaded in every conversation |

## Syncing changes

`install.sh` creates symlinks on Mac, so edits in `~/dotfiles` are live immediately. To push changes:

```bash
cd ~/dotfiles
git add -A && git commit -m "update settings" && git push
```

On another machine or Codespace, the next `git pull` picks them up automatically (the `.zshrc` auto-pulls in the background on each shell start).

## What's NOT synced

- **Credentials** (`credentials.json`) — auth tokens, never commit these
- **Sessions, plans, history** — ephemeral per-conversation state
- **Plugins cache** — runtime data; plugin choices live in `settings.json` under `enabledPlugins`
