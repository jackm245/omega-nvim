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
                require("ignis.utils").LatexPreview()
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
                require("ignis.utils").MarkdownPreview()
            end,
            "Markdown",
        },
    },

    ["P"] = {
        name = " Packer",
        S = { "<cmd>PackerStatus<cr>", "Status" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        p = { "<cmd>PackerProfile<cr>", "Profile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
        C = { "<cmd>PackerUpdate<cr>", "Clean" },
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
