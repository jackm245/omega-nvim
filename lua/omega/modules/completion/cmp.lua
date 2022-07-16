local cmp_mod = {}

cmp_mod.plugins = {
    ["nvim-cmp"] = {
        -- "hrsh7th/nvim-cmp",
        "~/neovim_plugins/nvim-cmp",
        requires = { "nvim-autopairs" },
        event = { "InsertEnter", "CmdLineEnter" },
    },
    ["cmp_luasnip"] = {
        "saadparwaiz1/cmp_luasnip",
        after = "nvim-cmp",
    },
    ["cmp-emoji"] = {
        "hrsh7th/cmp-emoji",
        after = "nvim-cmp",
    },
    ["cmp-greek"] = {
        "max397574/cmp-greek",
        after = "nvim-cmp",
    },
    ["cmp-buffer"] = {
        "hrsh7th/cmp-buffer",
        after = "nvim-cmp",
    },
    ["cmp-path"] = {
        "hrsh7th/cmp-path",
        after = "nvim-cmp",
    },
    ["cmp-latex-symbols"] = {
        "kdheepak/cmp-latex-symbols",
        after = "nvim-cmp",
    },
    ["cmp-calc"] = {
        "hrsh7th/cmp-calc",
        after = "nvim-cmp",
    },
    ["cmp-nvim-lua"] = {
        "hrsh7th/cmp-nvim-lua",
        after = "nvim-cmp",
    },
    ["cmp-nvim-lsp"] = {
        "hrsh7th/cmp-nvim-lsp",
        after = "nvim-cmp",
    },
    ["cmp-cmdline"] = {
        "hrsh7th/cmp-cmdline",
        after = "nvim-cmp",
    },
    ["cmp-cmdline-history"] = {
        "dmitmel/cmp-cmdline-history",
        after = "nvim-cmp",
    },
    ["cmp-nvim-lsp-signature-help"] = {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        after = "nvim-cmp",
    },
}

local function define_highlights()
    local theme = require("omega.colors.base16").themes(vim.g.colors_name)
    local kind_highlights = {
        Class = theme.base08,
        Color = theme.base08,
        Constant = theme.base09,
        Constructor = theme.base08,
        Enum = theme.base08,
        EnumMember = theme.base08,
        Event = theme.base0D,
        Field = theme.base08,
        File = theme.base09,
        Folder = theme.base09,
        Function = theme.base0D,
        Interface = theme.base0D,
        Keyword = theme.base0E,
        Method = theme.base08,
        Module = theme.base08,
        Operator = theme.base08,
        Property = theme.base0A,
        Reference = theme.base08,
        Snippet = theme.base0C,
        Struct = theme.base08,
        Text = theme.base0B,
        TypeParameter = theme.base08,
        Type = theme.base0A,
        Unit = theme.base08,
        Value = theme.base08,
        Variable = theme.base0E,
        Structure = theme.base0E,
        Identifier = theme.base08,
    }
    local color_utils = require("omega.utils.colors")
    for kind_name, highlight in pairs(kind_highlights) do
        if highlight then
            -- TODO: check TS<...>
            if omega.config.cmp_theme == "border" then
                vim.api.nvim_set_hl(0, ("CmpItemKind%s"):format(kind_name), {
                    fg = highlight,
                })
            elseif omega.config.cmp_theme == "no-border" then
                vim.api.nvim_set_hl(0, ("CmpItemKind%s"):format(kind_name), {
                    fg = highlight,
                    bg = color_utils.blend_colors(highlight, theme.base00, 0.15),
                    -- fg = theme.base05,
                    -- bg = highlight,
                })
                vim.api.nvim_set_hl(0, ("CmpItemKindMenu%s"):format(kind_name), {
                    fg = highlight,
                })
                vim.api.nvim_set_hl(0, ("CmpItemKindBlock%s"):format(kind_name), {
                    fg = color_utils.blend_colors(highlight, theme.base00, 0.15),
                })
            end
        end
    end
