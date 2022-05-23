local config = {}

function config.load()
    omega.config = {
        statusline = "round",
        colorscheme = "doom_one",
        -- colorscheme="onedark",
        -- colorscheme = "everforest",
        -- colorscheme = "everforest_light",
        light_colorscheme = "everforest",
        use_impatient = true,
        -- telescope_theme = "custom_bottom_no_borders",
        telescope_theme = "float_all_borders",
    }
end

return config
