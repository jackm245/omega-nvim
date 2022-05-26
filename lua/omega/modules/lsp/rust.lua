local rust_lsp = {}

rust_lsp.plugins = {
    ["rust-tools.nvim"] = {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        requires = {
            {
                "mfussenegger/nvim-dap",
                after = "rust-tools.nvim",
                config = function()
                    vim.cmd([[PackerLoad nvim-dap-ui]])
                end,
            },
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    require("dapui").setup({
                        mappings = { toggle = "<tab>" },
                    })
                end,
                opt = true,
            },
        },
    },
}

rust_lsp.configs = {
    ["rust-tools.nvim"] = function()
        local function on_attach(client, bufnr)
            require("omega.modules.lsp.on_attach").setup(client, bufnr)
        end
        local extension_path = vim.fn.expand("~")
            .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
        require("rust-tools").setup({
            dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(
                    codelldb_path,
                    liblldb_path
                ),
            },
            server = {
                on_attach = on_attach,
            },
        })
    end,
}

return rust_lsp
