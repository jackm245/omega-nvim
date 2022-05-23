local aucmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = "*",
    callback = function()
        require("omega.utils").last_place()
    end,
    desc = "Go to last position in buffer",
})

local ft_aucmd = function(pattern, ft)
    aucmd({ "BufRead", "BufEnter", "BufNewFile" }, {
        pattern = pattern,
        command = [[set ft=]] .. ft,
        once = false,
        desc = "Set filetype to " .. ft,
    })
end

ft_aucmd("COMMIT_EDITMSG", "gitcommit")
ft_aucmd("*.cpp", "cpp")

aucmd({ "BufEnter", "BufWinEnter" }, {
    pattern = "neorg://*",
    command = [[set foldlevel=1000]],
    desc = "Open folds in neorg",
})

aucmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.norg",
    command = "setlocal filetype=norg",
    desc = "Set norg filetype",
})

local netrw = vim.api.nvim_create_augroup("netrw", { clear = true })
aucmd({ "Filetype" }, {
    pattern = "netrw",
    callback = function()
        require("omega.core.settings.netrw").draw_icons()
    end,
    desc = "Draw netrw icons",
    group = netrw,
})
aucmd({ "TextChanged" }, {
    pattern = "*",
    callback = function()
        require("omega.core.settings.netrw").draw_icons()
    end,
    desc = "Draw netrw icons",
    group = netrw,
})
aucmd({ "Filetype" }, {
    pattern = "netrw",
    callback = function()
        require("omega.core.settings.netrw").set_maps()
    end,
    desc = "Define netrw mappings",
    group = netrw,
})

-- show cursor line only in active window
aucmd({ "InsertLeave", "WinEnter", "CmdlineLeave" }, {
    pattern = "*",
    command = "set cursorline",
    desc = "Enable cursorline",
})
aucmd({ "InsertEnter", "WinLeave", "CmdlineEnter" }, {
    pattern = "*",
    command = "set nocursorline",
    desc = "Disable cursorline",
})

-- windows to close with "q"
aucmd({ "FileType" }, {
    pattern = { "help", "startuptime", "qf", "lspinfo", "man" },
    callback = function()
        vim.keymap.set("n", "q", function()
            vim.cmd([[close]])
        end, {
            noremap = true,
            silent = true,
            buffer = true,
        })
    end,
    desc = "Map q to close buffer",
})

aucmd(
    "FocusGained",
    { command = "checktime", desc = "Check if buffer was changed" }
)

aucmd({ "TextYankPost" }, {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higrou = "IncSearch", timeout = 500 })
    end,
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Highlight yanked text",
})

-- vim.cmd([[
--   augroup nvim-luadev
--     autocmd!
--     function! SetLuaDevOptions()
--       nmap <buffer> <C-c><C-c> <Plug>(Luadev-RunLine)
--       vmap <buffer> <C-c><C-c> <Plug>(Luadev-Run)
--       nmap <buffer> <C-c><C-k> <Plug>(Luadev-RunWord)
--       map  <buffer> <C-x><C-p> <Plug>(Luadev-Complete)
--       set filetype=lua
--     endfunction
--     autocmd BufEnter \[nvim-lua\] call SetLuaDevOptions()
--   augroup end
-- ]])

aucmd({ "BufNewFile", "BufRead", "BufWinEnter" }, {
    pattern = "*.tex",
    callback = function()
        vim.bo.filetype = "tex"
    end,
    desc = "Set filetype to tex",
})

-- TODO: eventually fix this
-- local timer = nil
-- local called_by_func = false
-- local function make_second_lowercase()
--     if timer and (not vim.loop.is_closing(timer)) then
--         pcall(vim.loop.timer_stop, timer)
--         pcall(vim.loop.close, timer)
--         called_by_func = false
--         timer = nil
--     end
--     if vim.v.char and vim.v.char ~= " " then
--         return
--     end
--     if called_by_func then
--         return
--     end
--     if vim.fn.mode() ~= "i" then
--         return
--     end
--     timer = vim.defer_fn(function()
--         called_by_func = true
--         vim.api.nvim_input("<esc>bl")
--         vim.defer_fn(function()
--             if vim.tbl_contains({ 1, 2, 0 }, #vim.fn.expand("<cword>")) then
--                 vim.api.nvim_input("hela")
--                 return
--             end
--             vim.api.nvim_input("gulhela")
--             timer = nil
--             called_by_func = false
--         end, 1)
--     end, 200)
-- end

-- aucmd("InsertCharPre", {
--     pattern = { "*.tex", "*.norg" },
--     callback = function()
--         make_second_lowercase()
--     end,
-- })

local in_mathzone = require("omega.utils").in_mathzone

aucmd("CursorHold", {
    pattern = "*.tex",
    callback = function()
        if in_mathzone() then
            require("nabla").popup()
        end
    end,
    desc = "Open nabla",
})

aucmd("User", {
    pattern = "PackerCompileDone",
    callback = function()
        vim.api.nvim_chan_send(
            vim.v.stderr,
            "\027]99;i=1:d=0;Packer.nvim\027\\"
        )
        vim.api.nvim_chan_send(
            vim.v.stderr,
            "\027]99;i=1:d=1:p=body;Compile finished\027\\"
        )
    end,
    desc = "Send desktop notification",
})

aucmd("DiagnosticChanged", {
    once = true,
    callback = function()
        vim.api.nvim_chan_send(vim.v.stderr, "\027]99;i=1:d=0;Lsp\027\\")
        vim.api.nvim_chan_send(
            vim.v.stderr,
            "\027]99;i=1:d=1:p=body;Finished Loading\027\\"
        )
    end,
    desc = "Send desktop notification",
})

aucmd("User", {
    once = true,
    callback = function()
        vim.api.nvim_chan_send(vim.v.stderr, "\027]99;i=1:d=0;Neorg\027\\")
        vim.api.nvim_chan_send(
            vim.v.stderr,
            "\027]99;i=1:d=1:p=body;Finished Loading\027\\"
        )
    end,
    pattern = "NeorgStarted",
    desc = "Send desktop notification",
})

aucmd("FileType", {
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            + "r" -- continue comments after return
            + "c" -- wrap comments using textwidth
            + "q" -- allow to format comments w/ gq
            + "j" -- remove comment leader when joining lines when possible
            - "t" -- don't autoformat
            - "a" -- no autoformatting
            - "o" -- don't continue comments after o/O
            - "2" -- don't use indent of second line for rest of paragraph
    end,
    desc = "Set formatoptions",
})

aucmd("CmdLineEnter", {
    once = true,
    callback = function()
        require("omega.modules.misc.normal_cmdline").setup()
    end,
    desc = "Set up normal_cmdline",
})
