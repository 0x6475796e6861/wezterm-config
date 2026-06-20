# WezTerm config

My personal [WezTerm](https://wezterm.org) configuration, meant to be used across all platforms.

## Files

- `wezterm.lua` — entry point. Sets cross-platform options and loads platform-specific modules.
- `navigation.lua` — default tab/window titles, a command-palette tab navigator, and a status indicator.
- `macos.lua` — macOS-only configuration, applied via `apply(config)`.

## What it does

- Hides the title bar while keeping the window resizable (`window_decorations = "RESIZE"`).
- **macOS only:** rebinds <kbd>Opt</kbd>+<kbd>←</kbd> / <kbd>Opt</kbd>+<kbd>→</kbd> to move the cursor backward / forward one word.

### Tabs & windows

Tabs and windows are independent, labelled contexts — no global workspace swapping.

Open the command palette with <kbd>Cmd</kbd>/<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> for both commands below.

- **Go to tab** — a fuzzy list across **all** windows. Each entry is labelled `window / tab`, so the window name is part of the filter text.
- **Rename tab** — prompts for a name for the active tab.
- **Rename window** — prompts for a name for the current window.
- **Default titles** — a new tab is titled `untitled-tab-<id>` and a new window `untitled-window-<id>` until renamed.
- The active window name shows at the right end of the tab bar (the title bar is hidden).

Tabs can also be renamed from the shell with `wezterm cli set-tab-title "build"`.

> Windows are named via the palette rather than `wezterm cli set-window-title` because the
> shell continuously rewrites the window title with OSC escape sequences, which would
> overwrite a CLI-set name. The tab title has no such conflict.

Plus WezTerm's defaults: <kbd>Cmd</kbd>/<kbd>Ctrl+Shift</kbd>+<kbd>1…9</kbd> jump to a tab, and
<kbd>Ctrl</kbd>+<kbd>Tab</kbd> / <kbd>Ctrl+Shift</kbd>+<kbd>Tab</kbd> cycle tabs.

For persistent or remote sessions, use tmux on the server, or `wezterm ssh user@host` for
one-off connections.

## Install

Clone (or symlink) this directory to `~/.config/wezterm`:

```sh
git clone <repo-url> ~/.config/wezterm
```

WezTerm watches the config file and reloads automatically on save. You can also reload manually with <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>.
