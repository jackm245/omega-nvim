local formatter = {}

formatter.plugins = {
    ["formatter.nvim"] = {
        "mhartington/formatter.nvim",
        cmd = "FormatWrite",
        setup = function()
            local group = vim.api.nvim_create_augroup("Formatter", {})
            vim.api.nvim_create_autocmd("BufWritePost", {
                callback = function()
                    vim.cmd([[FormatWrite]])
                end,
                group = group,
            })
        end,
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
                rust = {
                    function()
                        return {
                            exe = "rustfmt",
                            stdin = true,
                        }
                    end,
                },
            },
        })
    end,
}

return formatter
