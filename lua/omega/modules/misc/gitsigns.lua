---@type OmegaModule
local gitsigns = {}

gitsigns.plugins = {
    ["gitsigns.nvim"] = {
        "lewis6991/gitsigns.nvim",
        opt = true,
        setup = function()
            vim.api.nvim_create_autocmd({ "BufAdd", "VimEnter" }, {
                -- vim.api.nvim_create_autocmd({ "BufAdd" }, {
                callback = function()
                    local function onexit(code, _)
                        if code == 0 then
                            vim.schedule(function()
                                require("packer").loader("gitsigns.nvim")
                            end)
                        end
                    end
                    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                    if lines ~= { "" } then
                        vim.loop.spawn("git", {
                            args = {
                                "ls-files",
                                "--error-unmatch",
                                vim.fn.expand("%"),
                            },
                        }, onexit)
                    end
                end,
            })
        end,
    },
}

gitsigns.configs = {
    ["gitsigns.nvim"] = function()
        require("gitsigns").setup({
            -- current_line_blame = true,
            signs = {
                add = {
                    hl = "GitSignsAdd",
                    text = "▍",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn",
                },
                change = {
                    hl = "GitSignsChange",
                    text = "▍",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "▸",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "▾",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "▍",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
            },
            keymaps = {
                -- Default keymap options
                noremap = true,
                buffer = true,
                ["n ]c"] = {
                    expr = true,
                    "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
                },
                ["n [c"] = {
                    expr = true,
                    "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
                },
                ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
                ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
                ["n <leader>ghR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
                ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
                ["n <leader>ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
                -- Text objects
                ["o ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
                ["x ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
            },
        })
        vim.cmd([[
            highlight GitSignsAdd guifg=#9ece6a
            highlight GitSignsChange guifg=#e0af68
            highlight GitSignsDelete guifg=#db4b4b
        ]])
    end,
}

return gitsigns
