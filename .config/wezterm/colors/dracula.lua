local dracula = {
  background = '#282a36',
  current_line = '#44475a',
  foreground = '#f8f8f2',
  comment = '#6272a4',
  cyan = '#8be9fd',
  green = '#50fa7b',
  orange = '#ffb86c',
  pink = '#ff79c6',
  purple = '#bd93f9',
  red = '#ff5555',
  yellow = '#f1fa8c',
}

return {
  background = dracula.background,
  foreground = dracula.foreground,
  cursor_bg = dracula.foreground,
  cursor_border = dracula.foreground,
  cursor_fg = dracula.background,
  selection_bg = dracula.current_line,
  selection_fg = dracula.foreground,
  scrollbar_thumb = dracula.current_line,
  split = dracula.comment,

  ansi = {
    '#21222c',
    dracula.red,
    dracula.green,
    dracula.yellow,
    dracula.purple,
    dracula.pink,
    dracula.cyan,
    dracula.foreground,
  },

  brights = {
    dracula.comment,
    dracula.red,
    dracula.green,
    dracula.yellow,
    dracula.purple,
    dracula.pink,
    dracula.cyan,
    '#ffffff',
  },

  tab_bar = {
    background = dracula.background,
    active_tab = {
      bg_color = dracula.background,
      fg_color = dracula.foreground,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = dracula.background,
      fg_color = dracula.comment,
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = dracula.current_line,
      fg_color = dracula.foreground,
    },
    new_tab = {
      bg_color = dracula.background,
      fg_color = dracula.purple,
    },
    new_tab_hover = {
      bg_color = dracula.current_line,
      fg_color = dracula.foreground,
      italic = true,
    },
  },
}
