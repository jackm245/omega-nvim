local utils = require("omega.utils")
local colors = {}

function colors.create_colorscheme()
    local scheme = {}
    scheme.white = vim.fn.input("White> ", "")
    scheme.black = vim.fn.input("Background> ", "")
    scheme.darker_black = utils.darken_color(scheme.black, 6)
    scheme.black2 = utils.lighten_color(scheme.black, 6)
    scheme.onebg = utils.lighten_color(scheme.black, 10)
    scheme.onebg2 = utils.lighten_color(scheme.black, 19)
    scheme.onebg3 = utils.lighten_color(scheme.black, 27)
    scheme.grey = utils.lighten_color(scheme.black, 40)
    scheme.grey_fg = utils.lighten_color(scheme.grey, 10)
    scheme.grey_fg2 = utils.lighten_color(scheme.grey, 20)
    scheme.light_grey = utils.lighten_color(scheme.grey, 28)
    scheme.red = vim.fn.input("Red> ", "")
    scheme.baby_pink = utils.lighten_color(scheme.red, 15)
    scheme.pink = vim.fn.input("Pink> ", "")
    scheme.purple = vim.fn.input("Purple> ", "")
    scheme.dark_purple = utils.darken_color(scheme.purple, 25)
    scheme.line = utils.lighten_color(scheme.black, 15)
    scheme.green = vim.fn.input("Green> ", "")
    scheme.dark_green = utils.darken_color(scheme.green, 25)
    scheme.vibrant_green = vim.fn.input("Vibrant Green> ", "")
    scheme.blue = vim.fn.input("Blue> ", "")
    scheme.teal = vim.fn.input("Orange> ", "")
    scheme.orange = vim.fn.input("Teal> ", "")
    scheme.cyan = vim.fn.input("Cyan> ", "")
    scheme.dark_blue = utils.darken_color(scheme.blue, 25)
    scheme.nord_blue = utils.darken_color(scheme.blue, 13)
    scheme.yellow = vim.fn.input("Yellow> ", "")
    scheme.sun = utils.lighten_color(scheme.yellow, 8)
    scheme.statusline_bg = utils.lighten_color(scheme.black, 4)
    scheme.lightbg = utils.lighten_color(scheme.statusline_bg, 13)
    scheme.lightbg2 = utils.lighten_color(scheme.statusline_bg, 7)
    scheme.pmenu_bg = scheme.darker_black
    scheme.folder_bg = scheme.blue
    return scheme
end

-- if theme given, load given theme if given, otherwise nvchad_theme
colors.init = function(theme, reload)
    reload = reload or false
    -- if theme and vim.g.colors_name and theme ~= vim.g.colors_name then
    --     reload = true
    -- end
    -- set the global theme, used at various places like theme switcher, highlights
    if not theme then
        if vim.g.forced_theme then
            theme = vim.g.forced_theme
        elseif vim.g.colors_name then
            theme = vim.g.colors_name
        end
    end
    vim.g.colors_name = theme

    local base16 = require("omega.colors.base16")

    -- first load the base16 theme
    base16(base16.themes(theme), true)
    -- base16_custom(base16.themes(theme), true)

    -- unload to force reload
    package.loaded["omega.colors.highlights" or false] = nil
    -- then load the highlights
    package.loaded["omega.colors.highlights"] = nil
    package.loaded["omega.colors.custom"] = nil
    local highlights_raw = vim.split(
        vim.api.nvim_exec("filter BufferLine hi", true),
        "\n"
    )
    local highlight_groups = {}
    for _, raw_hi in ipairs(highlights_raw) do
        table.insert(highlight_groups, string.match(raw_hi, "BufferLine%a+"))
    end
    for _, highlight in ipairs(highlight_groups) do
        vim.cmd([[hi clear ]] .. highlight)
    end
    require("omega.colors.highlights")
    require("omega.colors.custom")
    if reload then
        require("plenary.reload").reload_module("omega")
        require("plenary.reload").reload_module("bufferline")
        omega.modules.ui.bufferline.configs["bufferline.nvim"]()
        require("plenary.reload").reload_module("heirline")
        omega.modules.ui.heirline.configs["heirline.nvim"]()
        require("colorscheme_switcher").new_scheme()
        -- require("omega.core.modules").load()
        -- require("omega.core")
    end
    -- require("ignis.modules.ui.bufferline")
end

function colors.toggle_light()
    if vim.g.colors_name ~= omega.config.light_colorscheme then
        omega.old_theme = vim.g.colors_name
        colors.init(omega.config.light_colorscheme, true)
        vim.g.toggle_icon = " "
    else
        colors.init(omega.old_theme, true)
        vim.g.toggle_icon = " "
    end
end

-- returns a table of colors for givem or current theme
colors.get = function(theme)
    if not theme then
        theme = vim.g.colors_name
    end
    local path = "lua/hl_themes/" .. theme .. ".lua"
    local files = vim.api.nvim_get_runtime_file(path, true)
    local color_table
    if #files == 0 then
        error("lua/hl_themes/" .. theme .. ".lua" .. " not found")
    elseif #files == 1 then
        color_table = dofile(files[1])
    else
        local nvim_base_pattern = "nvim-base16.lua/lua/hl_themes"
        local valid_file = false
        for _, file in ipairs(files) do
            if not file:find(nvim_base_pattern) then
                color_table = dofile(file)
                valid_file = true
            end
        end
        if not valid_file then
            -- multiple files but in startup repo shouldn't happen so just use first one
            color_table = dofile(files[1])
        end
    end
    return color_table
end

return colors
