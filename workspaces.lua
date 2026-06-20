local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- Cross-platform workspace setup: SSH domains, switcher, create prompt, status bar.
function M.apply(config)
  config.keys = config.keys or {}

  -- SSH domains are generated from every Host in ~/.ssh/config, so any server
  -- can back a workspace without hardcoding it here. Remotes need wezterm
  -- installed for the multiplexing (SSHMUX) variants.
  config.ssh_domains = wezterm.default_ssh_domains()

  -- Fuzzy-select an existing workspace.
  table.insert(config.keys, {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  })

  -- Prompt for a name, then switch to (creating if needed) that workspace.
  table.insert(config.keys, {
    key = 'n',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter name for new workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= '' then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  })

  -- Surface the active workspace name at the right end of the tab bar.
  wezterm.on('update-right-status', function(window)
    window:set_right_status(window:active_workspace())
  end)
end

return M
