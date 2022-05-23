---@type OmegaModule
local cs_switcher = {}

cs_switcher.plugins = {
    ["colorscheme_switcher"] = {
        "~/neovim_plugins/colorscheme_switcher/",
        module = { "colorscheme_switcher" },
    },
}

return cs_switcher
