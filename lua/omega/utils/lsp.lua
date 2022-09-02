local lsp_utils = {}

function lsp_utils.server_capabilities()
    local active_clients = vim.lsp.get_active_clients()
    local active_client_map = {}

    for index, value in ipairs(active_clients) do
        active_client_map[value.name] = index
    end

    vim.ui.select(vim.tbl_keys(active_client_map), {
        prompt = "Select client:",
        format_item = function(item)
            return "Capabilites for: " .. item
        end,
    }, function(choice)
        vim.pretty_print(
            vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities
        )
    end)
end

function lsp_utils.inlay_hints()
    local ns = vim.api.nvim_create_namespace("inlay hints")
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    vim.lsp.buf_request(
        0,
        "textDocument/inlayHint",
        ---@diagnostic disable-next-line: missing-parameter
        vim.lsp.util.make_given_range_params({ 0, 0 }, { #lines, #lines[#lines] }, 0),
        function(err, res, ctx)
            for _, hint in ipairs(res) do
                vim.pretty_print(hint)
                local text = hint.kind == 1 and hint.label[1].value:sub(2, -1)
                    or hint.label[1].value:sub(1, -2)
                if hint.kind == 1 then
                    text = "<- (" .. text .. ")"
                else
                    text = "(" .. text .. ")"
                end
                vim.api.nvim_buf_set_extmark(
                    0,
                    ns,
                    hint.position.line,
                    hint.position.character,
                    { virt_text = { { text, "Comment" } }, virt_text_pos = "eol" }
                )
            end
        end
    )
end

return lsp_utils
