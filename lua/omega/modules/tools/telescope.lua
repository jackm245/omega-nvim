local tele_mod = {}

tele_mod.plugins = {
    ["telescope.nvim"] = {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        module = {
            "telescope",
            "omega.modules.tools.telescope",
        },
    },
    ["telescope-emoji.nvim"] = {
        "xiyaowong/telescope-emoji.nvim",
        after = "telescope.nvim",
    },
    ["telescope-fzf-native.nvim"] = {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        after = "telescope.nvim",
    },
    ["telescope-symbols.nvim"] = {
        "nvim-telescope/telescope-symbols.nvim",
        after = "telescope.nvim",
    },
    ["telescope-file-browser.nvim"] = {
        "nvim-telescope/telescope-file-browser.nvim",
        after = "telescope.nvim",
    },
}

tele_mod.keybindings = function()
    local wk = require("which-key")
    wk.register({
        f = {
            name = " Find",
            f = {
                "<cmd>Telescope find_files<cr>",
                "File",
            },
        },
        ["/"] = {
            "<cmd>Telescope live_grep<cr>",
            " Live Grep",
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
end

return tele_mod
