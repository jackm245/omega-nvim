local tele_mod = {}

tele_mod.plugins = {
    ["telescope.nvim"] = {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        module = {
            "telescope",
            "omega.modules.misc.telescope",
        },
    },
    ["telescope-emoji.nvim"] = {
        "xiyaowong/telescope-emoji.nvim",
        after = "telescope.nvim",
    },
    ["telescope-fzf-native.nvim"] = {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        after = "telescope.nvim",
    },
    ["telescope-symbols.nvim"] = {
        "nvim-telescope/telescope-symbols.nvim",
        after = "telescope.nvim",
    },
    ["telescope-file-browser.nvim"] = {
        "nvim-telescope/telescope-file-browser.nvim",
        after = "telescope.nvim",
    },
    ["telescope-ui-select.nvim"] = {
        "nvim-telescope/telescope-ui-select.nvim",
        opt = true,
        setup = function()
            vim.ui.select = function(items, opts, on_choice)
                vim.cmd([[
                    PackerLoad telescope.nvim
                    PackerLoad telescope-ui-select.nvim
                ]])
                require("telescope").load_extension("ui-select")
                vim.ui.select(items, opts, on_choice)
            end
        end,
    },
}

tele_mod.configs = {
    ["telescope.nvim"] = function()
        local actions = require("telescope.actions")
        local flatten = vim.tbl_flatten
        local action_state = require("telescope.actions.state")
        local sorters = require("telescope.sorters")
        local finders = require("telescope.finders")
        local pickers = require("telescope.pickers")
        local make_entry = require("telescope.make_entry")
        local previewers = require("telescope.previewers")
        local conf = require("telescope.config").values
        --- Pick any picker and use `cwd` as `cwd`
        ---@param cwd string The `cwd` to use
        local function pick_pickers(cwd)
            local opts = {}
            if not cwd then
                return
            end
            print(cwd)
            opts.include_extensions = true

            local objs = {}

            for k, v in pairs(require("telescope.builtin")) do
                local debug_info = debug.getinfo(v)
                table.insert(objs, {
                    filename = string.sub(debug_info.source, 2),
                    text = k,
                })
            end

            local title = "Telescope Builtin"

            if opts.include_extensions then
                title = "Telescope Pickers"
                for ext, funcs in pairs(require("telescope").extensions) do
                    for func_name, func_obj in pairs(funcs) do
                        -- Only include exported functions whose name doesn't begin with an underscore
                        if
                            type(func_obj)
                                == "function"
                            and string.sub(func_name, 0, 1) ~= "_"
                        then
                            local debug_info = debug.getinfo(func_obj)
                            table.insert(objs, {
                                filename = string.sub(debug_info.source, 2),
                                text = string.format("%s : %s", ext, func_name),
                            })
                        end
                    end
                end
            end

            pickers.new(opts, {
                prompt_title = title,
                finder = finders.new_table({
                    results = objs,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            text = entry.text,
                            display = entry.text,
                            ordinal = entry.text,
                            filename = entry.filename,
                        }
                    end,
                }),
                previewer = previewers.builtin.new(opts),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(_)
                    actions.select_default:replace(function(_)
                        local selection = action_state.get_selected_entry()
                        if not selection then
                            print("[telescope] Nothing currently selected")
                            return
                        end

                        -- we do this to avoid any surprises
                        opts.include_extensions = nil
                        opts.cwd = cwd

                        if string.match(selection.text, " : ") then
                            -- Call appropriate function from extensions
                            local split_string = vim.split(
                                selection.text,
                                " : "
                            )
                            local ext = split_string[1]
                            local func = split_string[2]
                            require("telescope").extensions[ext][func](opts)
                        else
                            -- Call appropriate telescope builtin
                            require("telescope.builtin")[selection.text](opts)
                        end
                    end)
                    return true
                end,
            }):find()
        end

        local picker_selection_as_cwd = function(prompt_bufnr)
            local get_target_dir = function(finder)
                local entry_path
                local entry = action_state.get_selected_entry()
                if finder.files == false then
                    entry_path = entry and entry.value -- absolute path
                end
                return finder.files and finder.path or entry_path
            end
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local finder = current_picker.finder

            local dir = get_target_dir(finder)
            actions.close(prompt_bufnr)
            pick_pickers(dir)
        end

        local live_grep_selected = function(prompt_bufnr)
            local opts = {
                border = true,
                disable_coordinates = true,
                -- layout_strategy = "custom_bottom",
                file_ignore_patterns = {
                    "vendor/*",
                    "node_modules",
                    "target/",
                    "%.jpg",
                    "%.jpeg",
                    "%.png",
                    "%.svg",
                    "%.otf",
                    "%.ttf",
                },
                layout_config = {
                    height = 0.5,
                    prompt_position = "top",
                    width = 0.99,
                },
                preview = {
                    hide_on_startup = false,
                },
                preview_title = "~ Location Preview ~ ",
                prompt_title = "~ Find String ~",
                results_title = "~ Occurrences ~",
                shorten_path = false,
            }
            local picker = action_state.get_current_picker(prompt_bufnr)
            local entries = picker:get_multi_selection()
            opts.cwd = entries[1].cwd
            local search_list = {}

            for _, entry in ipairs(entries) do
                table.insert(search_list, entry[1])
            end
            actions.close(prompt_bufnr)
            local live_grepper = finders.new_job(function(prompt)
                -- TODO: Probably could add some options for smart case and whatever else rg offers.

                if not prompt or prompt == "" then
                    return nil
                end

                local vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                }

                local additional_args = {}

                return flatten({
                    vimgrep_arguments,
                    additional_args,
                    "--",
                    prompt,
                    search_list,
                })
            end, make_entry.gen_from_vimgrep(
                opts
            ), opts.max_results, opts.cwd)

            pickers.new(opts, {
                prompt_title = "Live Grep",
                finder = live_grepper,
                previewer = conf.grep_previewer(opts),
                -- TODO: It would be cool to use `--json` output for this
                -- and then we could get the highlight positions directly.
                sorter = sorters.highlighter_only(opts),
            }):find()
        end

        vim.cmd([[
            PackerLoad telescope-fzf-native.nvim
        ]])
        local actions = require("telescope.actions")
        local action_layout = require("telescope.actions.layout")
        local actions_layout = require("telescope.actions.layout")
        -- local fb_actions = require("telescope._extensions.file_browser.actions")
        local themes = require("telescope.themes")
        local previewers = require("telescope.previewers")
        local finders = require("telescope.finders")
        local pickers = require("telescope.pickers")
        local resolve = require("telescope.config.resolve")
        local p_window = require("telescope.pickers.window")
        local if_nil = vim.F.if_nil

        local calc_tabline = function(max_lines)
            local tbln = (vim.o.showtabline == 2)
                or (
                    vim.o.showtabline == 1
                    and #vim.api.nvim_list_tabpages() > 1
                )
            if tbln then
                max_lines = max_lines - 1
            end
            return max_lines, tbln
        end

        local get_border_size = function(opts)
            if opts.window.border == false then
                return 0
            end

            return 1
        end

        local calc_size_and_spacing =
            function(cur_size, max_size, bs, w_num, b_num, s_num)
                local spacing = s_num * (1 - bs) + b_num * bs
                cur_size = math.min(cur_size, max_size)
                cur_size = math.max(cur_size, w_num + spacing)
                return cur_size, spacing
            end

        require("telescope.pickers.layout_strategies").custom_bottom =
            function(self, max_columns, max_lines, layout_config)
                local initial_options = p_window.get_initial_window_options(
                    self
                )
                local results = initial_options.results
                local prompt = initial_options.prompt
                local preview = initial_options.preview
                layout_config = {
                    anchor = "S",
                    -- preview_width = 0.6,
                    bottom_pane = {
                        height = 0.5,
                        preview_cutoff = 20,
                        prompt_position = "top",
                    },
                    custom_bottom = {
                        height = 0.5,
                        preview_cutoff = 20,
                        -- preview_width = 0.6,
                        prompt_position = "top",
                    },
                    center = {
                        height = 0.5,
                        preview_cutoff = 20,
                        prompt_position = "top",
                        width = 0.99,
                    },
                    cursor = {
                        height = 0.5,
                        preview_cutoff = 20,
                        width = 0.99,
                    },
                    flex = {
                        horizontal = {},
                        preview_width = 0.65,
                    },
                    height = 0.5,
                    horizontal = {
                        height = 0.5,
                        preview_cutoff = 20,
                        preview_width = 0.65,
                        prompt_position = "top",
                        width = 0.99,
                    },
                    preview_cutoff = 20,
                    prompt_position = "top",
                    vertical = {
                        height = 0.95,
                        preview_cutoff = 20,
                        preview_height = 0.5,
                        preview_width = 0.65,
                        prompt_position = "top",
                        width = 0.9,
                    },
                    width = 0.99,
                }

                local tbln
                max_lines, tbln = calc_tabline(max_lines)

                local height = if_nil(
                    resolve.resolve_height(layout_config.height)(
                        self,
                        max_columns,
                        max_lines
                    ),
                    25
                )
                local width_opt = layout_config.width

                local width = resolve.resolve_width(width_opt)(
                    self,
                    max_columns,
                    max_lines
                )

                -- local height = 21
                if
                    type(layout_config.height)
                        == "table"
                    and type(layout_config.height.padding) == "number"
                then
                    height = math.floor((max_lines + height) / 2)
                end
                prompt.border = results.border

                local bs = get_border_size(self)

                -- Cap over/undersized height
                height, _ = calc_size_and_spacing(
                    height,
                    max_lines,
                    bs,
                    2,
                    3,
                    0
                )

                -- Height
                prompt.height = 2
                results.height = height - prompt.height - (2 * bs)
                preview.height = results.height - bs

                -- Width
                local w_space

                preview.width = 0
                prompt.width = max_columns - 2 * bs
                if
                    self.previewer
                    and max_columns >= layout_config.preview_cutoff
                then
                    -- Cap over/undersized width (with preview)
                    width, w_space = calc_size_and_spacing(
                        max_columns,
                        max_columns,
                        bs,
                        2,
                        4,
                        0
                    )

                    preview.width = resolve.resolve_width(
                        if_nil(layout_config.preview_width, 0.6)
                    )(self, width, max_lines)
                    results.width = width - preview.width - w_space
                    prompt.width = results.width
                    results.width = results.width
                else
                    width, w_space = calc_size_and_spacing(
                        width,
                        max_columns,
                        bs,
                        1,
                        2,
                        0
                    )
                    preview.width = 0
                    results.width = width - preview.width - w_space
                    prompt.width = results.width
                end

                -- Line
                if layout_config.prompt_position == "top" then
                    prompt.line = max_lines - results.height - (1 + bs) + 1
                    results.line = prompt.line + 1
                    preview.line = prompt.line + 1
                    if results.border == true then
                        results.border = { 0, 1, 1, 1 }
                    end
                    if type(results.title) == "string" then
                        results.title = { { pos = "S", text = results.title } }
                    end
                elseif layout_config.prompt_position == "bottom" then
                    results.line = max_lines - results.height - (1 + bs) + 1
                    results.line = prompt.line + 1
                    preview.line = results.line
                    prompt.line = max_lines - bs
                    if type(prompt.title) == "string" then
                        prompt.title = { { pos = "S", text = prompt.title } }
                    end
                    if results.border == true then
                        results.border = { 1, 1, 0, 1 }
                    end
                else
                    error(
                        "Unknown prompt_position: "
                            .. tostring(self.window.prompt_position)
                            .. "\n"
                            .. vim.inspect(layout_config)
                    )
                end
                local width_padding = math.floor((max_columns - width) / 2)

                -- Col
                prompt.col = 0 -- centered
                if layout_config.mirror and preview.width > 0 then
                    results.col = preview.width + (3 * bs)
                    preview.col = bs + 1
                    prompt.col = results.col
                else
                    preview.col = prompt.width + width_padding + bs + 1

                    results.col = bs + 1
                    prompt.col = preview.col + preview.width + bs
                end

                if tbln then
                    -- prompt.line = prompt.line + 1
                    results.line = results.line + 1
                    preview.line = preview.line
                    prompt.line = prompt.line
                else
                    results.line = results.line + 1
                end
                prompt.line = prompt.line + 1
                results.line = results.line + 1
                preview.col = preview.col + 1
                preview.height = preview.height - 2
                prompt.col = 2
                results.height = results.height - 1
                preview.height = prompt.height + results.height
                results.col = 2

                return {
                    preview = self.previewer and preview.width > 0 and preview,
                    prompt = prompt,
                    results = results,
                }
            end
        local _bad = { ".*%.md" } -- Put all filetypes that slow you down in this array
        local bad_files = function(filepath)
            for _, v in ipairs(_bad) do
                if filepath:match(v) then
                    return false
                end
            end

            return true
        end

        local new_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            if opts.use_ft_detect == nil then
                opts.use_ft_detect = true
            end
            opts.use_ft_detect = opts.use_ft_detect == false and false
                or bad_files(filepath)
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
        if omega.config.telescope_theme == "custom_bottom_no_borders" then
            require("telescope").setup(themes.get_ivy({
                -- defaults = themes.get_ivy({
                defaults = {
                    buffer_previewer_maker = new_maker,
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    layout_strategy = "custom_bottom",
                    sorting_strategy = "ascending",
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    get_status_text = function(_)
                        return ""
                    end,
                    layout_config = {
                        width = 0.85,
                        height = 0.9,
                        preview_cutoff = 20,
                        prompt_position = "top",
                        vertical = { mirror = false },
                        horizontal = {
                            mirror = false,
                            preview_width = 0.6,
                        },
                    },
                    mappings = {
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = live_grep_selected,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist
                                + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist
                                + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<c-p>"] = action_layout.toggle_prompt_position,
                            ["<C-k>"] = actions.move_selection_previous,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist
                                + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist
                                + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-s>"] = live_grep_selected,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                    },
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown({}),
                        },
                        ["file_browser"] = {
                            -- theme = "ivy",
                            mappings = {
                                ["i"] = {
                                    ["<C-o>"] = actions.select_vertical,
                                    -- ["<C-b>"] = fb_actions.toggle_browser,
                                },
                                ["n"] = {},
                            },
                        },
                        fzf = {
                            fuzzy = true, -- false will only do exact matching
                            override_generic_sorter = false, -- override the generic sorter
                            override_file_sorter = true, -- override the file sorter
                            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                        },
                    },
                    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                },
            }))
        elseif omega.config.telescope_theme == "float_all_borders" then
            require("telescope").setup({
                -- defaults = themes.get_ivy({
                defaults = {
                    buffer_previewer_maker = new_maker,
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    get_status_text = function(_)
                        return ""
                    end,
                    layout_config = {
                        width = 0.85,
                        height = 0.9,
                        preview_cutoff = 20,
                        prompt_position = "top",
                        vertical = { mirror = false },
                        horizontal = {
                            mirror = false,
                            preview_width = 0.6,
                        },
                    },
                    mappings = {
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = live_grep_selected,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist
                                + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist
                                + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<c-p>"] = action_layout.toggle_prompt_position,
                            ["<C-k>"] = actions.move_selection_previous,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist
                                + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist
                                + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-s>"] = live_grep_selected,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                    },
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown({}),
                        },
                        ["file_browser"] = {
                            -- theme = "ivy",
                            mappings = {
                                ["i"] = {
                                    ["<C-o>"] = actions.select_vertical,
                                    -- ["<C-b>"] = fb_actions.toggle_browser,
                                },
                                ["n"] = {},
                            },
                        },
                        fzf = {
                            fuzzy = true, -- false will only do exact matching
                            override_generic_sorter = false, -- override the generic sorter
                            override_file_sorter = true, -- override the file sorter
                            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                        },
                    },
                    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                },
            })
        end
        require("telescope").load_extension("fzf")
    end,
    ["telescope-emoji.nvim"] = function()
        require("telescope").load_extension("emoji")
    end,
}

tele_mod.keybindings = function()
    local wk = require("which-key")
    wk.register({
        C = {
            name = " Colors",
            p = {
                function()
                    omega.modules.misc.telescope.api.colorscheme_switcher()
                end,
                "Pick",
            },
            s = {
                function()
                    require("telescope.builtin").highlights()
                end,
                "Search",
            },
        },

        f = {
            name = " Find",
            f = {
                function()
                    omega.modules.misc.telescope.api.find_files()
                end,
                "File",
            },
        },
        ["/"] = {
            function()
                omega.modules.misc.telescope.api.live_grep()
            end,
            " Live Grep",
        },
        ["h"] = {
            name = " Help",
            t = {
                function()
                    require("telescope.builtin").builtin()
                end,
                "Telescope",
            },
            c = {
                function()
                    require("telescope.builtin").commands()
                end,
                "Commands",
            },
            h = {
                function()
                    omega.modules.misc.telescope.api.help_tags()
                end,
                "Tags",
            },
        },
        ["."] = {
            function()
                omega.modules.misc.telescope.api.file_browser()
            end,
            " File Browser",
        },

        i = {
            e = { "<cmd>Telescope emoji<cr>", "Emoji" },
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
    vim.keymap.set("n", "<c-s>", function()
        omega.modules.misc.telescope.api.buffer_fuzzy()
    end)
end

tele_mod.api = {
    ["colorscheme_switcher"] = function()
        local pickers = require("telescope.pickers")
        local conf = require("telescope.config").values
        local finders = require("telescope.finders")

        local action_state = require("telescope.actions.state")
        local themes = require("telescope.themes")
        local tele_utils = require("telescope.utils")
        local previewers = require("telescope.previewers")
        local utils = require("omega.utils")

        local function base_16_finder(opts)
            opts = opts or {}
            local change_theme = function()
                local entry = action_state.get_selected_entry()
                if entry ~= nil then
                    require("omega.colors").init(entry[1], true)
                    -- require("colorscheme_switcher").new_scheme()
                end
                vim.fn.feedkeys(utils.t("<ESC><ESC>"), "i")
            end

            -- buffer number and name
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            local previewer

            -- in case its not a normal buffer
            if vim.fn.buflisted(bufnr) ~= 1 then
                local deleted = false
                local function del_win(win_id)
                    if win_id and vim.api.nvim_win_is_valid(win_id) then
                        tele_utils.buf_delete(vim.api.nvim_win_get_buf(win_id))
                        pcall(vim.api.nvim_win_close, win_id, true)
                    end
                end

                previewer = previewers.new({
                    preview_fn = function(_, entry, status)
                        if not deleted then
                            deleted = true
                            del_win(status.preview_win)
                            del_win(status.preview_border_win)
                        end
                        require("omega.colors").init(entry.value)
                    end,
                })
            else
                -- show current buffer content in previewer
                previewer = previewers.new_buffer_previewer({
                    define_preview = function(self, entry)
                        local lines = vim.api.nvim_buf_get_lines(
                            bufnr,
                            0,
                            -1,
                            false
                        )
                        vim.api.nvim_buf_set_lines(
                            self.state.bufnr,
                            0,
                            -1,
                            false,
                            lines
                        )
                        local filetype = require("plenary.filetype").detect(
                            bufname
                        ) or "diff"

                        require("telescope.previewers.utils").highlighter(
                            self.state.bufnr,
                            filetype
                        )
                        require("omega.colors").init(entry.value)
                    end,
                })
            end

            pickers.new(opts, {
                prompt_title = "~ Colorscheme Picker ~",
                results_title = "~ Colorschemes ~",
                -- layout_strategy = "custom_bottom",
                finder = finders.new_table(opts.data),
                sorter = conf.generic_sorter(opts),
                previewer = previewer,
                attach_mappings = function(_, map)
                    map("i", "<CR>", change_theme)
                    map("n", "<CR>", change_theme)
                    return true
                end,
            }):find()
        end
        local opts = {
            data = utils.get_themes(),
            layout_config = {
                width = 0.99,
                height = 0.5,
                -- anchor = "S",
                preview_cutoff = 20,
                prompt_position = "top",
            },
        }
        base_16_finder(opts)
    end,
    ["buffer_fuzzy"] = function()
        local opts = {
            shorten_path = false,
            prompt_position = "top",
            prompt_title = "~ Current Buffer ~",
            preview_title = "~ Location Preview~ ",
            results_title = "~ Lines ~",
            -- layout_strategy = "custom_bottom",
            layout_config = { prompt_position = "top", height = 0.4 },
        }
        require("telescope.builtin").current_buffer_fuzzy_find(opts)
    end,
    ["help_tags"] = function()
        vim.cmd([[
            PackerLoad nvim-luaref
            PackerLoad help_files
            PackerLoad luv-vimdocs
        ]])
        local builtin = require("telescope.builtin")
        local opts = {
            prompt_title = "~ Help Tags ~",
            initial_mode = "insert",
            sorting_strategy = "ascending",
            anchor = "S",
            -- layout_strategy = "custom_bottom",
            layout_config = {
                prompt_position = "top",
                preview_width = 0.75,
                width = 0.95,
                height = 0.8,
            },
            preview = {
                preview_cutoff = 120,
                preview_width = 80,
                hide_on_startup = false,
            },
        }
        builtin.help_tags(opts)
    end,
    ["file_browser"] = function()
        require("telescope").load_extension("file_browser")
        local opts

        opts = {
            sorting_strategy = "ascending",
            -- layout_strategy = "custom_bottom",
            scroll_strategy = "cycle",
            prompt_prefix = "  ",
            layout_config = {
                prompt_position = "top",
            },
        }

        require("telescope").extensions.file_browser.file_browser(opts)
    end,
    ["find_files"] = function()
        local opts = {
            prompt_title = "~ Find Files ~",
            preview_title = "~ File Preview ~",
            results_title = "~ Files ~",
            -- layout_strategy = "custom_bottom",
            find_command = {
                "rg",
                "-g",
                "!.git",
                "--files",
                "--hidden",
                "--no-ignore",
            },
            layout_config = {
                prompt_position = "top",
            },
        }
        require("telescope.builtin").find_files(opts)
    end,
    live_grep = function()
        local builtin = require("telescope.builtin")
        local opts = {
            border = true,
            shorten_path = false,
            prompt_title = "~ Find String ~",
            preview_title = "~ Location Preview ~ ",
            -- layout_strategy = "custom_bottom",
            results_title = "~ Occurrences ~",
            disable_coordinates = true,
            layout_config = {
                width = 0.99,
                height = 0.5,
                prompt_position = "top",
            },
            file_ignore_patterns = {
                "vendor/*",
                "node_modules",
                "%.jpg",
                "%.jpeg",
                "%.png",
                "%.svg",
                "%.otf",
                "%.ttf",
            },
            preview = {
                hide_on_startup = false,
            },
        }
        builtin.live_grep(opts)
    end,
}

return tele_mod
