local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Hide the title bar while keeping the window resizable.
config.window_decorations = 'RESIZE'

-- Workspaces: SSH domains, fuzzy switcher, status bar (cross-platform).
require('workspaces').apply(config)

-- Load platform-specific configuration, including per-server jump keys whose
-- modifier differs by platform (Cmd on macOS, Ctrl+Alt elsewhere).
if wezterm.target_triple:find('darwin') ~= nil then
  require('macos').apply(config)
else
  require('workspaces').add_server_keys(config, 'CTRL|ALT')
end

return config
