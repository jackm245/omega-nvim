local blankline = {}

blankline.plugins = {
    ["indent-blankline.nvim"] = {
        "lukas-reineke/indent-blankline.nvim",
        opt = true,
        setup = function()
            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                    if lines ~= { "" } then
                        require("packer").loader("indent-blankline.nvim")
                    end
                end,
            })
        end,
    },
}

blankline.configs = {
    ["indent-blankline.nvim"] = function()
        vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
        vim.g.indent_blankline_filetype_exclude = {
            "help",
            "startify",
            "dashboard",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
        }
        vim.g.indentLine_enabled = 1
        -- vim.g.indent_blankline_char = "│"
        vim.g.indent_blankline_char = "▏"
        vim.g.indent_blankline_show_trailing_blankline_indent = false
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_use_treesitter = true
        vim.g.indent_blankline_show_current_context = true
        vim.g.indent_blankline_context_patterns = {
            "class",
            "return",
            "function",
            "method",
            "^if",
            "^do",
            "^switch",
            "^while",
            "jsx_element",
            "^for",
            "^object",
            "^table",
            "block",
            "arguments",
            "if_statement",
            "else_clause",
            "jsx_element",
            "jsx_self_closing_element",
            "try_statement",
            "catch_clause",
            "import_statement",
            "operation_type",
        }
        -- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
        vim.wo.colorcolumn = "99999"
        local colors = require("omega.colors").get()

        vim.cmd("highlight IndentBlanklineChar guifg=" .. colors.grey_fg)
        vim.cmd("highlight IndentBlanklineContextChar guifg=" .. colors.red)
    end,
}

return blankline
