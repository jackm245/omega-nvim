local map=vim.keymap.set

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
    ["P"]={
	name=" Packer",
	S={"<cmd>PackerStatus<cr>","Status"},
	s={"<cmd>PackerSync<cr>", "Sync"},
	c={"<cmd>PackerCompile<cr>","Compile"},
	p={"<cmd>PackerProfile<cr>","Profile"},
	i={"<cmd>PackerInstall<cr>", "Install"},
	u={"<cmd>PackerUpdate<cr>", "Update"},
	C={"<cmd>PackerUpdate<cr>", "Clean"},
    }
}, {
    prefix = "<leader>",
    mode = "n",
})

map("n",",,", function() require"omega.utils".append_comma() end,{
    noremap=true,silent=true,desc="Append comma"
})

map("n",";;", function() require"omega.utils".append_semicolon() end,{
    noremap=true,silent=true,desc="Append semicolon"
})
