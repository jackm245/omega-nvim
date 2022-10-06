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
        require("noice").setup({
            cmdline = {
                -- view = "cmdline",
            },
        })
    end,
}

return noice
