local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'xvzc/chezmoi.nvim',
    })

    vim.defer_fn(function()
      pcall(require('telescope').load_extension, 'chezmoi')

      vim.keymap.set(
        'n',
        '<leader>fc',
        function() require('telescope').extensions.chezmoi.find_files() end,
        { noremap = true, silent = true, desc = 'chezmoi' }
      )
    end, 100)
  end)
end

return M
