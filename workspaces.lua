local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- One workspace per server. These are PLACEHOLDERS — edit remote_address and
-- username for each box before the jump keys will actually connect.
M.servers = {
  { name = 'dev',      remote_address = 'dev.example.com',      username = 'user' },
  { name = 'db',       remote_address = 'db.example.com',       username = 'user' },
  { name = 'platform', remote_address = 'platform.example.com', username = 'user' },
  { name = 'observ',   remote_address = 'observ.example.com',   username = 'user' },
}

-- Mnemonic key letter per server (combined with a platform modifier elsewhere).
local key_for = {
  dev = 'd',
  db = 'b',
  platform = 'p',
  observ = 'o',
}

-- Cross-platform workspace setup: SSH domains, fuzzy switcher, status bar.
function M.apply(config)
  config.keys = config.keys or {}

  -- One ssh_domain per server, so a workspace can spawn directly into it.
  config.ssh_domains = config.ssh_domains or {}
  for _, s in ipairs(M.servers) do
    table.insert(config.ssh_domains, {
      name = s.name,
      remote_address = s.remote_address,
      username = s.username,
    })
  end

  -- Fuzzy-select an existing workspace.
  table.insert(config.keys, {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  })

  -- Surface the active workspace name in the bottom-right status area.
  wezterm.on('update-right-status', function(window, _pane)
    window:set_right_status(window:active_workspace())
  end)
end

-- Per-server jump+SSH keys, bound under the given platform modifier (e.g. 'CMD'
-- on macOS, 'CTRL|ALT' elsewhere). First press creates the workspace and SSHes
-- in; later presses just switch back to it. The fuzzy switcher only lists
-- workspaces that already exist, so these are how each one gets created.
function M.add_server_keys(config, mods)
  config.keys = config.keys or {}
  for _, s in ipairs(M.servers) do
    table.insert(config.keys, {
      key = key_for[s.name],
      mods = mods,
      action = act.SwitchToWorkspace {
        name = s.name,
        spawn = { domain = { DomainName = s.name } },
      },
    })
  end
end

return M
