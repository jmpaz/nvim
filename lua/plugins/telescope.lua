local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'nvim-telescope/telescope.nvim',
      depends = { 'nvim-lua/plenary.nvim' },
    })

    local telescope = require('telescope.builtin')

    vim.keymap.set(
      'n',
      '<leader>sp',
      telescope.lsp_dynamic_workspace_symbols,
      { noremap = true, silent = true, desc = 'project symbols' }
    )

    vim.keymap.set(
      'n',
      '<leader><leader>',
      telescope.find_files,
      { noremap = true, silent = true, desc = 'find files' }
    )
  end)
end

return M
