require("impatient").enable_profile()
vim.cmd([[luafile ~/neovim_plugins/profiler.nvim/lua/profiler.lua]])
vim.opt.runtimepath:append(vim.fn.stdpath("data"))
require("omega.core")