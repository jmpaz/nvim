local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'fasterius/simple-zoom.nvim',
    })

    require('simple-zoom').setup({
      hide_tabline = false,
    })

    vim.keymap.set(
      'n',
      'z ',
      require('simple-zoom').toggle_zoom,
      { noremap = true, silent = true, desc = 'Toggle zoom' }
    )
  end)
end

return M
