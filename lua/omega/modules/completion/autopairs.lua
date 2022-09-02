local autopairs = {}

autopairs.plugins = {
    ["nvim-autopairs"] = {
        "windwp/nvim-autopairs",
        event = {
            "InsertEnter",
            -- for working with cmp
            "CmdLineEnter",
        },
        -- TODO: uncomment this
        after = "nvim-cmp",
    },
}
autopairs.configs = {
    ["nvim-autopairs"] = function()
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")
        require("nvim-autopairs").setup({
            ignored_next_char = "",
            map_c_w = true,
            disable_filetype = { "norg" },
        })
        npairs.add_rule(Rule("$", "$", "tex"))
    end,
}

return autopairs
