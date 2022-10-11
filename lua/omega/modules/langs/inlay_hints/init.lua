-- https://github.com/tiagovla/.dotfiles/blob/master/neovim/.config/nvim/lua/lsp/inlay_hints/init.lua
local extensions = {}

local inlay_hints = require("omega.modules.langs.inlay_hints.core")

extensions.inlay_hints = inlay_hints.set_inlay_hints
extensions.setup_autocmd = inlay_hints.setup_autocmd

return extensions
