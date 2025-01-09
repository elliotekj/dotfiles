return {
    {
        'epwalsh/obsidian.nvim',
        version = "*",
        lazy = true,
        event = {
            'BufReadPre ' .. vim.fn.expand '~' .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md',
            'BufNewFile ' .. vim.fn.expand '~' .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md'
        },
        cmd = {
            "ObsidianOpen",
            "ObsidianNew",
            "ObsidianToday",
            "ObsidianSearch",
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-treesitter/nvim-treesitter'
        },
        opts = {
            workspaces = {
                {
                    name = 'personal',
                    path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Elliot',
                },
            },
            daily_notes = {
                folder = "00 Daily",
                date_format = "%Y-%m-%d",
            },
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        mappings = {
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            }
        },
        keys = {
            { "<leader>oo", "<cmd>ObsidianSearch<CR>" },
            { "<leader>on", "<cmd>ObsidianNew<CR>" },
            { "<leader>ot", "<cmd>ObsidianToday<CR>" },
        },
    },
    {
        "https://git.sr.ht/~swaits/scratch.nvim",
        lazy = true,
        keys = {
            { "<leader>os", "<cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
        },
        cmd = {
            "Scratch",
            "ScratchSplit",
        },
        opts = {},
    }
}
