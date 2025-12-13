return function()
  local function is_tmp_markdown_path(path)
    return path:match('^/tmp/claude%-.*%.md$')
      or path:match('^/tmp/%.tmp.*%.md$')
      or path:match('^/private/tmp/claude%-.*%.md$')
      or path:match('^/private/tmp/%.tmp.*%.md$')
  end

  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWinEnter' }, {
    pattern = {
      '/tmp/claude-*.md',
      '/tmp/.tmp*.md',
      '/private/tmp/claude-*.md',
      '/private/tmp/.tmp*.md',
    },
    callback = function(ev)
      local bufnr = ev.buf or 0
      vim.opt_local.wrap = true

      if vim.bo[bufnr].filetype == '' then
        vim.bo[bufnr].filetype = 'markdown'
      end

      local path = vim.api.nvim_buf_get_name(bufnr)
      if path ~= '' and vim.fn.filereadable(path) == 0 then
        pcall(vim.fn.writefile, {}, path, 'a')
      end

      if path ~= '' then
        local dir = vim.fn.fnamemodify(path, ':h')
        if dir ~= '' then
          pcall(vim.cmd, 'silent! lcd ' .. vim.fn.fnameescape(dir))
        end
      end

      vim.b[bufnr].neocodeium_enabled = true
    end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function(ev)
      local bufnr = ev.buf or 0
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path == '' or not is_tmp_markdown_path(path) then
        return
      end

      local ok_state, state = pcall(require, 'neocodeium.state')
      if not ok_state then
        return
      end

      vim.b[bufnr].neocodeium_enabled = true
      vim.b[bufnr].neocodeium_allowed_encoding = true

      local STATUS = require('neocodeium.enums').STATUS
      if state:get_status(bufnr) ~= STATUS.enabled then
        return
      end

      state.active = true
      require('neocodeium.completer'):initiate(true)
    end,
  })
end
