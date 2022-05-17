---@type OmegaModule
local lightspeed = {}

lightspeed.plugins = {
    ["lightspeed.nvim"] = {
        "ggandor/lightspeed.nvim",
        keys = { "S", "s", "f", "F", "t", "T" },
        setup = function()
            vim.g.lightspeed_no_default_keymaps = true
            vim.keymap.set("n", "s", "<plug>Lightspeed_s")
            vim.keymap.set("n", "S", "<plug>Lightspeed_S")
            vim.keymap.set("n", "f", "<plug>Lightspeed_f")
            vim.keymap.set("n", "F", "<plug>Lightspeed_F")
            vim.keymap.set("n", "t", "<plug>Lightspeed_t")
            vim.keymap.set("n", "T", "<plug>Lightspeed_T")
        end,
    },
}

lightspeed.configs = {
    ["lightspeed.nvim"] = function()
        vim.keymap.set("n", "s", "<plug>Lightspeed_s")
        vim.keymap.set("n", "S", "<plug>Lightspeed_S")
        vim.keymap.set("n", "f", "<plug>Lightspeed_f")
        vim.keymap.set("n", "F", "<plug>Lightspeed_F")
        vim.keymap.set("n", "t", "<plug>Lightspeed_t")
        vim.keymap.set("n", "T", "<plug>Lightspeed_T")
    end,
}

return lightspeed
