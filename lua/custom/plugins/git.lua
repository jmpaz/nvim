return {
  { 'sindrets/diffview.nvim' },
  {
    'ruifm/gitlinker.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitlinker').setup()
      vim.api.nvim_set_keymap('n', '<leader>gy', '<cmd>lua require"gitlinker".get_buf_range_url("n", {})<cr>', { desc = 'Get permalink' })
      vim.api.nvim_set_keymap('v', '<localleader>g', '<cmd>lua require"gitlinker".get_buf_range_url("v", {})<cr>', { desc = 'Get permalink' })
      vim.api.nvim_set_keymap('n', '<leader>gY', '<cmd>lua require"gitlinker".get_repo_url()<cr>', { silent = true, desc = 'Copy project URL' })
      vim.api.nvim_set_keymap(
        'n',
        '<leader>gB',
        '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { silent = true, desc = 'Open in browser' }
      )
    end,
  },
  {
    'NeogitOrg/neogit',
    lazy = true,
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', ':Neogit<cr>', desc = 'neo[g]it' },
    },
    config = function()
      require('neogit').setup {
        disable_commit_confirmation = true,
        integrations = {
          diffview = true,
        },
      }
    end,
  },
}
