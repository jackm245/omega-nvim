---@type OmegaModule
local venn = {}

venn.plugins = {
    ["venn.nvim"] = {
        "jbyuki/venn.nvim",
        cmd = {"VBox","VBoxH","VBoxD","VBoxHO","VBoxDO",},
    },
}

local function toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd([[setlocal ve=all]])
        -- draw a line on HJKL keystokes
        vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { noremap = true, buffer = true })
        vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { noremap = true, buffer = true })
        vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { noremap = true, buffer = true })
        vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { noremap = true, buffer = true })
        -- draw a box by pressing "b" with visual selection
        vim.keymap.set("v", "b", ":VBox<CR>", { noremap = true, buffer = true })
    else
        vim.cmd([[setlocal ve=]])
        vim.keymap.del("n", "H", { buffer = 0 })
        vim.keymap.del("n", "J", { buffer = 0 })
        vim.keymap.del("n", "K", { buffer = 0 })
        vim.keymap.del("n", "L", { buffer = 0 })
        vim.keymap.del("v", "b", { buffer = 0 })
        vim.b.venn_enabled = nil
    end
end

venn.keybindings = function()
    require("which-key").register({
        V = {
            function()
                toggle_venn()
            end,
            " Venn",
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
end

return venn
