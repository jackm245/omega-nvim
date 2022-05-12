local wk = require("which-key")
wk.register({
    y = { '"+y', " Yank to clipboard" },
    ["S"] = { "<cmd>w<cr>", " Save" },
    i = {
        name = " Insert",
        o = { "o<ESC>k", "Empty line below" },
        O = { "O<ESC>j", "Empty line above" },
        i = { "i <ESC>l", "Space before" },
        a = { "a <ESC>h", "Space after" },
        e = { "<cmd>Telescope emoji<cr>", "Emoji" },
        ["<CR>"] = { "i<CR><ESC>", "Linebreak at Cursor" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
})
