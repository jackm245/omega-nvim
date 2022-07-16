local add_cmd = vim.api.nvim_create_user_command

add_cmd("ReloadColors", function()
    require("colorscheme_switcher").new_scheme()
end, {
    desc = "Reload colors",
})

local function filetypes()
    return {
        "lua",
        "rust",
        "python",
        "c",
        "cpp",
        "java",
        "tex",
        "javascript",
        "typescrip",
        "plain",
        "norg",
    }
end

add_cmd("Tmp", function(args)
    require("omega.extras").scratch_buf(args)
end, {
    nargs = "?",
    complete = filetypes,
    desc = "Open scratch buffer",
})

add_cmd("CursorNodes", function()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    while node do
        vim.pretty_print(node:type())
        node = node:parent()
    end
end, {
    desc = "Print nodes under cursor",
})

local function ShowLangTree(langtree, indent)
    local ts = vim.treesitter
    langtree = langtree or ts.get_parser()
    indent = indent or ""

    print(indent .. langtree:lang())
    for _, region in pairs(langtree:included_regions()) do
        if type(region[1]) == "table" then
            print(indent .. "  " .. vim.inspect(region))
        else
            print(indent .. "  " .. vim.inspect({ region[1]:range() }))
        end
    end
    for lang, child in pairs(langtree._children) do
        ShowLangTree(child, indent .. "  ")
    end
end

add_cmd("LangTree", function()
    ShowLangTree()
end, {
    desc = "Shows language tree",
})

add_cmd("ClearUndo", function()
    local old = vim.opt.undolevels
    vim.opt.undolevels = -1
    vim.cmd([[exe "normal a \<BS>\<Esc>"]])
    vim.opt.undolevels = old
end, {
    desc = "Clear undo history",
})

add_cmd("CodeActions", function()
    local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    local parameters = vim.lsp.util.make_range_params()
    parameters.context = { diagnostics = line_diagnostics }
    local all_responses = vim.lsp.buf_request_sync(0, "textDocument/codeAction", parameters)

    if all_responses == nil or vim.tbl_isempty(all_responses) then
        vim.api.nvim_notify("No code actions available", vim.log.levels.WARN, {})
        return
    end

    local all_code_actions = {}

    for _, client_response in ipairs(all_responses) do
        for _, code_action in ipairs(client_response.result) do
            table.insert(all_code_actions, code_action)
        end
    end
    vim.pretty_print(all_code_actions)
end, {
    desc = "Get Code Actions",
})

add_cmd("ViewColors", function()
    require("omega.colors.extras.color_viewer").view_colors()
end, {
    desc = "View colors",
})
