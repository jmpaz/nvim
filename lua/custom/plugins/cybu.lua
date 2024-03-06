return {
  'ghillb/cybu.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('cybu').setup {
      display_time = 1000,
      position = {
        relative_to = 'win',
        anchor = 'topright',
      },
      style = {
        path = 'relative',
        border = 'rounded',
        separator = ' ',
        prefix = '…',
        padding = 1,
        hide_buffer_id = true,
        devicons = {
          enabled = true,
          colored = true,
        },
      },
      exclude = { -- filetypes
        'qf',
        'help',
      },
    }
    vim.keymap.set('n', 'H', '<Plug>(CybuPrev)')
    vim.keymap.set('n', 'L', '<Plug>(CybuNext)')
  end,
  keys = { 'H', 'L' },
}
