local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- Apply macOS-specific configuration to the given config builder.
function M.apply(config)
  config.keys = config.keys or {}

  -- Rebind OPT-Left, OPT-Right to ALT-b, ALT-f so they move the cursor backward and forward one word
  table.insert(config.keys, {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'b', mods = 'ALT' },
  })
  table.insert(config.keys, {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  })

  -- Jump to (or create + SSH into) each server workspace with Cmd+<key>.
  -- Cmd is used instead of Ctrl+Alt because Option is the shell's Meta on macOS.
  require('workspaces').add_server_keys(config, 'CMD')
end

return M
