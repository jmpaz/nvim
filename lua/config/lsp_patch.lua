local M = {}

do
  local api, fn = vim.api, vim.fn
  local util = require('vim.lsp.util')
  local orig_show = util.show_document

  local function show(location, encoding, opts)
    opts = opts or {}
    local focus = opts.focus ~= false
    local uri = location.uri or location.targetUri

    if focus and uri then
      local buf = vim.uri_to_bufnr(uri)
      local wins = fn.win_findbuf(buf)
      if #wins > 0 then
        pcall(api.nvim_set_current_win, wins[1])
        return true
      end
    end

    local cur = api.nvim_get_current_buf()
    local flip = focus and uri and vim.bo[cur].modified and not vim.o.hidden
    if flip then vim.o.hidden = true end

    local ok, res = pcall(orig_show, location, encoding, opts)
    if flip then vim.o.hidden = false end
    return ok and res or false
  end

  function M.open_document_new_window(location, encoding)
    return show(location, encoding, { focus = false, reuse_win = false })
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
        M.open_document_new_window(loc, e)
      else
        show(loc, e, { reuse_win = true, focus = true })
      end
    end)
  end

  function M.setup() end
end

return M
