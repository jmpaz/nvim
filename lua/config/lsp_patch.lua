local M = {}

function M.setup()
  local api = vim.api
  local util = require('vim.lsp.util')
  local orig_show = util.show_document

  util.show_document = function(location, encoding, opts)
    opts = opts or {}
    local focus = opts.focus
    if focus == nil then focus = true end

    local uri = location.uri or location.targetUri
    if focus and uri then
      local buf = vim.uri_to_bufnr(uri)
      local win = vim.fn.win_findbuf(buf)[1]
      if win then
        api.nvim_set_current_win(win)
        return true
      end
    end

    local cur = api.nvim_get_current_buf()
    local restore = false
    if focus and uri and vim.bo[cur].modified and not vim.o.hidden then
      vim.o.hidden = true
      restore = true
    end

    local ok = orig_show(location, encoding, opts)

    if restore then vim.o.hidden = false end

    return ok
  end

  function util.open_document_new_window(location, encoding)
    local ok = orig_show(location, encoding, { focus = false })
    if ok then
      local uri = location.uri or location.targetUri
      if uri then
        local win = vim.fn.win_findbuf(vim.uri_to_bufnr(uri))[1]
        if win then api.nvim_set_current_win(win) end
      end
    end
    return ok
  end

  function M.goto_definition(new_window)
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    local enc = client and client.offset_encoding or 'utf-16'
    local params = util.make_position_params(0, enc)
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx)
      if err or not result then return end
      local loc = vim.islist(result) and result[1] or result
      local c = vim.lsp.get_client_by_id(ctx.client_id)
      local e = c and c.offset_encoding or enc
      if new_window then
        util.open_document_new_window(loc, e)
      else
        util.show_document(loc, e, { reuse_win = true, focus = true })
      end
    end)
  end
end

return M
