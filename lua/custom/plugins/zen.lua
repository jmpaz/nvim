return {
  {
    'folke/zen-mode.nvim',
    opts = {},
    config = function()
      vim.keymap.set('n', '\\z', ':ZenMode<CR>', { silent = true })
    end,
  },
  {
    'folke/twilight.nvim',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function()
      -- backslash menu -> t to toggle
      vim.keymap.set('n', '\\t', ':Twilight<CR>', { silent = true })
    end,
  },
}
