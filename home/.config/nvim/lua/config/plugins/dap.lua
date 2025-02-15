local function define_colors()
    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#b91c1c" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bold = true })

    vim.fn.sign_define("DapBreakpoint", {
        text = "🔴",
        numhl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
        text = "🔴",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapBreakpointRejected", {
        text = "🔘",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapStopped", {
        text = "🟢",
        linehl = "DapStopped",
        numhl = "DapStopped",
    })
    vim.fn.sign_define("DapLogPoint", {
        text = "🟣",
        linehl = "DapLogPoint",
        numhl = "DapLogPoint",
    })
end

local function setup_default_configurations()
    local dap = require "dap"

    -- Elixir
    dap.adapters.mix_task = {
        type = 'executable',
        command = vim.fn.stdpath("data") .. '/mason/bin/elixir-ls-debugger',
        args = {}
    }
    dap.configurations.elixir = {
        {
            type = "mix_task",
            name = "mix test",
            task = 'test',
            taskArgs = { "--trace" },
            request = "launch",
            startApps = true, -- for Phoenix projects
            projectDir = "${workspaceFolder}",
            requireFiles = {
                "test/**/test_helper.exs",
                "test/**/*_test.exs"
            }
        },
    }
end

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "nvim-telescope/telescope-dap.nvim",
            config = function()
                require("telescope").load_extension "dap"
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            types = true,
        },
        "nvim-neotest/nvim-nio",
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                enabled = true,
            },
        },
    },
    config = function()
        local dap = require "dap"
        local dapui = require "dapui"
        dapui.setup()

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
            require("edgy").close()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        define_colors()
        vim.keymap.set("n", "<F6>", function()
            dap.step_over()
        end)
        vim.keymap.set("n", "<F7>", function()
            dap.step_into()
        end)
        vim.keymap.set("n", "<F8>", function()
            dap.step_out()
        end)
        vim.keymap.set("n", "<leader>b", function()
            dap.toggle_breakpoint()
        end)
        vim.keymap.set("n", "<F10>", function()
            dap.terminate()
        end)

        vim.keymap.set("n", "<F5>", function()
            setup_default_configurations()
            require("dap").continue()
        end)
    end,
}
