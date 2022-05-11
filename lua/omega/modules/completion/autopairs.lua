local autopairs = {}

autopairs.plugins = {
    ["nvim-autopairs"] = {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- TODO: uncomment this
        -- after="nvim-cmp",
    },
}
autopairs.configs = {
    ["nvim-autopairs"] = function()
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")
        require("nvim-autopairs").setup({
            ignored_next_char = "",
            map_c_w = true,
        })
        npairs.add_rule(Rule("$", "$", "tex"))
    end,
}

return autopairs
