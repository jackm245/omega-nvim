local surround = {}

surround.plugins = {
    ["surround.nvim"] = {
        "~/neovim_plugins/surround.nvim",
	-- HACK: can be lazyloaded because of `plugin/surround.lua`
        module = "surround",
    },
}

surround.configs = {
    ["surround.nvim"] = function()
        require("surround").setup({
            mappings_style = "surround",
            map_insert_mode = false,
            pairs = {
                nestable = {
                    { "(", ")" },
                    { "[", "]" },
                    { "{", "}" },
                },
                linear = {
                    { "'", "'" },
                    { "`", "`" },
                    { "/", "/" },
                    { "*", "*" },
                    { '"', '"' },
                },
            },
        })
    end,
}

return surround
