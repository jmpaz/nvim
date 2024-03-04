vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {}
    vim.keymap.set('n', '<C-\\>', ':Neotree toggle<CR>', { silent = true })
  end,
  keys = {
    {
      -- '<leader>fe',
      '<leader>e',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.fn.getcwd() }
      end,
      desc = 'Neo-tree',
    },
    -- { '<leader>e', '<leader>fe', desc = 'Neo-tree', remap = true },
    -- {
    --   '<leader>ge',
    --   function()
    --     require('neo-tree.command').execute { source = 'git_status', toggle = true }
    --   end,
    --   desc = 'Git explorer',
    -- },
    -- {
    --   '<leader>be',
    --   function()
    --     require('neo-tree.command').execute { source = 'buffers', toggle = true }
    --   end,
    --   desc = 'Buffer explorer',
    -- },
  },
}
