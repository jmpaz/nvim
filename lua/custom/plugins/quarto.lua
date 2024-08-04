return {
  {
    'quarto-dev/quarto-nvim',
    opts = {
      lspFeatures = {
        languages = { 'python', 'bash', 'html', 'lua' },
        chunks = 'all',
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = 'molten',
        never_run = { 'yaml' },
      },
    },
    dependencies = { 'jmbuhr/otter.nvim' },
    init = function()
      local runner = require 'quarto.runner'

      -- bindings
      vim.keymap.set('n', '<C-M-r>', runner.run_cell, { silent = true })
      vim.keymap.set('v', '<C-M-r>', runner.run_range, { silent = true })
      vim.keymap.set('n', '<localleader>rc', runner.run_cell, { silent = true })
      vim.keymap.set('n', '<localleader>ra', runner.run_above, { silent = true })
      vim.keymap.set('n', '<localleader>rA', runner.run_all, { silent = true })
      vim.keymap.set('n', '<localleader>rl', runner.run_line, { silent = true })
      vim.keymap.set('v', '<localleader>r', runner.run_range, { silent = true, desc = 'Evaluate selection (Quarto)' })

      -- which-key
      local wk = require 'which-key'
      wk.add {
        { '<localleader>r', 'Run (Quarto)', name = 'Run (Quarto)' },
        { '<localleader>rA', 'Run All Cells', name = 'Run All Cells' },
        { '<localleader>ra', 'Run Cell + Above', name = 'Run Cell + Above' },
        { '<localleader>rc', 'Run Cell', name = 'Run Cell' },
        { '<localleader>rl', 'Run Line', name = 'Run Line' },
      }
    end,
  },
  {
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
        r = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
      },
    },
  },
}
