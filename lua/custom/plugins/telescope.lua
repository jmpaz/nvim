return {
  {
    'debugloop/telescope-undo.nvim',
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    keys = {
      { -- lazy style key map
        '<leader>u',
        '<cmd>Telescope undo<cr>',
        desc = 'undo history',
      },
    },
    opts = {
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = 'vertical',
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension 'undo'
    end,
  },
  {
    'xiyaowong/telescope-emoji.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'emoji'
    end,
  },
  {
    'MaximilianLloyd/adjacent.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'adjacent'
      vim.keymap.set('n', '<leader>sa', '<cmd>Telescope adjacent<CR>', { noremap = true, silent = false, desc = '[S]earch [A]djacent' })
    end,
  },
  {
    'jvgrootveld/telescope-zoxide',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim' },
    config = function()
      require('telescope').load_extension 'zoxide'
      vim.keymap.set('n', '<leader>sz', '<cmd>Telescope zoxide list<CR>', { noremap = true, silent = false, desc = '[S]earch [Z]oxide' })
    end,
  },
  {
    'paopaol/telescope-git-diffs.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'git_diffs'
      vim.keymap.set(
        'n',
        '<leader>gd',
        '<cmd>lua require("telescope").extensions.git_diffs.diff_commits()<CR>',
        { noremap = true, silent = false, desc = '[G]it [D]iffs' }
      )
      vim.keymap.set(
        'n',
        '<leader>gc',
        '<cmd>lua require("telescope").extensions.git_diffs.diff_commits()<CR>',
        { noremap = true, silent = false, desc = '[G]it [C]ommits' }
      )
    end,
  },
}
