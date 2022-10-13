---@type OmegaModule
local noice = {}

noice.plugins = {
    ["noice.nvim"] = {
        "folke/noice.nvim",
    },
    ["nvim-notify"] = {
        "rcarriga/nvim-notify",
        module = "notify",
    },
    ["nui.nvim"] = {
        "MunifTanjim/nui.nvim",
        module = { "nui" },
    },
}

noice.configs = {
    ["noice.nvim"] = function()
        vim.o.lazyredraw = false
        require("noice").setup({
            cmdline = {
                enabled = false,
            },
            popupmenu = {
                enabled = false,
            },
            notiy = {
                enabled = false,
            },
        })
    end,
}

return noice
