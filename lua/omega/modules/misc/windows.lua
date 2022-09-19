local windows = {}

windows.plugins = {
    ["windows.nvim"] = {
        "anuvyklack/windows.nvim",
        opt = true,
        setup = function()
            vim.api.nvim_create_autocmd("WinEnter", {
                pattern = "*",
                callback = function()
                    local info = vim.fn.gettabinfo(vim.fn.tabpagenr())
                    if #info[1].windows >= 2 then
                        vim.cmd([[PackerLoad animation.nvim]])
                        vim.cmd([[PackerLoad middleclass]])
                        vim.cmd([[PackerLoad windows.nvim]])
                        require("windows").setup()
                    end
                end,
            })
        end,
    },
    ["middleclass"] = {
        "anuvyklack/middleclass",
        opt = true,
    },
    ["animation.nvim"] = {
        "anuvyklack/animation.nvim",
        opt = true,
    },
}

return windows
