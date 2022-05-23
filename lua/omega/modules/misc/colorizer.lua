---@type OmegaModule
local colorizer = {}

colorizer.plugins = {
    ["nvim-colorizer.lua"] = {
        "xiyaowong/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer" },
    },
}
colorizer.configs = {
    ["nvim-colorizer.lua"] = function()
        require("colorizer").setup({
            "*",
        }, {
            mode = "foreground",
            hsl_fn = true,
        })
        vim.cmd([[ColorizerAttachToBuffer]])
    end,
}

colorizer.keybindings = function()
    require("which-key").register(
        { c = { "<cmd>ColorizerAttachToBuffer<cr>", "Colorizer" } },
        { mode = "n", prefix = "<leader>v" }
    )
end

return colorizer
