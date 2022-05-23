--- Utils for omega-nvim
local utils = {}

local Path = require("plenary.path")

function utils.view_messages()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.keymap.set(
        "n",
        "<ESC>",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true, buffer = buf }
    )
    vim.keymap.set(
        "n",
        "q",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true, buffer = buf }
    )
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        win = 0,
        width = math.floor(width * 0.25),
        height = math.floor(height * 0.9),
        col = math.floor(width * 0.75),
        row = math.floor(height * 0.05),
        border = "single",
        style = "minimal",
    })
    vim.api.nvim_win_set_option(win, "winblend", 20)
    vim.cmd([[put =execute('messages')]])
end

--- Preview latex
function utils.LatexPreview()
    vim.cmd([[
      write
      silent !pdflatex %; open %:t:r.pdf
    ]])
end

--- Convert markdown file to html and open
function utils.MarkdownPreview()
    vim.cmd([[
  write
  silent !python3 -m markdown % > ~/temp_html.html
  silent !open ~/temp_html.html
  ]])
end

--- Retunrs a border
---@return dict<string, string> border char, highlight
function utils.border()
    return {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }
end

--- Replaces termcodes
---@param str string
---@return string
function utils.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--- Bootsrpats impatient
function utils.bootstrap_impatient()
    if not omega.config.use_impatient then
        return
    end
    local has_impatient = pcall(require, "impatient")
    if not has_impatient then
        -- Packer Bootstrapping
        local packer_path = vim.fn.stdpath("data")
            .. "/site/pack/packer/start/impatient.nvim"
        if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
            vim.notify("Bootstrapping impatient.nvim, please wait ...")
            vim.fn.system({
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/lewis6991/impatient.nvim",
                packer_path,
            })
        end

        vim.cmd("packadd impatient.nvim")
        -- vim.cmd([[LuaCacheClear]])

        require("impatient").enable_profile()
    else
        -- vim.cmd([[LuaCacheClear]])
        require("impatient").enable_profile()
    end
end

--- Appends a `,` to the current line
function utils.append_comma()
    -- save cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- append ,
    vim.cmd([[normal A,]])
    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end

--- Appends a `;` to the current line
function utils.append_semicolon()
    -- save cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- append ,
    vim.cmd([[normal A;]])
    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end

--- Checks if cursor is in mathzone
--- @return boolean
utils.in_mathzone = function()
    local has_treesitter, ts = pcall(require, "vim.treesitter")
    local _, query = pcall(require, "vim.treesitter.query")

    local MATH_ENVIRONMENTS = {
        displaymath = true,
        eqnarray = true,
        equation = true,
        math = true,
        array = true,
    }
    local MATH_NODES = {
        displayed_equation = true,
        inline_formula = true,
    }

    local function get_node_at_cursor()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local cursor_range = { cursor[1] - 1, cursor[2] }
        local buf = vim.api.nvim_get_current_buf()
        local ok, parser = pcall(ts.get_parser, buf, "latex")
        if not ok or not parser then
            return
        end
        local root_tree = parser:parse()[1]
        local root = root_tree and root_tree:root()

        if not root then
            return
        end

        return root:named_descendant_for_range(
            cursor_range[1],
            cursor_range[2],
            cursor_range[1],
            cursor_range[2]
        )
    end

    if has_treesitter then
        local buf = vim.api.nvim_get_current_buf()
        local node = get_node_at_cursor()
        while node do
            if MATH_NODES[node:type()] then
                return true
            end
            if node:type() == "environment" then
                local begin = node:child(0)
                local names = begin and begin:field("name")

                if
                    names
                    and names[1]
                    and MATH_ENVIRONMENTS[query.get_node_text(names[1], buf):gsub(
                        "[%s*]",
                        ""
                    )]
                then
                    return true
                end
            end
            node = node:parent()
        end
        return false
    end
end

--- Go to last place in file
function utils.last_place()
    if
        vim.tbl_contains(
            vim.api.nvim_list_bufs(),
            vim.api.nvim_get_current_buf()
        )
    then
        -- check if filetype isn't one of the listed
        if
            not vim.tbl_contains(
                { "gitcommit", "help", "packer", "toggleterm" },
                vim.bo.ft
            )
        then
            -- check if mark `"` is inside the current file (can be false if at end of file and stuff got deleted outside neovim)
            -- if it is go to it
            vim.cmd(
                [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]]
            )
            -- get cursor position
            local cursor = vim.api.nvim_win_get_cursor(0)
            -- if there are folds under the cursor open them
            if vim.fn.foldclosed(cursor[1]) ~= -1 then
                vim.cmd([[silent normal! zO]])
            end
        end
    end
end

function utils.adjust_color(color, amount)
    color = vim.trim(color)
    color = color:gsub("#", "")
    local first = ("0" .. string.format(
        "%x",
        (math.min(255, tonumber(color:sub(1, 2), 16) + amount))
    )):sub(-2)
    local second = ("0" .. string.format(
        "%x",
        (math.min(255, tonumber(color:sub(3, 4), 16) + amount))
    )):sub(-2)
    local third = ("0" .. string.format(
        "%x",
        (math.min(255, tonumber(color:sub(5, -1), 16) + amount))
    )):sub(-2)
    return "#" .. first .. second .. third
end

function utils.darken_color(color, amount)
    return utils.adjust_color(color, -amount)
end

function utils.lighten_color(color, amount)
    return utils.adjust_color(color, amount)
end

---Get the available nvim-base16 themes
---@return table themes All the themes found
utils.get_themes = function()
    local themes = {}
    local theme_dir = vim.fn.expand("~")
        .. "/.config/neovim_configs/omega/lua/hl_themes"
    local theme_files = require("plenary.scandir").scan_dir(theme_dir, {})
    for _, theme in ipairs(theme_files) do
        table.insert(
            themes,
            (Path:new(theme):make_relative(theme_dir):gsub(".lua", ""))
        )
    end
    return themes
end

return utils
