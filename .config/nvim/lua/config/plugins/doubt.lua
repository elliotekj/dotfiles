return {
  {
    'makefinks/doubt.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      local prefix = '<localleader>r'

      local function theme_colors()
        local function highlight(name)
          return vim.api.nvim_get_hl(0, { name = name, link = false })
        end

        local function color(name, attribute, fallback)
          return highlight(name)[attribute] or fallback
        end

        local normal = highlight('Normal')
        local normal_float = highlight('NormalFloat')
        local background = normal.bg or normal_float.bg
        local foreground = normal.fg or normal_float.fg
        if not background or not foreground then
          return nil
        end
        local surface = normal_float.bg or background
        local muted = color('Comment', 'fg', foreground)

        local function blend(foreground_color, background_color, amount)
          local function channel(color_value, divisor)
            return math.floor(color_value / divisor) % 256
          end

          local red = math.floor(channel(foreground_color, 65536) * amount + channel(background_color, 65536) * (1 - amount) + 0.5)
          local green = math.floor(channel(foreground_color, 256) * amount + channel(background_color, 256) * (1 - amount) + 0.5)
          local blue = math.floor(channel(foreground_color, 1) * amount + channel(background_color, 1) * (1 - amount) + 0.5)
          return red * 65536 + green * 256 + blue
        end

        local blue = color('Identifier', 'fg', foreground)
        local yellow = color('Type', 'fg', color('WarningMsg', 'fg', foreground))
        local red = color('Error', 'fg', foreground)
        local green = color('String', 'fg', color('DiagnosticOk', 'fg', foreground))
        local orange = color('Operator', 'fg', color('SpecialKey', 'fg', foreground))

        return {
          background = background,
          surface = surface,
          foreground = foreground,
          muted = muted,
          faint = color('NonText', 'fg', muted),
          border = color('FloatBorder', 'fg', muted),
          blue = blue,
          yellow = yellow,
          red = red,
          green = green,
          orange = orange,
          question_visual = color('DiffChange', 'bg', blend(blue, background, 0.2)),
          concern_visual = blend(yellow, background, 0.2),
          reject_visual = color('DiffDelete', 'bg', blend(red, background, 0.2)),
          addressed_visual = color('DiffAdd', 'bg', blend(green, background, 0.2)),
          active = color('CursorLine', 'bg', surface),
        }
      end

      local function apply_doubt_highlights()
        local p = theme_colors()
        if not p then
          return
        end
        local set = vim.api.nvim_set_hl

        local claims = {
          Question = { accent = p.blue, visual = p.question_visual },
          Concern = { accent = p.yellow, visual = p.concern_visual },
          Reject = { accent = p.red, visual = p.reject_visual },
        }

        for kind, colors in pairs(claims) do
          set(0, 'Doubt' .. kind, { fg = colors.accent, bg = colors.visual, bold = true })
          set(0, 'DoubtStale' .. kind, { fg = p.muted, bg = p.surface, italic = true })
          set(0, 'DoubtDim' .. kind, { fg = p.muted, bg = p.surface })
          set(0, 'DoubtDimStale' .. kind, { fg = p.muted, bg = p.surface, italic = true })
          set(0, 'DoubtPanelActive' .. kind .. 'Border', { fg = colors.accent, bold = true })
          set(0, 'DoubtPanelActiveStale' .. kind .. 'Border', { fg = p.muted, italic = true })
          set(0, 'DoubtInline' .. kind .. 'Label', { fg = p.background, bg = colors.accent, bold = true })
          set(0, 'DoubtInline' .. kind .. 'Text', { fg = p.foreground, bg = p.background, italic = true })
          set(0, 'DoubtInlineDim' .. kind .. 'Label', { fg = p.muted, bg = p.surface, bold = true })
          set(0, 'DoubtInlineDim' .. kind .. 'Text', { fg = p.muted, bg = p.background, italic = true })
        end

        set(0, 'DoubtFile', { fg = p.yellow, bold = true })
        set(0, 'DoubtInlinePrefix', { fg = p.faint })
        set(0, 'DoubtInlineBar', { fg = p.background, bg = p.background })
        set(0, 'DoubtInlineAddressed', { fg = p.green, bg = p.addressed_visual })
        set(0, 'DoubtInlineResponseWarning', { fg = p.yellow, bg = p.concern_visual })
        set(0, 'DoubtInlineAgentResponseLabel', { fg = p.green, bg = p.background })
        set(0, 'DoubtInlineAgentResponseText', { fg = p.foreground, bg = p.background })
        set(0, 'DoubtInlineAgentResponseWarningLabel', { fg = p.yellow, bg = p.background })
        set(0, 'DoubtInlineAgentResponseWarningText', { fg = p.foreground, bg = p.background })
        set(0, 'DoubtInlineEditingBar', { fg = p.background, bg = p.background })
        set(0, 'DoubtInlineEditingBadge', { fg = p.yellow, bg = p.background, bold = true })

        set(0, 'DoubtPanelTitle', { fg = p.yellow, bold = true })
        set(0, 'DoubtPanelSection', { fg = p.foreground, bold = true })
        set(0, 'DoubtPanelFile', { fg = p.blue, bold = true })
        set(0, 'DoubtPanelSession', { fg = p.green, bold = true })
        set(0, 'DoubtPanelCount', { fg = p.yellow, bold = true })
        set(0, 'DoubtPanelKey', { fg = p.orange, bold = true })
        set(0, 'DoubtPanelMuted', { fg = p.muted })
        set(0, 'DoubtPanelStale', { fg = p.orange, italic = true })
        set(0, 'DoubtPanelDiff', { fg = p.green, bold = true })
        set(0, 'DoubtPanelDiffWarning', { fg = p.yellow, bold = true })
        set(0, 'DoubtPanelAgentResponse', { bg = p.addressed_visual })
        set(0, 'DoubtPanelAgentResponseWarning', { bg = p.concern_visual })
        set(0, 'DoubtPanelActiveClaim', { bg = p.active })
        set(0, 'DoubtPanelMarkdownCode', { fg = p.yellow, bg = p.surface })
        set(0, 'DoubtPanelMarkdownBold', { fg = p.yellow, bold = true })
        set(0, 'DoubtPanelMarkdownItalic', { fg = p.muted, italic = true })
        set(0, 'DoubtInlineMarkdownCode', { fg = p.yellow })
        set(0, 'DoubtInlineMarkdownBold', { fg = p.yellow, bold = true })
        set(0, 'DoubtPanelHelpNormal', { fg = p.foreground })
        set(0, 'DoubtPanelHelpTitle', { fg = p.yellow, bold = true })
        set(0, 'DoubtPanelHelpSection', { fg = p.blue, bold = true })
        set(0, 'DoubtPanelHelpBorder', { fg = p.border })
        set(0, 'DoubtPanelHelpText', { fg = p.foreground })
      end

      require('doubt').setup({
        keymaps = {
          agent_instructions = prefix .. 'a',
          question = prefix .. 'q',
          concern = prefix .. 'c',
          reject = prefix .. 'r',
          delete_claim = prefix .. 'd',
          edit_kind = prefix .. 'k',
          edit_note = prefix .. 'm',
          toggle_claim = prefix .. 't',
          export = prefix .. 'e',
          export_picker = prefix .. 'E',
          clear_buffer = prefix .. 'B',
          panel = prefix .. 'p',
          session_new = prefix .. 'n',
          session_resume = prefix .. 's',
          stop_session = prefix .. 'x',
          refresh = prefix .. 'f',
        },
      })

      apply_doubt_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('DoubtTheme', { clear = true }),
        callback = apply_doubt_highlights,
      })
    end,
  },
}
