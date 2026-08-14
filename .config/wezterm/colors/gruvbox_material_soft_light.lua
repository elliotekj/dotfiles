-- Gruvbox Material Soft Light palette from sainnhe/gruvbox-material.

local palette = {
  background = '#f2e5bc',
  foreground = '#654735',
  cursor = '#654735',
  selection = '#ebdbb2',
  black = '#ebdbb2',
  red = '#c14a4a',
  green = '#6c782e',
  yellow = '#b47109',
  blue = '#45707a',
  purple = '#945e80',
  cyan = '#4c7a5d',
  white = '#654735',
  bright_black = '#f3eac7',
}

return {
  background = palette.background,
  foreground = palette.foreground,
  cursor_bg = palette.cursor,
  cursor_border = palette.cursor,
  cursor_fg = palette.background,
  selection_bg = palette.selection,
  selection_fg = palette.foreground,
  scrollbar_thumb = '#a89984',
  split = '#a89984',

  ansi = {
    palette.black,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.purple,
    palette.cyan,
    palette.white,
  },

  brights = {
    palette.bright_black,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.purple,
    palette.cyan,
    palette.white,
  },

  tab_bar = {
    background = palette.background,
    active_tab = {
      bg_color = palette.background,
      fg_color = palette.foreground,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = palette.background,
      fg_color = palette.bright_black,
    },
    inactive_tab_hover = {
      bg_color = palette.bright_black,
      fg_color = palette.foreground,
    },
    new_tab = {
      bg_color = palette.background,
      fg_color = palette.blue,
    },
    new_tab_hover = {
      bg_color = palette.bright_black,
      fg_color = palette.foreground,
    },
  },
}
