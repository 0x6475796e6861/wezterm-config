# WezTerm config

My personal [WezTerm](https://wezterm.org) configuration, meant to be used across all platforms.

## Files

- `wezterm.lua` — entry point. Sets cross-platform options and loads platform-specific modules.
- `workspaces.lua` — one workspace per server, SSH domains, fuzzy switcher, status bar.
- `macos.lua` — macOS-only configuration, applied via `apply(config)`.

## What it does

- Hides the title bar while keeping the window resizable (`window_decorations = "RESIZE"`).
- **macOS only:** rebinds <kbd>Opt</kbd>+<kbd>←</kbd> / <kbd>Opt</kbd>+<kbd>→</kbd> to move the cursor backward / forward one word.

### Workspaces

One persistent, named, reconnectable workspace per server — like iTerm profiles + tmux sessions, natively.

- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>W</kbd> — fuzzy-select an existing workspace.
- Jump to (or create + SSH into) a server's workspace: <kbd>Cmd</kbd>+<kbd>d/b/p/o</kbd> on macOS, <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>d/b/p/o</kbd> elsewhere (`dev`, `db`, `platform`, `observ`).
- The active workspace name shows in the bottom-right status bar.

The server list in `workspaces.lua` uses **placeholder** hosts (`*.example.com`) — edit
`remote_address` and `username` for each box before the jump keys will connect.

## Install

Clone (or symlink) this directory to `~/.config/wezterm`:

```sh
git clone <repo-url> ~/.config/wezterm
```

WezTerm watches the config file and reloads automatically on save. You can also reload manually with <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>.
