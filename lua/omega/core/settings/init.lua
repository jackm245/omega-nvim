-- disable builtin plugins
require("omega.core.settings.disable_builtin")

-- use lua filetype detection
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeoutlen = 300
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.mouse = "nv"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes:3"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~") .. "/.vim/undodir" -- directory to save undofiles
vim.opt.updatetime = 300 -- update CursorHold and save swap every 2000ms
vim.opt.shortmess:append("c")
vim.opt.formatoptions = vim.opt.formatoptions
    + "r" -- continue comments after return
    + "c" -- wrap comments using textwidth
    + "q" -- allow to format comments w/ gq
    + "j" -- remove comment leader when joining lines when possible
    - "t" -- don't autoformat
    - "a" -- no autoformatting
    - "o" -- don't continue comments after o/O
    - "2" -- don't use indent of second line for rest of paragraph
vim.opt.cmdheight = 1 -- height of cmd line
vim.opt.virtualedit = "block" -- allow visual mode to go over end of lines
vim.opt.expandtab = true -- expand tabs to spaces
vim.opt.showmode = false -- don't show mode (I've lualine)
vim.opt.scrolloff = 3 -- start scrolling 3 lines away from top/bottom
vim.opt.cursorline = true -- highlight current line
vim.opt.compatible = false
vim.opt.wrap = true -- wrap long lines
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.opt.foldlevel = 100
vim.opt.joinspaces = false
vim.opt.completeopt = "menuone,noselect"
vim.opt.conceallevel = 2
vim.opt.lazyredraw = true -- Do not redraw screen while processing macros
vim.opt.list = true --show some hidden characters
vim.opt.listchars = {
    tab = "> ",
    nbsp = "␣",
    trail = "•",
}
vim.opt.foldmethod = "expr" -- use treesitter for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.fillchars = {
    eob = " ",
    vert = "║",
    horiz = "═",
    horizup = "╩",
    horizdown = "╦",
    vertleft = "╣",
    vertright = "╠",
    verthoriz = "╬",
}
vim.opt.laststatus = 3
vim.opt.winbar = "%{%v:lua.require'omega.modules.ui.winbar'.eval()%}"
