# WezTerm config

My personal [WezTerm](https://wezterm.org) configuration, meant to be used across all platforms.

## Files

- `wezterm.lua` — entry point. Sets cross-platform options and loads platform-specific modules.
- `navigation.lua` — tab/window naming, tab navigator, and a status indicator.
- `macos.lua` — macOS-only configuration, applied via `apply(config)`.

## What it does

- Hides the title bar while keeping the window resizable (`window_decorations = "RESIZE"`).
- **macOS only:** rebinds <kbd>Opt</kbd>+<kbd>←</kbd> / <kbd>Opt</kbd>+<kbd>→</kbd> to move the cursor backward / forward one word.

### Tabs & windows

Named tabs give labeled, independent contexts within a window — no global workspace swapping.

- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>G</kbd> — **g**o to a tab via a searchable list (tab navigator).
- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> — **e**dit (rename) the active tab.
- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd> — rename the active window.
- The active window name shows at the right end of the tab bar (the title bar is hidden).

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
