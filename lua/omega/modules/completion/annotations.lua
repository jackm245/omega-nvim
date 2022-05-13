local neogen_mod = {}

neogen_mod.plugins = {
    ["neogen"] = {
        "danymat/neogen",
        module = { "neogen" },
    },
}

neogen_mod.configs={
    ["neogen"]=function()
            require("neogen").setup({
                snippet_engine = "luasnip",
                enabled = true,
            })
    end
}

return neogen_mod
