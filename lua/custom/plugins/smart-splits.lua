return {
  {
    'mrjones2014/smart-splits.nvim',
    event = 'VeryLazy',
    -- build = './kitty/install-kittens.bash',
    config = function()
      local smart_splits = require 'smart-splits'
      -- resizing windows
      vim.keymap.set('n', '<C-Left>', smart_splits.resize_left)
      vim.keymap.set('n', '<C-Down>', smart_splits.resize_down)
      vim.keymap.set('n', '<C-Up>', smart_splits.resize_up)
      vim.keymap.set('n', '<C-Right>', smart_splits.resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
      vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
      vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
      vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
      vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous)
      -- swapping buffers between windows
      vim.keymap.set('n', '<C-M-h>', function()
        smart_splits.swap_buf_left { move_cursor = true }
      end)
      vim.keymap.set('n', '<C-M-j>', function()
        smart_splits.swap_buf_down { move_cursor = true }
      end)
      vim.keymap.set('n', '<C-M-k>', function()
        smart_splits.swap_buf_up { move_cursor = true }
      end)
      vim.keymap.set('n', '<C-M-l>', function()
        smart_splits.swap_buf_right { move_cursor = true }
      end)
      smart_splits.setup {}
    end,
  },
}
