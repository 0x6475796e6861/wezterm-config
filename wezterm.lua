local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Hide the title bar while keeping the window resizable.
config.window_decorations = 'RESIZE'

-- Workspaces: SSH domains, switcher, create prompt, status bar (cross-platform).
require('workspaces').apply(config)

-- Load platform-specific configuration.
if wezterm.target_triple:find('darwin') ~= nil then
  require('macos').apply(config)
end

return config
