local ca_available = {}

local old_line

local function place_sign(line, buf)
    vim.fn.sign_place(line, "ca_available", "code_action", buf, { lnum = line + 1 })
end

local function remove_sign(line, buf)
    vim.fn.sign_unplace("ca_available", { id = line, buffer = buf })
end

local function update_sign(bufnr)
    local params = vim.lsp.util.make_range_params()
    local line = params.range.start.line
    local context = { diagnostics = vim.diagnostic.get(bufnr, { lnum = line }) }
    params.context = context
    vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(results)
        if old_line then
            remove_sign(old_line, bufnr)
        end
        if vim.tbl_isempty(results[1]) then
            return
        end
        old_line = line
        place_sign(line, bufnr)
    end)
end

function ca_available.setup(bufnr)
    local augroup = vim.api.nvim_create_augroup("CodeAction_available", {})
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function(args)
            update_sign(args.buf)
        end,
        buffer = bufnr,
        group = augroup,
    })
    vim.fn.sign_define(
        "code_action",
        { text = " ", texthl = "TSField", linehl = "", numhl = "" }
    )
end

return ca_available
