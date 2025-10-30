local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local colors = require('colors.monokai-pro')

config.colors = colors
config.font = wezterm.font 'TX-02'
config.font_size = 15.0
config.line_height = 1.2

config.use_fancy_tab_bar = false
config.window_decorations = 'RESIZE'

config.scrollback_lines = 5000

config.keys = {
  -- Fix shift+enter for claude code
  {
    key="Enter",
    mods="SHIFT",
    action=wezterm.action{SendString="\x1b\r"}
  },
  -- Pane splitting
  -- CMD+d for horizontal split (right), CMD+Shift+d for vertical split (down)
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+y for horizontal split
        window:perform_action(wezterm.action.SendString("\x19"), pane)
      else
        -- Not in tmux: split WezTerm pane horizontally
        window:perform_action(wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, pane)
      end
    end),
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+q for vertical split
        window:perform_action(wezterm.action.SendString("\x11"), pane)
      else
        -- Not in tmux: split WezTerm pane vertically
        window:perform_action(wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }, pane)
      end
    end),
  },

  -- Pane navigation with CMD+Shift+h/j/k/l
  {
    key = 'h',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+Left arrow
        window:perform_action(wezterm.action.SendKey { key = 'LeftArrow', mods = 'CTRL' }, pane)
      else
        -- Not in tmux: navigate WezTerm panes
        window:perform_action(wezterm.action.ActivatePaneDirection 'Left', pane)
      end
    end),
  },
  {
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+Right arrow
        window:perform_action(wezterm.action.SendKey { key = 'RightArrow', mods = 'CTRL' }, pane)
      else
        -- Not in tmux: navigate WezTerm panes
        window:perform_action(wezterm.action.ActivatePaneDirection 'Right', pane)
      end
    end),
  },
  {
    key = 'k',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+Up arrow
        window:perform_action(wezterm.action.SendKey { key = 'UpArrow', mods = 'CTRL' }, pane)
      else
        -- Not in tmux: navigate WezTerm panes
        window:perform_action(wezterm.action.ActivatePaneDirection 'Up', pane)
      end
    end),
  },
  {
    key = 'j',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+Down arrow
        window:perform_action(wezterm.action.SendKey { key = 'DownArrow', mods = 'CTRL' }, pane)
      else
        -- Not in tmux: navigate WezTerm panes
        window:perform_action(wezterm.action.ActivatePaneDirection 'Down', pane)
      end
    end),
  },

  -- Close current pane/tmux pane
  -- Don't intercept if Helix is running (let it handle Ctrl+W for window nav)
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()

      local function is_helix(name)
        if not name then return false end
        local basename = name:match("([^/]+)$") or name
        return basename == "hx" or basename:find("^hx%s") or basename:find("helix")
      end

      -- If Helix is running, pass through Ctrl+W so Helix can handle window navigation
      if is_helix(process_name) then
        window:perform_action(wezterm.action.SendKey { key = 'w', mods = 'CTRL' }, pane)
        return
      end

      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+W to close tmux pane
        window:perform_action(wezterm.action.SendString("\x17"), pane)
      else
        -- Not in tmux: close WezTerm pane
        window:perform_action(wezterm.action.CloseCurrentPane { confirm = true }, pane)
      end
    end),
  },

  -- Toggle pane zoom
  {
    key = 'z',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      local process_name = pane:get_foreground_process_name()
      if process_name and process_name:find("tmux") then
        -- In tmux: send Ctrl+\ to toggle zoom
        window:perform_action(wezterm.action.SendString("\x1c"), pane)
      else
        -- Not in tmux: zoom WezTerm pane
        window:perform_action(wezterm.action.TogglePaneZoomState, pane)
      end
    end),
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
