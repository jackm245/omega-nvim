---@type OmegaModule
local lightspeed = {}

lightspeed.plugins = {
    ["lightspeed.nvim"] = {
        "ggandor/lightspeed.nvim",
        keys = { "S", "s", "f", "F", "t", "T" },
    },
}

return lightspeed
