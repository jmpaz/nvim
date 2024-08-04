return {
  {
    'benlubas/molten-nvim',
    version = '<2.0.0',
    build = ':UpdateRemotePlugins',
    init = function()
      -- molten-nvim keybindings
      local wk = require 'which-key'

      -- Setting global variables for molten
      vim.g.molten_output_win_max_height = 20

      -- Key bindings setup
      vim.keymap.set('n', '<localleader>mki', ':MoltenInit<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mkd', ':MoltenDeinit<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mkr', ':MoltenRestart<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mks', ':MoltenInterrupt<CR>', { silent = true })

      vim.keymap.set('n', '<localleader>mcg', ':MoltenGoto<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mcn', ':MoltenNext<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mcp', ':MoltenPrev<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mcd', ':MoltenDelete<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mcr', ':MoltenReevaluateCell<CR>', { silent = true })

      vim.keymap.set('n', '<localleader>mrl', ':MoltenEvaluateLine<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mro', ':MoltenEvaluateOperator<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mra', ':MoltenEvaluateArgument<CR>', { silent = true })

      vim.keymap.set('n', '<localleader>ms', ':MoltenShowOutput<CR>', { silent = true, desc = 'Show Output' })
      vim.keymap.set('n', '<localleader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = 'Hide Output' })
      vim.keymap.set('n', '<localleader>me', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'Enter Output' })
      vim.keymap.set('n', '<localleader>mos', ':MoltenShowOutput<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>moh', ':MoltenHideOutput<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>moe', ':noautocmd MoltenEnterOutput<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>moo', ':MoltenOpenInBrowser<CR>', { silent = true })

      vim.keymap.set('n', '<localleader>mfs', ':MoltenSave<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mfl', ':MoltenLoad<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mfe', ':MoltenExportOutput<CR>', { silent = true })
      vim.keymap.set('n', '<localleader>mfi', ':MoltenImportOutput<CR>', { silent = true })

      vim.keymap.set('n', '<localleader>mi', ':MoltenInfo<CR>', { silent = true })
      vim.keymap.set('v', '<localleader>m', ':<C-u>MoltenEvaluateVisual<CR>', { silent = true, desc = 'Evaluate selection (Molten)' })

      -- which-key menu definition
      wk.add {
        { '<localleader>m', 'Molten', name = 'Molten' },
        { '<localleader>mk', 'Kernel', name = 'Kernel' },
        { '<localleader>mki', 'Initialize Kernel', name = 'Initialize Kernel' },
        { '<localleader>mkd', 'De-initialize Kernel', name = 'De-initialize Kernel' },
        { '<localleader>mkr', 'Restart Kernel', name = 'Restart Kernel' },
        { '<localleader>mks', 'Interrupt Kernel', name = 'Interrupt Kernel' },
        { '<localleader>mc', 'Cells', name = 'Cells' },
        { '<localleader>mcg', 'Go to Cell', name = 'Go to Cell' },
        { '<localleader>mcn', 'Next Cell', name = 'Next Cell' },
        { '<localleader>mcp', 'Previous Cell', name = 'Previous Cell' },
        { '<localleader>mcd', 'Delete Cell', name = 'Delete Cell' },
        { '<localleader>mcr', 'Re-evaluate Cell', name = 'Re-evaluate Cell' },
        { '<localleader>mr', 'Evaluate', name = 'Evaluate' },
        { '<localleader>mrl', 'Evaluate Line', name = 'Evaluate Line' },
        { '<localleader>mro', 'Evaluate Operator', name = 'Evaluate Operator' },
        { '<localleader>mra', 'Evaluate Argument', name = 'Evaluate Argument' },
        { '<localleader>mo', 'Output', name = 'Output' },
        { '<localleader>mos', 'Show Output Window', name = 'Show Output Window' },
        { '<localleader>moh', 'Hide Output Window', name = 'Hide Output Window' },
        { '<localleader>moe', 'Enter Output Window', name = 'Enter Output Window' },
        { '<localleader>moo', 'Open Output in Browser', name = 'Open Output in Browser' },
        { '<localleader>mf', 'File', name = 'File' },
        { '<localleader>mfs', 'Save Cells', name = 'Save Cells' },
        { '<localleader>mfl', 'Load Cells', name = 'Load Cells' },
        { '<localleader>mfe', 'Export to .ipynb', name = 'Export to .ipynb' },
        { '<localleader>mfi', 'Import from .ipynb', name = 'Import from .ipynb' },
        { '<localleader>mi', 'Info', name = 'Info' },
      }
    end,
  },
}
