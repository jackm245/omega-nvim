---@type OmegaModule
local harpoon = {}

harpoon.plugins = {
    ["harpoon"] = {
        "ThePrimeagen/harpoon",
        keys = { "<leader>H" },
    },
}

harpoon.configs = {
    ["harpoon"] = function()
        require("telescope").load_extension("harpoon")
    end,
}

harpoon.keybindings = function()
    require("which-key").register({
        H = {
            name = " Harpoon",
            a = {
                function()
                    require("harpoon.mark").add_file()
                end,
                "Add File",
            },
            m = {
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                "Menu",
            },
            n = {
                function()
                    require("harpoon.ui").nav_next()
                end,
                "Next File",
            },
            p = {
                function()
                    require("harpoon.ui").nav_prev()
                end,
                "Previous File",
            },
            t = { "<cmd>Telescope harpoon marks<CR>", "Telescope" },
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
end

return harpoon
