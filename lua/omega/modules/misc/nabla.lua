---@type OmegaModule
local nabla = {}

nabla.plugins = {
    ["nabla.nvim"] = {
        "~/neovim_plugins/nabla.nvim",
        -- "jbyuki/nabla.nvim",
        ft = {
            "tex",
            "norg",
        },
    },
}

return nabla