end

cmp_mod.configs = {
    ["nvim-cmp"] = function()
        local cmp = require("cmp")
        local types = require("cmp.types")
        local luasnip = require("luasnip")
        local neogen = require("neogen")
        local str = require("cmp.utils.str")
        local kind = require("omega.modules.lsp.kind")

        local function get_abbr(vim_item, entry)
            local word = entry:get_insert_text()
            if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                word = vim.lsp.util.parse_snippet(word)
            end
            word = str.oneline(word)

            -- concatenates the string
            local max = 50
            if string.len(word) >= max then
                local before = string.sub(word, 1, math.floor((max - 3) / 2))
                word = before .. "..."
            end

            if
                entry.completion_item.insertTextFormat
                    == types.lsp.InsertTextFormat.Snippet
                and string.sub(vim_item.abbr, -1, -1) == "~"
            then
                word = word .. "~"
            end
            return word
        end
        vim.cmd([[PackerLoad nvim-autopairs]])
        vim.cmd([[PackerLoad LuaSnip]])
        define_highlights()
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

        local function t(string)
            return vim.api.nvim_replace_termcodes(string, true, true, true)
        end
        local border = {
            { "╭", "CmpBorder" },
            { "─", "CmpBorder" },
            { "╮", "CmpBorder" },
            { "│", "CmpBorder" },
            { "╯", "CmpBorder" },
            { "─", "CmpBorder" },
            { "╰", "CmpBorder" },
            { "│", "CmpBorder" },
        }

        local config = {
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<C-f>"] = cmp.mapping(function(fallback)
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.scroll_docs(4)
                    elseif luasnip.choice_active() then
                        require("luasnip").change_choice(1)
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
                ["<C-d>"] = cmp.mapping(function(fallback)
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.scroll_docs(-4)
                    elseif luasnip.choice_active() then
                        require("luasnip").change_choice(-1)
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),

                ["<c-j>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({
                            behavior = cmp.SelectBehavior.Insert,
                        })
                    elseif luasnip.jumpable(1) then
                        luasnip.jump(1)
                    elseif neogen.jumpable(1) then
                        neogen.jump_next()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),

                ["<c-k>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({
                            behavior = cmp.SelectBehavior.Insert,
                        })
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    elseif neogen.jumpable(-1) then
                        vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_prev()<CR>"), "")
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),

                ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

                ["<C-e>"] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),

                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({
                        select = true,
                        behavior = cmp.ConfirmBehavior.Insert,
                    }),
                    c = cmp.mapping.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior.Insert,
                    }),
                }),
                ["<tab>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_next_item({
                            behavior = cmp.SelectBehavior.Insert,
                        })
                    end
                end, {
                    "c",
                }),
                ["<s-tab>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_prev_item({
                            behavior = cmp.SelectBehavior.Insert,
                        })
                    end
                end, {
                    "c",
                }),
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if luasnip.choice_active() then
                        require("luasnip").change_choice(1)
                    elseif neogen.jumpable() then
                        vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_next()<CR>"), "")
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
                ["<C-h>"] = cmp.mapping(function(fallback)
                    if luasnip.choice_active() then
                        require("luasnip").change_choice(-1)
                    elseif neogen.jumpable(-1) then
                        vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_prev()<CR>"), "")
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
            },

            sources = {
                { name = "buffer", priority = 7, keyword_length = 4 },
                { name = "path", priority = 5 },
                { name = "emoji", priority = 3 },
                { name = "greek", priority = 1 },
                { name = "calc", priority = 4 },
                { name = "cmdline", priority = 4 },
                -- { name = "copilot", priority = 8 },
                -- { name = "cmp_tabnine", priority = 8 },
                { name = "nvim_lsp", priority = 9 },
                { name = "luasnip", priority = 8 },
                { name = "neorg", priority = 6 },
                { name = "latex_symbols", priority = 1 },
                { name = "nvim_lsp_signature_help", priority = 10 },
            },
            enabled = function()
                if vim.bo.ft == "TelescopePrompt" then
                    return false
                end
                if vim.bo.ft == "lua" then
                    return true
                end
                local lnum, col = vim.fn.line("."), math.min(vim.fn.col("."), #vim.fn.getline("."))
                for _, syn_id in ipairs(vim.fn.synstack(lnum, col)) do
                    syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
                    if vim.fn.synIDattr(syn_id, "name") == "Comment" then
                        return false
                    end
                end
                if string.find(vim.api.nvim_buf_get_name(0), "neorg://") then
                    return false
                end
                if string.find(vim.api.nvim_buf_get_name(0), "s_popup:/") then
                    return false
                end
                return true
            end,
            sorting = {
                comparators = cmp.config.compare.recently_used,
            },
            experimental = {
                ghost_text = true,
            },
        }
        if omega.config.cmp_theme == "border" then
            config.window = {
                completion = {
                    border = border,
                    scrollbar = "║",
                },
                documentation = {
                    border = border,
                    scrollbar = "║",
                },
            }
            config.formatting = {
                fields = {
                    "kind",
                    "abbr",
                    "menu",
                },
                format = kind.cmp_format({
                    with_text = false,
                    before = function(entry, vim_item)
                        vim_item.abbr = get_abbr(vim_item, entry)

                        vim_item.dup = ({
                            buffer = 1,
                            path = 1,
                            nvim_lsp = 0,
                        })[entry.source.name] or 0

                        return vim_item
                    end,
                }),
            }
        elseif omega.config.cmp_theme == "no-border" then
            config.window = {
                completion = {
                    winhighlight = "Normal:Pmenu,FloatBorder:CmpDocumentationBorder,Search:None",
                    left_side_padding = 0,
                    right_side_padding = 1,
                    col_offset = 1,
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "FloatBorder:CmpDocumentationBorder,Search:None",
                    max_width = 80,
                    col_offset = -1,
                    max_height = 12,
                },
            }
            config.formatting = {
                fields = {
                    -- "surround_start",
                    "kind",
                    "surround_end",
                    "padding",
                    "abbr",
                    "padding",
                    "menu",
                },
                format = function(entry, item)
                    item.menu = item.kind
                    item.surround_start = "▐"
                    -- item.surround_end = "▌"
                    item.surround_end = ""
                    item.surround_start_hl_group = ("CmpItemKindBlock%s"):format(item.kind)
                    item.surround_end_hl_group = ("CmpItemKindBlock%s"):format(item.kind)
                    item.menu_hl_group = ("CmpItemKindMenu%s"):format(item.kind)
                    item.padding = " "
                    item.kind = kind.presets.default[item.kind] or ""
                    item.dup = vim.tbl_contains({ "path", "buffer" }, entry.source.name)
                    item.abbr = get_abbr(item, entry)
                    item.test = "test"
                    item.test_hl_group = "String"

                    return item
                end,
            }
        end
        cmp.setup(config)

        cmp.setup.cmdline(":", {
            sources = {
                { name = "cmdline", group_index = 1 },
                -- { name = "cmdline" },
                { name = "cmdline_history", group_index = 2 },
            },
            view = {
                entries = { name = "wildmenu", separator = " | " },
            },
        })

        cmp.setup.cmdline("/", {
            sources = {
                { name = "cmdline_history" },
                { name = "buffer" },
            },
            view = {
                entries = { name = "wildmenu", separator = " | " },
            },
        })
        vim.cmd([[PackerLoad neorg]])
        local neorg = require("neorg")

        local function load_completion()
            neorg.modules.load_module("core.norg.completion", nil, {
                engine = "nvim-cmp",
            })
        end

        if neorg.is_loaded() then
            load_completion()
        else
            neorg.callbacks.on_event("core.started", load_completion)
        end

        vim.cmd([[hi NormalFloat guibg=none]])
    end,
}

return cmp_mod
