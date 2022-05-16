local formatter = {}

formatter.plugins = {
    ["formatter.nvim"] = {
        "mhartington/formatter.nvim",
        ft = { "lua" },
    },
}

formatter.configs = {
    ["formatter.nvim"] = function()
        require("formatter").setup({
            filetype = {
                lua = {
                    function()
                        return {
                            exe = "stylua",
                            args = {
                                "--search-parent-directories",
                                "-",
                            },
                            stdin = true,
                        }
                    end,
                },
            },
        })
        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
                vim.cmd([[FormatWrite]])
            end,
            group = group,
        })
    end,
}

return formatter
