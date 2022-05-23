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
