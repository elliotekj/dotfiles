-- Rose Pine theme for WezTerm
-- Based on https://rosepinetheme.com

local rose_pine = {
  base = '#191724',
  surface = '#1f1d2e',
  overlay = '#26233a',
  muted = '#6e6a86',
  subtle = '#908caa',
  text = '#e0def4',
  love = '#eb6f92',
  gold = '#f6c177',
  rose = '#ebbcba',
  pine = '#31748f',
  foam = '#9ccfd8',
  iris = '#c4a7e7',
  highlight_low = '#21202e',
  highlight_med = '#403d52',
  highlight_high = '#524f67',
  green = '#a3be8c',
}

return {
  background = rose_pine.base,
  foreground = rose_pine.text,
  cursor_bg = rose_pine.rose,
  cursor_border = rose_pine.rose,
  cursor_fg = rose_pine.base,
  selection_bg = rose_pine.highlight_med,
  selection_fg = rose_pine.text,
  scrollbar_thumb = rose_pine.highlight_high,
  split = rose_pine.highlight_high,

  ansi = {
    rose_pine.overlay,
    rose_pine.love,
    rose_pine.green,
    rose_pine.gold,
    rose_pine.pine,
    rose_pine.iris,
    rose_pine.foam,
    rose_pine.text,
  },

  brights = {
    rose_pine.muted,
    rose_pine.love,
    rose_pine.green,
    rose_pine.gold,
    rose_pine.pine,
    rose_pine.iris,
    rose_pine.foam,
    rose_pine.text,
  },

  tab_bar = {
    background = rose_pine.base,
    active_tab = {
      bg_color = rose_pine.base,
      fg_color = rose_pine.text,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = rose_pine.base,
      fg_color = rose_pine.muted,
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = rose_pine.surface,
      fg_color = rose_pine.text,
    },
    new_tab = {
      bg_color = rose_pine.base,
      fg_color = rose_pine.rose,
    },
    new_tab_hover = {
      bg_color = rose_pine.surface,
      fg_color = rose_pine.text,
      italic = true,
    },
  },
}
