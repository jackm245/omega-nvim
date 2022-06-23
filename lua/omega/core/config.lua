local config = {}

function config.load()
    omega.config = {
        statusline = "round",
        colorscheme = "catppuccin_frappe",
        light_colorscheme = "everforest",
        use_impatient = true,
        telescope_theme = "float_all_borders",
        --- String "border"|"no-border"
        cmp_theme = "no-border",
    }
end

return config
