local insert = {}

insert.plugins = {
    ["jeskape.nvim"] = { "Krafi2/jeskape.nvim", event = "InsertEnter" },
}

insert.configs = {
    ["jeskape.nvim"] = function()
        require("jeskape").setup({
            mappings = {
                [","] = {
                    [","] = "<cmd>lua require'omega.utils'.append_comma()<CR>",
                },
                j = {
                    k = "<esc>",
                    [","] = "<cmd>lua require'omega.utils'.append_comma()<CR><esc>o",
                    j = "<esc>A<cr>",
                },
                -- [" "] = {
                --     [" "] = "<right>",
                -- },
            },
        })
    end,
}

return insert
