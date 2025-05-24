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
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.lua',
      callback = function() vim.lsp.buf.format({ async = false }) end,
    })
  end)
end

return M
