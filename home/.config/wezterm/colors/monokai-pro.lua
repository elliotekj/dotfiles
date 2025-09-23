-- Monokai Pro theme for WezTerm
-- Converted from iTerm2 color scheme

local monokai_pro = {
  background = '#2d2a2e',
  foreground = '#fcfcfa',
  dark = '#2d2a2e',
  text = '#fcfcfa',
  selection = '#5b595c',
  cursor = '#c1c0c0',
  black = '#2d2a2e',
  red = '#ff6188',
  green = '#a9dc76',
  yellow = '#ffd866',
  blue = '#fc9867',
  magenta = '#ab9df2',
  cyan = '#78dce8',
  white = '#fcfcfa',
  bright_black = '#727072',
}

return {
  background = monokai_pro.background,
  foreground = monokai_pro.foreground,
  cursor_bg = monokai_pro.cursor,
  cursor_border = monokai_pro.cursor,
  cursor_fg = monokai_pro.cursor,
  selection_bg = monokai_pro.selection,
  selection_fg = monokai_pro.foreground,
  scrollbar_thumb = monokai_pro.bright_black,
  split = monokai_pro.bright_black,
  
  ansi = {
    monokai_pro.black,     
    monokai_pro.red,     
    monokai_pro.green,     
    monokai_pro.yellow,     
    monokai_pro.blue,     
    monokai_pro.magenta,     
    monokai_pro.cyan,     
    monokai_pro.white,     
  },
  
  brights = {
    monokai_pro.bright_black, 
    monokai_pro.red,        
    monokai_pro.green,        
    monokai_pro.yellow,     
    monokai_pro.blue,       
    monokai_pro.magenta, 
    monokai_pro.cyan,     
    monokai_pro.white,    
  },
  
  tab_bar = {
    background = monokai_pro.background,
    active_tab = {
      bg_color = monokai_pro.background,
      fg_color = monokai_pro.text,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = monokai_pro.background,
      fg_color = monokai_pro.bright_black,
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = monokai_pro.selection,
      fg_color = monokai_pro.foreground,
    },
    new_tab = {
      bg_color = monokai_pro.background,
      fg_color = monokai_pro.cursor,
    },
    new_tab_hover = {
      bg_color = monokai_pro.selection,
      fg_color = monokai_pro.text,
      italic = true,
    },
  },
}
