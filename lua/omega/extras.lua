---@diagnostic disable: need-check-nil
local extras = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local exp = vim.fn.expand
local utils = require("omega.utils")

-- Commands to execute file types
local files = {
    python = "python3 " .. vim.fn.stdpath("data") .. "/temp",
    lua = "lua " .. vim.fn.stdpath("data") .. "/temp",
    applescript = "osascript " .. vim.fn.stdpath("data") .. "/temp",
    c = "gcc -o tmp "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. " && "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. "&& rm "
        .. vim.fn.stdpath("data")
        .. "/temp",
    cpp = "clang++ -o tmp " .. vim.fn.stdpath("data") .. "/temp" .. " && " .. vim.fn.stdpath(
        "data"
    ) .. "/temp" .. "&& rm " .. vim.fn.stdpath("data") .. "/temp",
    rust = "rustc -o "
        .. vim.fn.stdpath("data")
        .. "/tmp "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. " && "
        .. vim.fn.stdpath("data")
        .. "/tmp"
        .. "&& rm "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. "&& rm "
        .. vim.fn.stdpath("data")
        .. "/tmp",
    ---@diagnostic disable-next-line: missing-parameter
    javascript = "node " .. exp("%:t"),
    ---@diagnostic disable-next-line: missing-parameter
    typescript = "tsc " .. exp("%:t") .. " && node " .. exp("%:t:r") .. ".js",
}
local scratch_buf
local og_win

local function run_file()
    local lines = vim.api.nvim_buf_get_lines(scratch_buf, 0, -1, false)
    local file = io.open(vim.fn.stdpath("data") .. "/temp", "w")
    for _, line in ipairs(lines) do
        file:write(line)
    end
    file:close()
    local command = files[vim.bo.filetype]
    if command ~= nil then
        require("toggleterm.terminal").Terminal
            :new({ cmd = command, close_on_exit = false, direction = "float" })
            :toggle()
        print("Running: " .. command)
    end
end

local function open_scratch_buffer(language)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    local width = vim.api.nvim_win_get_width(og_win)
    local height = vim.api.nvim_win_get_height(og_win)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        win = 0,
        width = math.floor(width * 0.8),
        height = math.floor(height * 0.8),
        col = math.floor(width * 0.1),
        row = math.floor(height * 0.1),
        border = "single",
        style = "minimal",
    })
    vim.api.nvim_buf_set_option(buf, "filetype", language)
    scratch_buf = buf
    vim.keymap.set("n", "<leader>r", function()
        run_file()
    end, {
        noremap = true,
        buffer = buf,
        desc = false,
    })
end

local open_scratch = function(bufnr)
    local entry = action_state.get_selected_entry()
    actions.close(bufnr)

    if entry ~= nil then
        open_scratch_buffer(entry[1])
    end
end

local scratch_filetypes = {
    "lua",
    "rust",
    "python",
    "c",
    "cpp",
    "java",
    "tex",
    "javascript",
    "typescrip",
    "plain",
    "norg",
}

function extras.scratch_buf(args)
    og_win = vim.api.nvim_get_current_win()
    if args.fargs[1] and vim.tbl_contains(scratch_filetypes, args.fargs[1]) then
        open_scratch_buffer(args.fargs[1])
        return
    end
    local opts = {}
    opts.data = scratch_filetypes
    pickers
        .new(opts, {
            prompt_title = "~ Scratch Picker ~",
            results_title = "~ Scratch Filetypes ~",
            -- layout_strategy = "custom_bottom",
            finder = finders.new_table(opts.data),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(_, map)
                map("i", "<CR>", open_scratch)
                map("n", "<CR>", open_scratch)
                return true
            end,
        })
        :find()
end

return extras
