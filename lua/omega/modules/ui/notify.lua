---@type OmegaModule
local notify = {}

notify.plugins = {
    ["nvim-notify"] = {
        "rcarriga/nvim-notify",
        opt = true,
        setup = function()
            vim.notify = function(msg, level, opts)
                require("packer").loader("nvim-notify")
                local colors = require("omega.colors").get()
                require("notify").setup({ background_color = colors.black })
                vim.notify = require("notify")
                vim.notify(msg, level, opts)
            end
        end,
    },
}

notify.configs = {
    ["nvim-notify"] = function()
        local colors = require("omega.colors").get()
        require("notify").setup({ background_color = colors.black })
    end,
}

return notify
