-- Gruvbox Material Soft Dark palette from sainnhe/gruvbox-material.

local palette = {
  background = '#32302f',
  foreground = '#d4be98',
  cursor = '#d4be98',
  selection = '#45403d',
  black = '#252423',
  red = '#ea6962',
  green = '#a9b665',
  yellow = '#d8a657',
  blue = '#7daea3',
  purple = '#d3869b',
  cyan = '#89b482',
  white = '#d4be98',
  bright_black = '#32302f',
}

return {
  background = palette.background,
  foreground = palette.foreground,
  cursor_bg = palette.cursor,
  cursor_border = palette.cursor,
  cursor_fg = palette.background,
  selection_bg = palette.selection,
  selection_fg = palette.foreground,
  scrollbar_thumb = palette.bright_black,
  split = palette.bright_black,

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
