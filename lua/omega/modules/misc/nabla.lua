---@type OmegaModule
local nabla = {}

nabla.plugins = {
    ["nabla.nvim"] = {
        "~/neovim_plugins/nabla.nvim",
        ft = {
            "tex",
            -- "norg",
        },
    },
}

return nabla
