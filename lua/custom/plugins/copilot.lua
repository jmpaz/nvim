return {
  {
    'zbirenbaum/copilot.lua',
    -- cmd = 'Copilot',
    -- build = ':Copilot auth',
    opts = {
      suggestion = { enabled = false },
      panel = {
        enabled = true,
        layout = {
          position = 'bottom',
          ratio = 0.3,
        },
        keymap = {
          -- open = "<C-o>",
          accept = '<CR>',
          refresh = 'gr',
          jump_prev = '=-',
          jump_next = '-=',
        },
      },
      filetypes = {
        ['*'] = true,
        markdown = true,
        yaml = true,
        json = true,
        help = true,
      },
    },
    init = function()
      vim.keymap.set('n', '<C-p>', ':Copilot panel<CR>', { silent = true })
      vim.keymap.set('i', '<C-p>', '<esc>:Copilot panel<CR>', { silent = true })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {}
    end,
  },
}
