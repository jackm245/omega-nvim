local map = vim.keymap.set

local wk = require("which-key")
wk.register({
    y = { '"+y', " Yank to clipboard" },
    ["S"] = { "<cmd>w<cr>", " Save" },
    q = {
        name = " Quickfix",
        n = { "<cmd>cnext<CR>", "Next Entry" },
        p = { "<cmd>cprevious<CR>", "Previous Entry" },
        o = { "<cmd>copen<CR>", "Open" },
    },
    w = {
        name = " Window",
        ["w"] = { "<C-W>p", "Previous" },
        ["d"] = { "<C-W>c", "Delete" },
        ["-"] = { "<C-W>s", "Split below" },
        ["|"] = { "<C-W>v", "Split right" },
        ["2"] = { "<C-W>v", "Layout Double Columns" },
        ["h"] = { "<C-W>h", "Window left" },
        ["j"] = { "<C-W>j", "Window below" },
        ["l"] = { "<C-W>l", "Window right" },
        ["k"] = { "<C-W>k", "Window up" },
        ["H"] = { "<C-W>5<", "Expand left" },
        ["J"] = { ":resize +5<CR>", "Expand below" },
        ["L"] = { "<C-W>5>", "Expand right" },
        ["K"] = { ":resize -5<CR>", "Expand up" },
        ["="] = { "<C-W>=", "Balance" },
        ["s"] = { "<C-W>s", "Split below" },
        ["v"] = { "<C-W>v", "Split right" },
    },
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
        f = {
            function()
                ---@diagnostic disable-next-line: undefined-field
                require("nabla").popup()
            end,
            "Formulas",
        },
        m = {
            function()
                require("omega.utils").MarkdownPreview()
            end,
            "Markdown",
        },
    },
    p = { '"0p', "Paste Last Yank" },
    Q = { ":let @q='<c-r><c-r>q", "Edit Macro Q" },

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
    desc = "Expand snippet or jump",
})
map("s", "<leader><tab>", function()
    require("luasnip").expand_or_jump()
end, {
    noremap = true,
    silent = true,
    desc = "Expand snippet or jump",
})

map(
    "v",
    "<leader>s",
    ":s///g<LEFT><LEFT><LEFT>",
    { noremap = true, desc = "Substitue on visual selection" }
)
map(
    "i",
    "<leader><leader>",
    "<right>",
    { noremap = true, silent = true, desc = "Move right" }
)
map("i", "<leader>", " ", { noremap = true })
map(
    "n",
    "<C-f>",
    ':lua vim.cmd(":vert :h "..vim.fn.expand("<cword>"))<CR>',
    { noremap = true, silent = true, desc = "Open helpfile of word under cursor" }
)
map(
    "i",
    "<m-cr>",
    "<cr>",
    { noremap = true, silent = true, desc = "Unmapped <cr>" }
)

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
map("x", "<", "<gv", { noremap = true, desc = "Shift left and reselect" })
map("x", ">", ">gv", { noremap = true, desc = "Shift left and reselect" })

map("n", "<C-U>", function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("b~", "n", true)
    vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursor)
    end, 1)
end, {
    noremap = true,
    silent = true,
    desc = "Change case of word under cursor",
})
map("n", "Q", "@q", { noremap = true, silent = true, desc = "Execute macro q" })

-- add j and k with count to jumplist
map(
    "n",
    "j",
    [[(v:count > 1 ? "m'" . v:count : '') . 'j']],
    { noremap = true, expr = true, desc = "Add j with count to jumplist" }
)
map(
    "n",
    "k",
    [[(v:count > 1 ? "m'" . v:count : '') . 'k']],
    { noremap = true, expr = true, desc = "Add k with count to jumplist" }
)
