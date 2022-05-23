local mkdir = {}

mkdir.plugins = {
    ["mkdir.nvim"] = {
        "jghauser/mkdir.nvim",
        event = "BufWritePre",
    },
}

mkdir.configs = {
    ["mkdir.nvim"] = function()
        require("mkdir")
    end,
}

return mkdir
