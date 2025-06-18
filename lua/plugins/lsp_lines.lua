local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'git.sr.ht/~whynothugo/lsp_lines.nvim',
    })

    require('lsp_lines').setup()
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = true,
    })

    vim.keymap.set('n', '<Leader>dl', require('lsp_lines').toggle, { desc = 'toggle show inline' })

    vim.keymap.set('n', '<Leader>dk', function()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
      if #diagnostics > 0 then
        vim.diagnostic.open_float()
      else
        print('No diagnostics on current line')
      end
    end, { desc = 'inspect current line' })

    vim.keymap.set('n', '<Leader>dc', function()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
      if #diagnostics > 0 then
        local messages = {}
        for _, diag in ipairs(diagnostics) do
          local msg = diag.code and string.format('%s: %s', diag.code, diag.message) or diag.message
          table.insert(messages, msg)
        end
        local text = table.concat(messages, '\n')
        vim.fn.setreg('+', text)
        print('Copied ' .. #diagnostics .. ' diagnostic(s) to clipboard')
      else
        print('No diagnostics on current line')
      end
    end, { desc = 'copy' })

    vim.keymap.set('n', '<Leader>dC', function()
      local diagnostics = vim.diagnostic.get(0)
      if #diagnostics > 0 then
        table.sort(diagnostics, function(a, b) return a.lnum < b.lnum end)
        local messages = {}
        for _, diag in ipairs(diagnostics) do
          local msg = diag.code and string.format('%s: %s', diag.code, diag.message) or diag.message
          table.insert(messages, string.format('Line %d: %s', diag.lnum + 1, msg))
        end
        local text = table.concat(messages, '\n')
        vim.fn.setreg('+', text)
        print('Copied ' .. #diagnostics .. ' diagnostic(s) to clipboard')
      else
        print('No diagnostics in file')
      end
    end, { desc = 'copy all' })

    -- override vim.deprecate to filter lsp_lines warnings
    local original_deprecate = vim.deprecate
    vim.deprecate = function(name, alternative, version, plugin, backtrace)
      local bt = debug.traceback()
      if bt and bt:match('lsp_lines') then return end
      return original_deprecate(name, alternative, version, plugin, backtrace)
    end
  end)
end

return M
