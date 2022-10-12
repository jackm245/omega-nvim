---@type OmegaModule
local gitsigns = {}

gitsigns.plugins = {
    ["gitsigns.nvim"] = {
        "lewis6991/gitsigns.nvim",
        opt = true,
        setup = function()
            vim.api.nvim_create_autocmd({ "BufEnter" }, {
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
        })
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ece6a" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e0af68" })
        vim.api.nvim_set_hl(0, "GitSignsDelte", { fg = "#db4b4b" })
    end,
}

gitsigns.keybindings = function()
    local wk = require("which-key")
    wk.register({
        g = {
            name = " Git",
            h = {
                name = "Hunk",
                s = {
                    function()
                        require("gitsigns").stage_hunk()
                    end,
                    "Stage",
                },
                p = {
                    function()
                        require("gitsigns").preview_hunk()
                    end,
                    "Preview",
                },
                b = {
                    function()
                        require("gitsigns").blame_line()
                    end,
                    "Blame Line",
                    desc = " Git Blame Line",
                },
                R = {
                    function()
                        require("gitsigns").reset_buffer()
                    end,
                    "Reset Buffer",
                },
                r = {
                    function()
                        require("gitsigns").reset_hunk()
                    end,
                    "Reset Hunk",
                },
                u = {
                    function()
                        require("gitsigns").undo_stage_hunk()
                    end,
                    "Undo Stage",
                },
            },
        },
    }, {
        mode = "n",
        prefix = "<leader>",
    })
end

return gitsigns
