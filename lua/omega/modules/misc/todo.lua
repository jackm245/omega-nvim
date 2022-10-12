---@type OmegaModule
local todo = {}

todo.plugins = {
    ["todo-comments.nvim"] = {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    },
}

todo.configs = {
    ["todo-comments.nvim"] = function()
        vim.cmd.PackerLoad({ "telescope.nvim", "trouble.nvim" })
        require("todo-comments").setup()
    end,
}

todo.keybindings = function()
    require("which-key").register({
        t = {
            name = "璘Todo",
            q = { "<cmd>TodoQuickFix", "Quickfix" },
            t = { "<cmd>TodoTelescope<cr>", "Telescope" },
            T = { "<cmd>TodoTrouble<cr>", "Trouble" },
            l = { "<cmd>TodoLocList<CR>", "Loclist" },
        },
    }, {
        mode = "n",
        prefix = "<leader>",
    })
end

return todo
