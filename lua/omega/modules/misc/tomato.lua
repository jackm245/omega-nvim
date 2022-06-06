local tomato = {}

tomato.plugins = {
    ["tomato.nvim"] = { "~/neovim_plugins/pomodoro.nvim" },
}

tomato.configs = {
    ["tomato.nvim"] = function()
        require("tomato").setup()
    end,
}

return tomato
