local modules = {}

function modules.setup()
    local module_sections = {
        ["ui"] = {
            -- "blankline", -- can't lazyload
            "bufferline",
            "heirline",
            "devicons",
            "notify",
        },
        ["mappings"] = {
            "which_key",
        },
        ["core"] = {
            "omega",
        },
        ["lsp"] = {
            "main",
            "lua",
        },
        ["completion"] = {
            "autopairs",
            "cmp",
            "snippets",
            "annotations",
        },
        ["misc"] = {
            "gitsigns",
            "help_files",
            "symbols_outline",
            "nvim-tree",
            "treesitter",
            "neorg",
            "nabla",
        -- },
        -- ["tools"] = {
            "comment",
            "colorizer",
            "telescope",
            "toggleterm",
            "trouble",
            "todo",
            -- "dynamic_help",
            "formatter",
            "paperplanes",
        -- },
        -- ["utils"] = {
            "mkdir",
            "gitlinker",
            "insert_utils",
            "colorscheme_switcher",
            "surround",
            "lightspeed",
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
            clone_timeout = 300, -- 5 mins
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
        },
        keybindings = {
            toggle_info = "<TAB>",
        },
        profile = {
            enable = true,
        },
    })

    packer.reset()
end

function modules.load()
    local use = require("packer").use
    if not omega.config.use_impatient then
        omega.modules.core.omega.plugins["impatient.nvim"] = nil
    end
    for sec_name, section in pairs(omega.modules) do
        for mod_name, mod in pairs(section) do
            for plugin, packer_spec in pairs(mod.plugins) do
                if
                    mod.configs
                    and mod.configs[plugin]
                    and type(mod.configs[plugin]) == "function"
                then
                    packer_spec["config"] = mod.configs[plugin]
                end
                use(packer_spec)
            end
        end
    end
    for sec_name, section in pairs(omega.modules) do
        for mod_name, mod in pairs(section) do
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
            local packer_path = vim.fn.stdpath("data")
                .. "/site/pack/packer/start/packer.nvim"
            if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
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
