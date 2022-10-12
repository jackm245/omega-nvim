local toggleterm = {}

toggleterm.plugins = {
    ["toggleterm.nvim"] = {
        "akinsho/toggleterm.nvim",
        keys = { "<leader>r", "<c-t>" },
        module = { "toggleterm" },
    },
}

toggleterm.configs = {
    ["toggleterm.nvim"] = function()
        require("toggleterm").setup({
            hide_numbers = true,
            start_in_insert = true,
            insert_mappings = true,
            -- open_mapping = [[<c-t>]],
            shade_terminals = true,
            shading_factor = "3",
            persist_size = true,
            close_on_exit = false,
            direction = "float",
            float_opts = {
                border = require("omega.utils").border(),
                winblend = 0,
                highlights = {
                    border = "FloatBorder",
                    background = "NormalFloat",
                },
            },
        })
        omega.modules.misc.toggleterm.keybindings()
    end,
}
local exp = vim.fn.expand

local files = {
    python = "python3 -i " .. exp("%:t"),
    julia = "julia " .. exp("%:t"),
    lua = "lua " .. exp("%:t"),
    applescript = "osascript " .. exp("%:t"),
    c = "gcc -o temp " .. exp("%:t") .. " && ./temp && rm ./temp",
    cpp = "clang++ -o temp " .. exp("%:t") .. " && ./temp && rm ./temp",
    java = "javac " .. exp("%:t") .. " && java " .. exp("%:t:r") .. " && rm *.class",
    rust = "cargo run",
    javascript = "node " .. exp("%:t"),
    typescript = "tsc " .. exp("%:t") .. " && node " .. exp("%:t:r") .. ".js",
}

toggleterm.keybindings = function()
    local function run_file()
        vim.cmd.w()
        local command = files[vim.bo.filetype]
        if command ~= nil then
            require("toggleterm.terminal").Terminal
                :new({ cmd = command, close_on_exit = false })
                :toggle()
            print("Running: " .. command)
        end
    end
    local function toggle_lazygit()
        require("toggleterm.terminal").Terminal
            :new({ cmd = "lazygit", close_on_exit = true })
            :toggle()
    end

    vim.keymap.set("n", "<leader>r", function()
        run_file()
    end, { noremap = true })
    vim.keymap.set("n", "<c-t>", function()
        require("toggleterm.terminal").Terminal:new({ close_on_exit = true }):toggle()
    end, {
        noremap = true,
        silent = true,
    })
    vim.keymap.set("n", "<c-g>", function()
        toggle_lazygit()
    end, {
        noremap = true,
        silent = true,
    })
    vim.keymap.set("t", "<c-g>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
    vim.keymap.set("t", "<c-t>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
end

return toggleterm
