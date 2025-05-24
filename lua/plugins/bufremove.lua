local M = {}

function M.setup()
  local later = MiniDeps.later
  later(function()
    require('mini.bufremove').setup()

    vim.keymap.set(
      'n',
      '<Space>bd',
      '<cmd>lua MiniBufremove.delete()<CR>',
      { noremap = true, silent = true, desc = 'delete' }
    )
    vim.keymap.set(
      'n',
      '<Space>bu',
      '<cmd>lua MiniBufremove.unshow()<CR>',
      { noremap = true, silent = true, desc = 'unshow' }
    )
    vim.keymap.set(
      'n',
      '<Space>bw',
      '<cmd>lua MiniBufremove.wipeout()<CR>',
      { noremap = true, silent = true, desc = 'wipeout' }
    )
  end)
end

return M
