local config = {}

function config.load()
    omega.config = {
        -- "round_colored_bg"|"round_dark_bg"|"round_blended"
        statusline = "round_blended",
        colorscheme = "catppuccin_frappe",
        light_colorscheme = "everforest",
        use_impatient = true,
        --- string "float_all_borders"|"custom_bottom_no_borders"
        telescope_theme = "float_all_borders",
        --- String "border"|"no-border"
        cmp_theme = "no-border",
    }
end

return config
