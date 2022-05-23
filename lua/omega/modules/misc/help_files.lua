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
}

return help_file
