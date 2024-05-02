return {
  {
    'mrjones2014/smart-splits.nvim',
    event = 'VeryLazy',
    -- build = './kitty/install-kittens.bash',
    resize_mode = {
      quit_key = '<ESC>',
      resize_keys = { 'h', 'j', 'k', 'l' },
      silent = true,
    },
    config = function()
      local smart_splits = require 'smart-splits'
      -- resizing windows
      vim.keymap.set('n', '<C-w>r', smart_splits.start_resize_mode)
      -- moving between splits
      -- vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
      -- vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
      -- vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
      -- vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
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
  {
    'https://git.sr.ht/~swaits/zellij-nav.nvim',
    lazy = true,
    event = 'VeryLazy',
    keys = {
      { '<c-h>', '<cmd>ZellijNavigateLeft<cr>', { silent = true, desc = 'navigate left' } },
      { '<c-j>', '<cmd>ZellijNavigateDown<cr>', { silent = true, desc = 'navigate down' } },
      { '<c-k>', '<cmd>ZellijNavigateUp<cr>', { silent = true, desc = 'navigate up' } },
      { '<c-l>', '<cmd>ZellijNavigateRight<cr>', { silent = true, desc = 'navigate right' } },
    },
    opts = {},
  },
}
