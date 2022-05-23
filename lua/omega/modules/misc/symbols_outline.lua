local symbols_outline = {}

symbols_outline.plugins = {
    ["symbols-outline.nvim"] = {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
    },
}

symbols_outline.configs = {
    ["symbols-outline.nvim"] = function()
        vim.g.symbols_outline = {
            highlight_hovered_item = false,
            width = 65,
        }

        vim.api.nvim_set_hl(
            0,
            "FocusedSymbol",
            { italic = true, fg = require("omega.colors").get()["cyan"] }
        )
    end,
}

return symbols_outline
