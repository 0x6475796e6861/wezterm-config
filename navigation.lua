local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- Cross-platform tab/window naming and switching. Tabs are per-window and
-- independent, so named tabs give labeled contexts without the global-swap
-- behaviour of workspaces.
function M.apply(config)
  config.keys = config.keys or {}

  -- Go to a tab by name (searchable list of the current window's tabs).
  table.insert(config.keys, {
    key = 'g',
    mods = 'CTRL|SHIFT',
    action = act.ShowTabNavigator,
  })

  -- Rename the active tab.
  table.insert(config.keys, {
    key = 'e',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Tab name',
      action = wezterm.action_callback(function(window, _, line)
        if line and line ~= '' then
          window:active_tab():set_title(line)
        end
      end),
    },
  })

  -- Rename the active window.
  table.insert(config.keys, {
    key = 'i',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Window name',
      action = wezterm.action_callback(function(window, _, line)
        if line and line ~= '' then
          window:mux_window():set_title(line)
        end
      end),
    },
  })

  -- The title bar is hidden, so surface the window name at the right of the tab bar.
  wezterm.on('update-right-status', function(window)
    window:set_right_status(window:mux_window():get_title())
  end)
end

return M
