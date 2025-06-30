local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'xvzc/chezmoi.nvim',
    })

    later(function()
      if pcall(require, 'telescope') then
        pcall(require('telescope').load_extension, 'chezmoi')

      vim.keymap.set(
        'n',
        '<leader>fc',
        function() require('telescope').extensions.chezmoi.find_files() end,
        { noremap = true, silent = true, desc = 'chezmoi' }
      )
      end
    end)
  end)
end

return M
