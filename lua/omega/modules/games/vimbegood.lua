local vimbegood = {}

vimbegood.plugins = {
    ["vim-be-good"] = {
        "~/neovim_plugins/vim-be-good",
        cmd = "VimBeGood",
    },
}

vimbegood.configs = {
    ["vim-be-good"] = function()
        require("vim-be-good").setup()
    end,
}

return vimbegood
