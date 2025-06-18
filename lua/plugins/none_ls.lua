local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'nvimtools/none-ls.nvim',
      depends = { 'nvim-lua/plenary.nvim' },
    })

    local null_ls = require('null-ls')
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
      },
      on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormatting', {}),
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ async = false }) end,
          })
        end
      end,
    })

    -- vim.lsp.handlers['$/progress'] = function() end
  end)
end

return M
