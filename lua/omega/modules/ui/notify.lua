---@type OmegaModule
local notify = {}

notify.plugins = {
    ["nvim-notify"] = {
        "rcarriga/nvim-notify",
        opt = true,
        setup = function()
            vim.notify = function(msg, level, opts)
                require("packer").loader("nvim-notify")
                vim.notify = require("notify")
                vim.notify(msg, level, opts)
            end
        end,
    },
}

return notify
