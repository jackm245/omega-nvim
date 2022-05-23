---@type OmegaModule
local paperplanes = {}

paperplanes.plugins = {
    ["paperplanes.nvim"] = {
        "rktjmp/paperplanes.nvim",
        cmd = { "PP" },
    },
}

paperplanes.configs = {
    ["paperplanes.nvim"] = function()
        require("paperplanes").setup({
            register = "+",
            provider = "paste.rs",
            -- provider = "ix.io",
        })
    end,
}

return paperplanes
