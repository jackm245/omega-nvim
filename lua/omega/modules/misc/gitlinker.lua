---@type OmegaModule
local gitlinker = {}

gitlinker.plugins = {
    ["gitlinker.nvim"] = {
        "ruifm/gitlinker.nvim",
        keys = { "<leader>gy" },
    },
}

gitlinker.configs = {
    ["gitlinker.nvim"] = function()
        require("gitlinker").setup()
    end,
}

gitlinker.keybindings = function()
    require("which-key").register(
        { y = "Copy Link" },
        { mode = "n", prefix = "<leader>g" }
    )
    require("which-key").register(
        { g = { name = " Git", y = "Copy Link" } },
        { mode = "v", prefix = "<leader>" }
    )
end

return gitlinker
