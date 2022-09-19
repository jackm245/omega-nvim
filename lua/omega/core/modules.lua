local modules = {}

function modules.setup()
    local module_sections = {
        ["langs"] = {
            "log",
        },
        ["ui"] = {
            "blankline",
            "bufferline",
            "devicons",
            "heirline",
            "notify",
        },
        ["mappings"] = {
            "which_key",
        },
        ["core"] = {
            "omega",
        },
        ["lsp"] = {
            "lua",
            "main",
            "python",
            "rust",
            "swift",
        },
        ["completion"] = {
            "annotations",
            "autopairs",
            "cmp",
            "snippets",
        },
        ["misc"] = {
            "colorizer",
            "colorscheme_switcher",
            "colortils",
            "comment",
            -- "dynamic_help",
            "formatter",
            "gitlinker",
            "gitsigns",
            "harpoon",
            "help_files",
            "holo",
            "image",
            "insert_utils",
            "lightspeed",
            "mkdir",
            "nabla",
            "neorg",
            "nvim-tree",
            "paperplanes",
            "sj",
            "surround",
            "symbols_outline",
            "telescope",
            "todo",
            "toggleterm",
            -- "tomato",
            "treesitter",
            "trouble",
            "undotree",
            "venn",
            "windows",
        },
        ["games"] = {
            "vimbegood",
        },
    }
    for section, sec_modules in pairs(module_sections) do
        omega.modules[section] = {}
        for _, module in ipairs(sec_modules) do
            local ok, result = xpcall(
                require,
                debug.traceback,
                string.format("omega.modules.%s.%s", section, module)
            )
            if ok then
                omega.modules[section][module] = result
            else
                print(result)
            end
        end
    end
    local packer = require("packer")
    packer.init({
        compile_path = vim.fn.stdpath("data") .. "/plugin/packer_compiled.lua",
        git = {
            clone_timeout = 300,
            subcommands = {
                -- Prevent packer from downloading all branches metadata to reduce cloning cost
                -- for heavy size plugins like plenary (removed the '--no-single-branch' git flag)
                install = "clone --depth %i --progress",
            },
        },
        max_jobs = 10,
        display = {
            done_sym = "",
            error_syn = "×",
            open_fn = function()
                return require("packer.util").float({
                    border = require("omega.utils").border(),
                })
            end,
            keybindings = {
                toggle_info = "<TAB>",
            },
        },
        profile = {
            enable = true,
        },
        snapshot = "stable",
    })

    packer.reset()
end

function modules.load()
    local use = require("packer").use
    if not omega.config.use_impatient then
        omega.modules.core.omega.plugins["impatient.nvim"] = nil
    end
    for _, section in pairs(omega.modules) do
        for _, mod in pairs(section) do
            for plugin, packer_spec in pairs(mod.plugins) do
                if
                    mod.configs
                    and mod.configs[plugin]
                    and type(mod.configs[plugin]) == "function"
                then
                    omega.plugin_configs[plugin] = mod.configs[plugin]
                    packer_spec["config"] = function(name)
                        omega.plugin_configs[name]()
                    end
                end
                use(packer_spec)
            end
        end
    end
    for _, section in pairs(omega.modules) do
        for _, mod in pairs(section) do
            if mod.keybindings then
                mod.keybindings()
            end
        end
    end
end

function modules.bootstrap_packer()
    function modules.packer_bootstrap()
        local has_packer = pcall(require, "packer")
        if not has_packer then
            -- Packer Bootstrapping
            local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
            if vim.fn.isdirectory(packer_path) == 0 then
                vim.notify("Bootstrapping packer.nvim, please wait ...")
                vim.fn.system({
                    "git",
                    "clone",
                    "--depth",
                    "1",
                    "https://github.com/wbthomason/packer.nvim",
                    packer_path,
                })
            end

            vim.cmd("packadd packer.nvim")
        end
    end
end

return modules
