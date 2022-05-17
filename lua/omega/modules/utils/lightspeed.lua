---@type OmegaModule
local lightspeed = {}

lightspeed.plugins = {
    ["lightspeed.nvim"] = {
        "ggandor/lightspeed.nvim",
        keys = { "S", "s", "f", "F", "t", "T" },
    },
}

lightspeed.configs={
    ["lightspeed.nvim"]=function()
        vim.cmd([[
            sunmap f
            sunmap F
            sunmap s
            sunmap S
            sunmap t
            sunmap T
        ]])
    end
}

return lightspeed
