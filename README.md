# WezTerm config

My personal [WezTerm](https://wezterm.org) configuration, meant to be used across all platforms.

## Files

- `wezterm.lua` — entry point. Sets cross-platform options and loads platform-specific modules.
- `macos.lua` — macOS-only configuration, applied via `apply(config)`.

## What it does

- Hides the title bar while keeping the window resizable (`window_decorations = "RESIZE"`).
- **macOS only:** rebinds <kbd>Opt</kbd>+<kbd>←</kbd> / <kbd>Opt</kbd>+<kbd>→</kbd> to move the cursor backward / forward one word.

## Install

Clone (or symlink) this directory to `~/.config/wezterm`:

```sh
git clone <repo-url> ~/.config/wezterm
```

WezTerm watches the config file and reloads automatically on save. You can also reload manually with <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>.
