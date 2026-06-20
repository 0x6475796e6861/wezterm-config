# WezTerm config

My personal [WezTerm](https://wezterm.org) configuration, meant to be used across all platforms.

## Files

- `wezterm.lua` — entry point. Sets cross-platform options and loads platform-specific modules.
- `workspaces.lua` — workspace switcher, create-by-name prompt, auto SSH domains, status bar.
- `macos.lua` — macOS-only configuration, applied via `apply(config)`.

## What it does

- Hides the title bar while keeping the window resizable (`window_decorations = "RESIZE"`).
- **macOS only:** rebinds <kbd>Opt</kbd>+<kbd>←</kbd> / <kbd>Opt</kbd>+<kbd>→</kbd> to move the cursor backward / forward one word.

### Workspaces

Persistent, named, reconnectable workspaces — like iTerm profiles + tmux sessions, natively.

- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>W</kbd> — fuzzy-select an existing workspace.
- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>N</kbd> — prompt for a name, then create/switch to that workspace.
- The active workspace name shows at the right end of the tab bar.

SSH domains are generated automatically from every `Host` in `~/.ssh/config` via
`wezterm.default_ssh_domains()`, so any server can back a workspace (spawn into a domain from
the launcher, or `wezterm connect <host>`). Remotes need wezterm installed for the
multiplexing (`SSHMUX`) variants.

## Install

Clone (or symlink) this directory to `~/.config/wezterm`:

```sh
git clone <repo-url> ~/.config/wezterm
```

WezTerm watches the config file and reloads automatically on save. You can also reload manually with <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>.
