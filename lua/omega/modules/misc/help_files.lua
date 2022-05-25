---@type OmegaModule
local help_file = {}

help_file.plugins = {
    ["luv-vimdocs"] = {
        "nanotee/luv-vimdocs",
        cmd = { "Telescope", "h" },
    },
    ["nvim-luaref"] = {
        "milisims/nvim-luaref",
        cmd = { "Telescope", "h" },
    },
    ["help_files"] = {
        "~/neovim_plugins/help_files/",
        cmd = { "Telescope", "h" },
    },
}

return help_file
