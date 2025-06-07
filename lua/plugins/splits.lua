local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    vim.keymap.set('n', '<C-w>-', '<C-w>s', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-w>|', '<C-w>v', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-w>m-', '<C-w>t<C-w>K', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-w>m|', '<C-w>t<C-w>H', { noremap = true, silent = true })
  end)

  later(function()
    add({ source = 'mrjones2014/smart-splits.nvim' })

    local smart_splits = require('smart-splits')

    vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous)
    vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
    vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
    vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
    vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)

    vim.keymap.set('n', '<C-M-h>', function() smart_splits.swap_buf_left({ move_cursor = true }) end)
    vim.keymap.set('n', '<C-M-j>', function() smart_splits.swap_buf_down({ move_cursor = true }) end)
    vim.keymap.set('n', '<C-M-k>', function() smart_splits.swap_buf_up({ move_cursor = true }) end)
    vim.keymap.set('n', '<C-M-l>', function() smart_splits.swap_buf_right({ move_cursor = true }) end)

    vim.keymap.set('n', '<C-S-h>', smart_splits.resize_left)
    vim.keymap.set('n', '<C-S-j>', smart_splits.resize_down)
    vim.keymap.set('n', '<C-S-k>', smart_splits.resize_up)
    vim.keymap.set('n', '<C-S-l>', smart_splits.resize_right)

    smart_splits.setup()
  end)
end

return M
