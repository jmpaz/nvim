local M = {}

function M.setup()
  local now, add = MiniDeps.now, MiniDeps.add
  now(function()
    add({
      source = 'RedsXDD/neopywal.nvim',
      name = 'neopywal',
    })

    require('neopywal').setup({
      use_wallust = false,
    })
    vim.o.background = 'dark'
    vim.cmd.colorscheme('neopywal')
  end)
end

return M
