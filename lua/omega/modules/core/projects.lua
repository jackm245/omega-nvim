---@type OmegaModule
local project_mod = {}

project_mod.plugins = {
    ["projects.nvim"] = {
        "~/neovim_plugins/projects.nvim/",
        after="nvim-lspconfig"
    },
}

project_mod.configs = {
    ["projects.nvim"] = function()
        local Project = require("projects.projects")
        
    end,
}

return project_mod
