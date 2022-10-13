---@type OmegaModule
local trouble = {}

trouble.plugins = {
    ["trouble.nvim"] = {
        "folke/trouble.nvim",
        module = "trouble",
        cmd = {
            "Trouble",
            "TroubleClose",
            "TroubleToggle",
            "TroubleRefresh",
            "TodoTrouble",
        },
        config = function()
            require("omega.modules.misc.trouble.configs")["trouble.nvim"]()
        end,
    },
}

trouble.keybindings = function()
    require("which-key").register({
        x = {
            name = " Errors",
            x = { "<cmd>TroubleToggle<CR>", "Trouble" },
            w = {
                "<cmd>Trouble lsp_workspace_diagnostics<CR>",
                "Workspace Trouble",
            },
            d = {
                "<cmd>Trouble lsp_document_diagnostics<CR>",
                "Document Trouble",
            },
            l = { "<cmd>lopen<CR>", "Open Location List" },
            q = { "<cmd>copen<CR>", "Open Quickfix List" },
        },
    }, {
        mode = "n",
        prefix = "<leader>",
    })
end

return trouble
