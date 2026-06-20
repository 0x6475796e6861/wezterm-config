local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- One workspace per server. Each name is also the Host alias in ~/.ssh/config,
-- which supplies HostName, User, Port, IdentityFile, ProxyJump, etc.
M.servers = { 'dev', 'db', 'platform', 'observ' }

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
  -- Connection details are resolved from ~/.ssh/config via the alias; the
  -- remote must have wezterm installed (multiplexing defaults to 'WezTerm').
  config.ssh_domains = config.ssh_domains or {}
  for _, name in ipairs(M.servers) do
    table.insert(config.ssh_domains, {
      name = name,
      remote_address = name,
    })
  end

  -- Fuzzy-select an existing workspace.
  table.insert(config.keys, {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  })

  -- Surface the active workspace name at the right end of the tab bar.
  wezterm.on('update-right-status', function(window)
    window:set_right_status(window:active_workspace())
  end)
end

-- Per-server jump+SSH keys, bound under the given platform modifier (e.g. 'CMD'
-- on macOS, 'CTRL|ALT' elsewhere). First press creates the workspace and SSHes
-- in; later presses just switch back to it. The fuzzy switcher only lists
-- workspaces that already exist, so these are how each one gets created.
function M.add_server_keys(config, mods)
  config.keys = config.keys or {}
  for _, name in ipairs(M.servers) do
    table.insert(config.keys, {
      key = key_for[name],
      mods = mods,
      action = act.SwitchToWorkspace {
        name = name,
        spawn = { domain = { DomainName = name } },
      },
    })
  end
end

return M
