local snippets_mod = {}

snippets_mod.plugins = {
    ["LuaSnip"] = {
        "L3MON4D3/LuaSnip",
        module = "luasnip",
    },
    ["friendly-snippets"] = {
        "~/neovim_plugins/friendly-snippets",
        event = "InsertEnter",
        after = "LuaSnip",
    },
}

return snippets_mod
