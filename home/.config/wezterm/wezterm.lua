local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local colors = require('colors.monokai-pro')

config.colors = colors
config.font = wezterm.font 'TX-02'
config.font_size = 15.0
config.line_height = 1.2

config.use_fancy_tab_bar = false
config.window_decorations = 'RESIZE'

config.keys = {
  -- Fix shift+enter for claude code
  {
    key="Enter",
    mods="SHIFT",
    action=wezterm.action{SendString="\x1b\r"}
  },
  -- Pane splitting
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Pane navigation
  {
    key = 'h',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },

  -- Close current pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- Toggle pane zoom (maximize/restore)
  {
    key = 'z',
    mods = 'CMD',
    action = wezterm.action.TogglePaneZoomState,
  },

  -- Quick pane selection (shows overlay with letters)
  {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action.PaneSelect,
  },

  -- Rename current tab
  {
    key = ',',
    mods = 'CMD',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  }
}

return config
