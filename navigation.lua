local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

local M = {}

-- Windows we've already prompted to name, keyed by window id, so the auto-prompt
-- fires at most once per window.
local prompted = {}

local function rename_window(window, line)
  if line and line ~= '' then
    window:mux_window():set_title(line)
  end
end

-- Fuzzy tab picker across every window, each entry labelled "<window> / <tab>"
-- so the window name is shown and included in the filter text.
local tab_navigator = wezterm.action_callback(function(window, pane)
  local choices = {}
  for _, win in ipairs(mux.all_windows()) do
    local win_title = win:get_title()
    for _, tab in ipairs(win:tabs()) do
      table.insert(choices, {
        id = tostring(tab:tab_id()),
        label = string.format('%s / %s', win_title, tab:get_title()),
      })
    end
  end

  window:perform_action(act.InputSelector {
    title = 'Go to tab',
    fuzzy = true,
    choices = choices,
    action = wezterm.action_callback(function(_, _, id)
      if not id then
        return
      end
      for _, win in ipairs(mux.all_windows()) do
        for _, tab in ipairs(win:tabs()) do
          if tostring(tab:tab_id()) == id then
            tab:activate()
            local gui = win:gui_window()
            if gui then
              gui:focus()
            end
            return
          end
        end
      end
    end),
  }, pane)
end)

-- Cross-platform tab/window naming and switching. Tabs are per-window and
-- independent, so named tabs give labeled contexts without the global-swap
-- behaviour of workspaces.
function M.apply(config)
  config.keys = config.keys or {}

  -- Go to a tab by name, across all windows.
  table.insert(config.keys, {
    key = 'g',
    mods = 'CTRL|SHIFT',
    action = tab_navigator,
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
        prompted[window:window_id()] = true
        rename_window(window, line)
      end),
    },
  })

  -- When a window first gains focus (i.e. opens), prompt for its name once.
  wezterm.on('window-focus-changed', function(window, pane)
    local id = window:window_id()
    if window:is_focused() and not prompted[id] then
      prompted[id] = true
      window:perform_action(act.PromptInputLine {
        description = 'Window name',
        action = wezterm.action_callback(function(win, _, line)
          rename_window(win, line)
        end),
      }, pane)
    end
  end)

  -- The title bar is hidden, so surface the window name at the right of the tab bar.
  wezterm.on('update-right-status', function(window)
    window:set_right_status(window:mux_window():get_title())
  end)
end

return M
