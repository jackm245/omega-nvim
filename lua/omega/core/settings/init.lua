-- disable builtin plugins
require("omega.core.settings.disable_builtin")

-- use lua filetype detection
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.opt.timeoutlen = 300
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes:3"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~") .. "/.vim/undodir" -- directory to save undofiles
vim.opt.updatetime = 300 -- update CursorHold and save swap every 2000ms
