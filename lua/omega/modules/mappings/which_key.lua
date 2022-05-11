local which_key = {}

which_key.plugins = {
    ["which-key.nvim"] = {
        "~/neovim_plugins/which-key.nvim",
    },
}

which_key.config = {
    ["which-key.nvim"] = function()
        require("which-key").setup({
            show_help = false,
            layout = {
                height = { max = 20 },
                spacing = 5, -- spacing between columns
            },
            window = {
                -- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
                border = border,
                margin = { 1, 0, 1, 0 }, -- top right bottom left
                -- padding = { 1, 2, 1, 3 }, -- top right bottom left
                padding = { 0, 2, 0, 0 }, -- top right bottom left
                winblend = 0,
                -- winblend = 10,
            },
            icons = {
                group = " ",
                label = " ",
            },
        })

        vim.api.nvim_set_hl(0, "WhichKeyFloat", { link = "Special" })
        vim.api.nvim_set_hl(0, "WhichKey", { link = "Special" })
    end,
}

return which_key
