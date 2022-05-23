---@type OmegaModule
local nvim_tree = {}

nvim_tree.plugins = {
    ["nvim-tree.lua"] = {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    },
}

nvim_tree.configs = {
    ["nvim-tree.lua"] = function()
        require("nvim-tree").setup({
            filters = {
                dotfiles = false,
                exclude = { "custom" },
            },
            -- disable_netrw = true,
            -- hijack_netrw = true,
            ignore_ft_on_setup = { "alpha" },
            open_on_tab = false,
            hijack_cursor = true,
            hijack_unnamed_buffer_when_opening = false,
            -- update_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = false,
            },
            view = {
                side = "left",
                width = 25,
                hide_root_folder = true,
            },
            git = {
                enable = false,
                ignore = true,
            },
            actions = {
                open_file = {
                    resize_window = true,
                },
            },
            renderer = {
                indent_markers = {
                    enable = false,
                },
            },
        })
    end,
}

return nvim_tree
