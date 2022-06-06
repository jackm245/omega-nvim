local colortils_mod = {}

colortils_mod.plugins = {
    ["colortils.nvim"] = {
        "~/neovim_plugins/colortils.nvim/",
        cmd = "Colortils",
    },
}

colortils_mod.configs = {
    ["colortils.nvim"] = function()
        require("colortils").setup({
            border = require("omega.utils").border(),
        })
    end,
}

return colortils_mod
