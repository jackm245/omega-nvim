local surround = {}

surround.plugins = {
    ["nvim-surround"] = {
        "kylechui/nvim-surround",
        keys = { "ys", "ds", "cs" },
        module = "nvim-surround",
    },
}

surround.configs = {
    ["nvim-surround"] = function()
        local get_input = function(prompt)
            local ok, result = pcall(vim.fn.input, { prompt = prompt })
            if not ok then
                return nil
            end
            return result
        end
        require("nvim-surround").setup({
            delimiters = {
                invalid_key_behavior = function()
                    vim.api.nvim_err_writeln(
                        "Error: Invalid character! Configure this message in "
                            .. 'require("nvim-surround").setup()'
                    )
                end,
                pairs = {
                    ["("] = { "( ", " )" },
                    [")"] = { "(", ")" },
                    ["{"] = { "{ ", " }" },
                    ["}"] = { "{", "}" },
                    ["<"] = { "< ", " >" },
                    [">"] = { "<", ">" },
                    ["["] = { "[ ", " ]" },
                    ["]"] = { "[", "]" },
                    ["i"] = function()
                        local left_delimiter = get_input("Enter the left delimiter: ")
                        if left_delimiter then
                            local right_delimiter = get_input("Enter the right delimiter: ")
                            if right_delimiter then
                                return { left_delimiter, right_delimiter }
                            end
                        end
                    end,
                    ["f"] = function()
                        local result = get_input("Enter the function name: ")
                        if result then
                            return { result .. "(", ")" }
                        end
                    end,
                },
                separators = {
                    ["'"] = { "'", "'" },
                    ['"'] = { '"', '"' },
                    ["`"] = { "`", "`" },
                },
                HTML = {
                    ["t"] = "type",
                    ["T"] = "whole",
                },
                aliases = {
                    ["a"] = ">",
                    ["b"] = ")",
                    ["B"] = "}",
                    ["r"] = "]",
                    ["q"] = { '"', "'", "`" },
                    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
                },
            },
            highlight_motion = {
                duration = 300,
            },
            move_cursor = false,
        })
    end,
}

return surround
