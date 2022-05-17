local lua_lsp = {}

lua_lsp.plugins = {
    ["lua-dev.nvim"] = {
        "~/neovim_plugins/lua-dev.nvim",
        opt = true,
    },
}

lua_lsp.configs = {
    ["lua-dev.nvim"] = function()
        local lspconfig = require("lspconfig")
        local lua_cmd = {
            vim.fn.expand("~") .. "/lua-language-server/bin/lua-language-server",
        }
        local function on_attach(client, bufnr)
            require("omega.modules.lsp.on_attach").setup(client, bufnr)
        end

        local sumneko_lua_server = {
            on_attach = on_attach,
            cmd = lua_cmd,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                            "dump",
                            "hs",
                            "lvim",
                            "P",
                            "RELOAD",
                            "neorg",
                        },
                    },
                    workspace = {
                        maxPreload = 100000,
                        preloadFileSize = 1000,
                    },
                },
            },
        }

        local lua_dev_plugins = {
            "selection_popup",
            "plenary.nvim",
        }
        local runtime_path_completion = true
        if not runtime_path_completion then
            sumneko_lua_server.settings.Lua.runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
                vim.fn.expand("~") .. "/.config/neovim_configs/omega/lua/?.lua",
            }
        end

        local luadev = require("lua-dev").setup({
            library = {
                vimruntime = true,
                types = true,
                plugins = lua_dev_plugins, -- toggle this to get completion for require of all plugins
            },
            runtime_path = runtime_path_completion,
            lspconfig = sumneko_lua_server,
        })

        lspconfig.sumneko_lua.setup(luadev)
    end,
}

return lua_lsp
