local function map(mode, key, cmd)
    if string.find(cmd, "<Plug>") then
        -- <Plug> does not work with noremap
        vim.api.nvim_set_keymap(mode, key, cmd, {})
    else
        vim.api.nvim_set_keymap(mode, key, cmd, { noremap = true })
    end
end

map(
    "v",
    "<Plug>SurroundAddVisual",
    "<esc>gv<cmd>lua require('surround').surround_add(false)<cr>"
)
map(
    "n",
    "<Plug>SurroundAddNormal",
    "<cmd>lua require('surround').surround_add(true)<cr>"
)
map(
    "n",
    "<Plug>SurroundDelete",
    "<cmd>lua require('surround').surround_delete()<cr>"
)
map(
    "n",
    "<Plug>SurroundReplace",
    "<cmd>lua require('surround').surround_replace()<cr>"
)
map(
    "n",
    "<Plug>SurroundRepeat",
    "<cmd>lua require('surround').repeat_last()<cr>"
)
map(
    "n",
    "<Plug>SurroundToggleQuotes",
    "<cmd>lua require('surround').toggle_quotes()<cr>"
)
map(
    "n",
    "<Plug>SurroundToggleBrackets",
    "<cmd>lua require('surround').toggle_brackets()<cr>"
)
map("x", "s", "<Plug>SurroundAddVisual")
map("n", "ys", "<Plug>SurroundAddNormal")
map("n", "ds", "<Plug>SurroundDelete")
map("n", "cs", "<Plug>SurroundReplace")
map("n", "cq", "<Plug>SurroundToggleQuotes")
