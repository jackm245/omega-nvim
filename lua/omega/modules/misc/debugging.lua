---@type OmegaModule
local debugging = {}

debugging.plugins = {
    ["nvim-dap"] = {
        "mfussenegger/nvim-dap",
        after = "rust-tools.nvim",
        module = "dap",
    },
    ["nvim-dap-ui"] = {
        "rcarriga/nvim-dap-ui",
        opt = true,
    },
    ["nvim-dap-virtual-text"] = {
        "theHamsta/nvim-dap-virtual-text",
        after = "nvim-dap",
    },
}

debugging.configs = {
    ["nvim-dap"] = function()
        vim.fn.sign_define(
            "DapBreakpoint",
            { text = "⧐", texthl = "Error", linehl = "", numhl = "" }
        )
        vim.fn.sign_define(
            "DapStopped",
            { text = "⧐", texthl = "TSString", linehl = "", numhl = "" }
        )
        vim.cmd([[PackerLoad nvim-dap-ui]])
    end,
    ["nvim-dap-ui"] = function()
        require("dapui").setup({
            mappings = { toggle = "<tab>" },
        })
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,
    ["nvim-dap-virtual-text"] = function()
        require("nvim-dap-virtual-text").setup()
    end,
}

debugging.keybindings = function()
    require("which-key").register({
        d = {
            name = " Debug",
            s = {
                name = "Step",
                o = {
                    function()
                        require("dap").step_out()
                    end,
                    "Out",
                },
                O = {
                    function()
                        require("dap").step_over()
                    end,
                    "Over",
                },
                i = {
                    function()
                        require("dap").step_into()
                    end,
                    "Into",
                },
            },
            b = {
                name = "Breakpoint",
                t = {
                    function()
                        require("dap").toggle_breakpoint()
                    end,
                    "Toggle",
                },
            },
            R = {
                function()
                    require("dap").run_to_cursor()
                end,
                "Run to cursor",
            },
        },
    }, {
        mode = "n",
        prefix = "<leader>",
    })
end

return debugging
