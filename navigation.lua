local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

local M = {}

-- Our own window-name store, keyed by window id as a STRING (wezterm.GLOBAL
-- objects can only be indexed by string keys). Window names live here rather
-- than in the mux window title because the shell continuously overwrites the
-- window title via OSC escape sequences, so a title-based name never sticks.
-- GLOBAL persists across config reloads; window ids and GLOBAL both reset on
-- app restart, so the "window-<id>" defaults reapply cleanly.
wezterm.GLOBAL.window_names = wezterm.GLOBAL.window_names or {}

-- Read a window's name, assigning the default "window-<id>" the first time.
local function window_name(win)
  local key = tostring(win:window_id())
  local names = wezterm.GLOBAL.window_names
  if names[key] == nil then
    names[key] = 'untitled-window-' .. key
    -- Reassign the whole table: GLOBAL ignores in-place writes to nested tables.
    wezterm.GLOBAL.window_names = names
  end
  return names[key]
end

-- Store a new name for a window.
local function set_window_name(win, name)
  local key = tostring(win:window_id())
  local names = wezterm.GLOBAL.window_names
  names[key] = name
  wezterm.GLOBAL.window_names = names
end

-- Materialize a tab's default title ("tab-<id>") while it is unset, then return
-- it. Tab titles are independent of the shell's OSC sequences, so this sticks
-- and `wezterm cli set-tab-title` works normally.
local function ensure_tab_title(tab)
  if tab:get_title() == '' then
    tab:set_title('untitled-tab-' .. tostring(tab:tab_id()))
  end
  return tab:get_title()
end

-- Fuzzy tab picker across every window, exposed via the command palette. Each
-- entry is "<window> / <tab>", so typing a window name narrows to its tabs.
local function tab_navigator(window, pane)
  local choices = {}
  for _, win in ipairs(mux.all_windows() or {}) do
    local wl = window_name(win)
    for _, tab in ipairs(win:tabs() or {}) do
      table.insert(choices, {
        id    = tostring(tab:tab_id()),
        label = wl .. ' / ' .. ensure_tab_title(tab),
      })
    end
  end

  if #choices == 0 then
    return
  end

  window:perform_action(act.InputSelector {
    title   = 'Go to tab',
    fuzzy   = true,
    choices = choices,
    -- The selected id is the tab_id as a string. Find the matching tab,
    -- activate it, then bring its window to the front.
    action  = wezterm.action_callback(function(_, _, id)
      if not id then
        return
      end
      for _, win in ipairs(mux.all_windows() or {}) do
        for _, tab in ipairs(win:tabs() or {}) do
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
end

-- Prompt to rename the active tab (sets the real mux tab title).
local function rename_tab(window, pane)
  window:perform_action(act.PromptInputLine {
    description = 'Tab name',
    action = wezterm.action_callback(function(win, _, line)
      if line and line ~= '' then
        win:active_tab():set_title(line)
      end
    end),
  }, pane)
end

-- Prompt to rename the current window. The shell owns the window title, so a
-- name can't go through `wezterm cli set-window-title`; this writes our store.
local function rename_window(window, pane)
  window:perform_action(act.PromptInputLine {
    description = 'Window name',
    action = wezterm.action_callback(function(win, _, line)
      if line and line ~= '' then
        set_window_name(win:mux_window(), line)
      end
    end),
  }, pane)
end

function M.apply(config)
  -- Keep the default "<index>: <title>" tab-bar look; the title text falls back
  -- to "tab-<id>" until renamed. ensure_tab_title materializes the same value,
  -- so the bar, the navigator, and `wezterm cli list` agree.
  wezterm.on('format-tab-title', function(tab)
    local title = tab.tab_title
    if title == nil or title == '' then
      title = 'untitled-tab-' .. tostring(tab.tab_id)
    end
    return string.format('%d: %s', tab.tab_index + 1, title)
  end)

  -- The navigator and window rename live in the command palette
  -- (Cmd/Ctrl+Shift+P) instead of key bindings.
  wezterm.on('augment-command-palette', function()
    return {
      { brief = 'Go to tab',     icon = 'md_tab_search',  action = wezterm.action_callback(tab_navigator) },
      { brief = 'Rename tab',    icon = 'md_rename_box',  action = wezterm.action_callback(rename_tab) },
      { brief = 'Rename window', icon = 'md_dock_window', action = wezterm.action_callback(rename_window) },
    }
  end)

  -- Materialize default tab titles for the focused window, and show the window
  -- name bottom-right (the OS title bar is hidden).
  wezterm.on('update-right-status', function(window)
    local mw = window:mux_window()
    for _, tab in ipairs(mw:tabs() or {}) do
      ensure_tab_title(tab)
    end
    -- Trailing spaces pad the name off the right edge of the tab bar.
    window:set_right_status(window_name(mw) .. '  ')
  end)
end

return M
