return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope.nvim', -- override telescope keys
  },
  keys = {
    { '<leader>gs', '<cmd>FzfLua git_status<CR>', desc = 'Git Status (fzf)' },
    { '<leader>gS', '<cmd>FzfLua git_stash<CR>', desc = 'Git Stash (fzf)' },
    { '<leader>gr', '<cmd>FzfLua git_branches<CR>', desc = 'Git Branch (fzf)' },
    --
    { 'm<C-j>', '<cmd>FzfLua jumps<CR>', desc = '[J]umps (fzf)' },
    { 'm<C-t>', '<cmd>FzfLua tagstack<CR>', desc = '[T]agstack (fzf)' },
    { 'm<C-b>', '<cmd>FzfLua buffers<CR>', desc = '[B]uffers (fzf)' },
    { 'm<C-f>', '<cmd>FzfLua files<CR>', desc = '[F]iles (fzf)' },
    { 'm<C-l>', '<cmd>FzfLua lines<CR>', desc = '[L]ines (fzf)' },
    { 'm<C-h>', '<cmd>FzfLua command_history<CR>', desc = 'Command [h]istory (fzf)' },
    { 'm<C-H>', '<cmd>FzfLua oldfiles<CR>', desc = 'File [H]istory (fzf)' },
    { 'm<C-s>', '<cmd>FzfLua search_history<CR>', desc = '[S]earch History (fzf)' },
    { 'm<C-r>', '<cmd>FzfLua registers<CR>', desc = '[R]egisters (fzf)' },
  },
  opts = {
    keymap = {
      builtin = {
        ['<F1>'] = 'toggle-help',
        ['<F2>'] = 'toggle-fullscreen',
        -- Only valid with the 'builtin' previewer
        ['<F3>'] = 'toggle-preview-wrap',
        ['<F4>'] = 'toggle-preview',
        -- Rotate preview clockwise/counter-clockwise
        ['<F5>'] = 'toggle-preview-ccw',
        ['<F6>'] = 'toggle-preview-cw',

        -- ["<S-left>"] = "preview-page-reset",
        ['<M-f>'] = 'preview-page-down',
        ['<M-b>'] = 'preview-page-up',

        ['<C-M-n>'] = 'half-page-down',
        ['<C-M-p>'] = 'half-page-up',
      },
      fzf = {
        ['ctrl-z'] = 'abort',
        ['ctrl-u'] = 'unix-line-discard',
        ['ctrl-a'] = 'beginning-of-line',
        ['ctrl-e'] = 'end-of-line',
        ['alt-a'] = 'toggle-all',

        -- Only valid with fzf previewers (bat/cat/git/etc)
        ['f3'] = 'toggle-preview-wrap',
        ['f4'] = 'toggle-preview',

        ['alt-f'] = 'preview-page-down',
        ['alt-b'] = 'preview-page-up',

        ['ctrl-alt-n'] = 'half-page-down',
        ['ctrl-alt-p'] = 'half-page-up',
      },
    },
  },
  config = function(_, opts)
    require('fzf-lua').setup(opts)
  end,
}
