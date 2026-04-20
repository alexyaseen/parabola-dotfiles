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

## Codespace image paste (`csh` + `pi`)

SSH doesn't carry image bytes through a terminal paste, so you can't ⌘V a Mac screenshot into Claude running in a Codespace. This repo ships two small pieces that work together:

- **`csh [codespace-name]`** on the Mac (defined in `aliases.zsh`) — wraps `gh codespace ssh` with `-R 9876:localhost:9876`, which reverse-tunnels a tiny Mac-local HTTP server (`bin/clipboard-server`) into the Codespace. The server serves the current Mac clipboard as PNG and starts lazily on first `csh` use — no LaunchAgent.
- **`pi`** inside the Codespace (defined in `codespace.zshrc`) — `curl`s that server, saves the PNG to `$CS_PASTE_DIR` (default: `/workspaces/parabola/.pasted`), and echoes the path.

**Typical flow**
1. Copy an image on the Mac (⌃⇧⌘4 for a region screenshot to clipboard).
2. `csh <codespace-name>` to connect.
3. In the Codespace: `pi` → path is echoed.
4. Select the path (mouse drag or terminal copy shortcut) and paste it as an `@`-reference in Claude's prompt.

**Env vars**
- `CS_PASTE_DIR` — in-Codespace upload dir (default: `/workspaces/parabola/.pasted`).

**Troubleshooting**
- *"Mac clipboard server unreachable — did you ssh via 'csh'?"* — you used plain `gh codespace ssh`. Reconnect with `csh`.
- *"no image on Mac clipboard"* — self-explanatory; copy an image first.
- `gh missing 'codespace' scope` — run `gh auth refresh -h github.com -s codespace`.

## What's synced

| File | Purpose |
|---|---|
| `.zshrc` | Zsh — Oh My Zsh, agnoster, plugins, aliases |
| `.zprofile` | Login shell (Homebrew) |
| `.gitconfig` | Git user, delta pager, LFS |
| `ghostty/config` | Ghostty — Solarized Dark, transparent titlebar, SSH shell integration |
| `aliases.zsh` | Shared aliases + `csh` Codespaces wrapper function |
| `codespace.zshrc` | Portable zsh config sourced inside Codespaces (defines `pi`) |
| `bin/clipboard-server` | Mac HTTP server that exposes the clipboard as PNG for `pi` to fetch |
| `.claude/settings.json` | Permissions, plugins, model, effort level |
| `.claude/CLAUDE.md` | Global Claude Code instructions |

## Keeping in sync

On Mac, `install.sh` creates symlinks so edits in `~/dotfiles` are live immediately. Push changes with:

```bash
cd ~/dotfiles && git add -A && git commit -m "update" && git push
```

Your shell silently auto-pulls the repo on each terminal start, so all machines stay in sync.
