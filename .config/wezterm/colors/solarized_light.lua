local sol = {
  base03  = '#002b36',
  base02  = '#073642',
  base01  = '#586e75',
  base00  = '#657b83',
  base0   = '#839496',
  base1   = '#93a1a1',
  base2   = '#eee8d5',
  base3   = '#fdf6e3',
  yellow  = '#b58900',
  orange  = '#cb4b16',
  red     = '#dc322f',
  magenta = '#d33682',
  violet  = '#6c71c4',
  blue    = '#268bd2',
  cyan    = '#2aa198',
  green   = '#859900',
}

return {
  background = sol.base3,
  foreground = sol.base00,
  cursor_bg = sol.base01,
  cursor_border = sol.base01,
  cursor_fg = sol.base3,
  selection_bg = sol.base2,
  selection_fg = sol.base01,
  scrollbar_thumb = sol.base2,
  split = sol.base1,

  ansi = {
    sol.base02,
    sol.red,
    sol.green,
    sol.yellow,
    sol.blue,
    sol.magenta,
    sol.cyan,
    sol.base2,
  },

  brights = {
    sol.base03,
    sol.orange,
    sol.base01,
    sol.base00,
    sol.base0,
    sol.violet,
    sol.base1,
    sol.base3,
  },

  tab_bar = {
    background = sol.base2,
    active_tab = {
      bg_color = sol.base3,
      fg_color = sol.base01,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = sol.base2,
      fg_color = sol.base00,
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = sol.base3,
      fg_color = sol.base01,
    },
    new_tab = {
      bg_color = sol.base2,
      fg_color = sol.blue,
    },
    new_tab_hover = {
      bg_color = sol.base3,
      fg_color = sol.base01,
      italic = true,
    },
  },
}
