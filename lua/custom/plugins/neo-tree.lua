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
    require('neo-tree').setup {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_name = {
            '.git',
          },
        },
      },
    }
  end,
  keys = {
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.fn.getcwd() }
      end,
      desc = 'Neo-tree',
    },
    {
      '<leader>ge',
      function()
        require('neo-tree.command').execute { source = 'git_status', toggle = true }
      end,
      desc = 'Git explorer',
    },
    {
      '<leader>be',
      function()
        require('neo-tree.command').execute { source = 'buffers', toggle = true }
      end,
      desc = 'Buffer explorer',
    },
  },
}
