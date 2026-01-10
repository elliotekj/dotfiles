-- Vesper theme for WezTerm
-- Based on https://github.com/raunofreiberg/vesper

local vesper = {
  background = '#101010',
  foreground = '#ffffff',
  dark = '#101010',
  text = '#ffffff',
  selection = '#343434',
  cursor = '#ffc799',
  black = '#101010',
  red = '#ff8080',
  green = '#99ffe4',
  yellow = '#ffc799',
  blue = '#99ffe4',
  magenta = '#ffcfa8',
  cyan = '#99ffe4',
  white = '#ffffff',
  bright_black = '#343434',
}

return {
  background = vesper.background,
  foreground = vesper.foreground,
  cursor_bg = vesper.cursor,
  cursor_border = vesper.cursor,
  cursor_fg = vesper.background,
  selection_bg = vesper.selection,
  selection_fg = vesper.foreground,
  scrollbar_thumb = vesper.bright_black,
  split = vesper.bright_black,

  ansi = {
    vesper.black,
    vesper.red,
    vesper.green,
    vesper.yellow,
    vesper.blue,
    vesper.magenta,
    vesper.cyan,
    vesper.white,
  },

  brights = {
    vesper.bright_black,
    vesper.red,
    vesper.green,
    vesper.yellow,
    vesper.blue,
    vesper.magenta,
    vesper.cyan,
    vesper.white,
  },

  tab_bar = {
    background = vesper.background,
    active_tab = {
      bg_color = vesper.background,
      fg_color = vesper.text,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = vesper.background,
      fg_color = vesper.bright_black,
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = vesper.selection,
      fg_color = vesper.foreground,
    },
    new_tab = {
      bg_color = vesper.background,
      fg_color = vesper.cursor,
    },
    new_tab_hover = {
      bg_color = vesper.selection,
      fg_color = vesper.text,
      italic = true,
    },
  },
}
