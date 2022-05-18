local map = vim.keymap.set

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

    v = {
        name = " View",
        l = {
            function()
                require("omega.utils").LatexPreview()
            end,
            "Latex",
        },
        -- TODO: readd
        -- f = {
        --     function()
        --         require("nabla").popup()
        --     end,
        --     "Formulas",
        -- },
        m = {
            function()
                require("omega.utils").MarkdownPreview()
            end,
            "Markdown",
        },
    },
    p = { '"0p', "Paste Last Yank" },

    ["P"] = {
        name = " Packer",
        S = { "<cmd>PackerStatus<cr>", "Status" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        p = { "<cmd>PackerProfile<cr>", "Profile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
        C = { "<cmd>PackerClean<cr>", "Clean" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
})

map("n", ",,", function()
    require("omega.utils").append_comma()
end, {
    noremap = true,
    silent = true,
    desc = "Append comma",
})

map("n", ";;", function()
    require("omega.utils").append_semicolon()
end, {
    noremap = true,
    silent = true,
    desc = "Append semicolon",
})

map(
    "n",
    "<esc>",
    "<cmd>nohl<cr>",
    { noremap = true, silent = true, desc = "Clear highlight from search" }
)

map("i", "<leader><tab>", function()
    require("luasnip").expand_or_jump()
end, {
    noremap = true,
    silent = true,
})
map("s", "<leader><tab>", function()
    require("luasnip").expand_or_jump()
end, {
    noremap = true,
    silent = true,
})

map("v", "<leader>s", ":s///g<LEFT><LEFT><LEFT>", { noremap = true })
map("i", "<leader><leader>", "<right>", { noremap = true, silent = true })
map("i", "<leader>", " ", { noremap = true })
map(
    "n",
    "<C-f>",
    ':lua vim.cmd(":vert :h "..vim.fn.expand("<cword>"))<CR>',
    { noremap = true, silent = true }
)
map("i", "<m-cr>", "<cr>", { noremap = true, silent = true })
map(
    "n",
    "<c-j>",
    ":wincmd j<CR>",
    { noremap = true, silent = true, desc = "Move to split above" }
)
map(
    "n",
    "<c-h>",
    ":wincmd h<CR>",
    { noremap = true, silent = true, desc = "Move to split on left side" }
)
map(
    "n",
    "<c-k>",
    ":wincmd k<CR>",
    { noremap = true, silent = true, desc = "Move to split below" }
)
map(
    "n",
    "<c-l>",
    ":wincmd l<CR>",
    { noremap = true, silent = true, desc = "Move to split on right side" }
)
map("x", "<", "<gv", { noremap = true })
map("x", ">", ">gv", { noremap = true })
