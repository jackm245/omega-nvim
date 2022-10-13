local inlay_hints = {}

local ns = vim.api.nvim_create_namespace("inlay_hints")
local called_setup = false

function inlay_hints.setup()
    if called_setup then
        return
    end
    called_setup = true
    local theme = require("omega.colors.base16").themes(vim.g.colors_name)

    vim.api.nvim_set_hl(0, "InlayHint", { fg = theme.base03, bg = theme.base01 })
    -- vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    --     callback = function(args)
    --         vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
    --         inlay_hints.display(args.buf)
    --     end,
    -- })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        callback = function(args)
            vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
            inlay_hints.display(args.buf, true)
        end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        callback = function(args)
            vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
        end,
    })
end

function inlay_hints.display(buf, current_line_only)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.lsp.buf_request(
        buf,
        "textDocument/inlayHint",
        vim.lsp.util.make_given_range_params({ 0, 0 }, { #lines, #lines[#lines] }, buf, nil),
        function(err, res, ctx)
            local map = {}
            res = res or {}
            for _, hint in ipairs(res) do
                if type(hint.label) == "string" then
                    hint.label = { { value = hint.label } }
                end
                local text = hint.kind == 1 and hint.label[1].value:sub(2, -1)
                    or hint.label[1].value:sub(1, -2)
                if hint.kind == 1 then
                    text = "<- (" .. text .. ")"
                else
                    text = "(" .. text .. ")"
                end
                if not map[hint.position.line] then
                    map[hint.position.line] = text
                end
            end
            if current_line_only then
                local row = vim.api.nvim_win_get_cursor(0)[1] - 1
                if not map[row] then
                    return
                end
                vim.api.nvim_buf_set_extmark(
                    buf,
                    ns,
                    row,
                    1,
                    { virt_text = { { map[row], "InlayHint" } }, virt_text_pos = "eol" }
                )
                return
            end

            for line, hint in pairs(map) do
                vim.api.nvim_buf_set_extmark(
                    buf,
                    ns,
                    line,
                    1,
                    { virt_text = { { hint, "InlayHint" } }, virt_text_pos = "eol" }
                )
            end
        end
    )
end

return inlay_hints
