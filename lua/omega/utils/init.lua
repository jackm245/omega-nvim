local utils = {}

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

function utils.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function utils.bootstrap_impatient()
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

        require("impatient").enable_profile()
    end
end

---Appends a `,` to the current line
function utils.append_comma()
    -- save cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- append ,
    vim.cmd([[normal A,]])
    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end

---Appends a `;` to the current line
function utils.append_semicolon()
    -- save cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- append ,
    vim.cmd([[normal A;]])
    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end

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

return utils
