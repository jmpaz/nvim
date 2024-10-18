-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    '--branch',
    'stable',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()

  require('mini.icons').setup()
  require('mini.tabline').setup()
  require('mini.statusline').setup()
end)

later(function()
  require('mini.ai').setup()
  require('mini.bracketed').setup()
  require('mini.comment').setup()
  require('mini.cursorword').setup()
  require('mini.files').setup()
  require('mini.pick').setup()
  require('mini.jump2d').setup()
  require('mini.surround').setup()
end)

--
-- nvim
now(function()
  require('mini.basics').setup()
  vim.g.mapleader = ' '
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.laststatus = 2
  vim.o.list = true
  vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
  vim.o.autoindent = true
  vim.o.shiftwidth = 4
  vim.o.tabstop = 4
  vim.o.expandtab = true
  vim.o.scrolloff = 10
  vim.o.updatetime = 1000
  vim.opt.iskeyword:append('-')
  vim.o.path = vim.o.path .. ',**'
  vim.o.termguicolors = true
end)

--
-- colorscheme
now(function()
  add({
    source = 'RedsXDD/neopywal.nvim',
    name = 'neopywal',
  })

  require('neopywal').setup({
    use_wallust = true,
  })
  vim.o.background = 'dark'
  vim.cmd.colorscheme('neopywal')
end)

--
-- terminal integration
later(function()
  if vim.loop.os_uname().sysname == 'Darwin' then
    -- macOS: zellij-nav.nvim
    add({
      source = 'https://git.sr.ht/~swaits/zellij-nav.nvim',
      lazy = true,
      event = 'VeryLazy',
    })

    vim.keymap.set('n', '<m-h>', '<cmd>ZellijNavigateLeft<cr>', { silent = true, desc = 'Navigate Left' })
    vim.keymap.set('n', '<m-j>', '<cmd>ZellijNavigateDown<cr>', { silent = true, desc = 'Navigate Down' })
    vim.keymap.set('n', '<m-k>', '<cmd>ZellijNavigateUp<cr>', { silent = true, desc = 'Navigate Up' })
    vim.keymap.set('n', '<m-l>', '<cmd>ZellijNavigateRight<cr>', { silent = true, desc = 'Navigate Right' })
  else
    -- Linux: vim-tmux-navigator
    add({
      source = 'christoomey/vim-tmux-navigator',
      cmd = {
        'TmuxNavigateLeft',
        'TmuxNavigateDown',
        'TmuxNavigateUp',
        'TmuxNavigateRight',
        'TmuxNavigatePrevious',
      },
    })

    vim.keymap.set('n', '<m-h>', '<cmd>TmuxNavigateLeft<cr>')
    vim.keymap.set('n', '<m-j>', '<cmd>TmuxNavigateDown<cr>')
    vim.keymap.set('n', '<m-k>', '<cmd>TmuxNavigateUp<cr>')
    vim.keymap.set('n', '<m-l>', '<cmd>TmuxNavigateRight<cr>')
    vim.keymap.set('n', '<m-\\>', '<cmd>TmuxNavigatePrevious<cr>')
  end
end)

--
-- splits
later(function()
  vim.keymap.set('n', '<C-w>-', '<C-w>s', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>|', '<C-w>v', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>m-', '<C-w>t<C-w>K', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>m|', '<C-w>t<C-w>H', { noremap = true, silent = true })
end)

later(function()
  add({
    source = 'mrjones2014/smart-splits.nvim',
  })

  -- Set up smart-splits after loading the plugin
  local smart_splits = require('smart-splits')

  vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous)
  vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
  vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
  vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
  vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)

  vim.keymap.set('n', '<C-M-h>', function() smart_splits.swap_buf_left({ move_cursor = true }) end)
  vim.keymap.set('n', '<C-M-j>', function() smart_splits.swap_buf_down({ move_cursor = true }) end)
  vim.keymap.set('n', '<C-M-k>', function() smart_splits.swap_buf_up({ move_cursor = true }) end)
  vim.keymap.set('n', '<C-M-l>', function() smart_splits.swap_buf_right({ move_cursor = true }) end)

  vim.keymap.set('n', '<C-w>r', smart_splits.start_resize_mode)

  smart_splits.setup({
    resize_mode = {
      quit_key = '<ESC>',
      resize_keys = { 'h', 'j', 'k', 'l' },
      silent = true,
    },
  })
end)

--
-- lsp/treesitter/none-ls
now(function()
  -- lsp
  add({
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason.nvim' },
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

later(function()
  add({
    source = 'nvimtools/none-ls.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  })

  local null_ls = require('null-ls')
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua,
    },
  })

  -- format on save
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.lua',
    callback = function() vim.lsp.buf.format({ async = false }) end,
  })
end)

--
-- code completion
later(function()
  add({
    source = 'supermaven-inc/supermaven-nvim',
  })
  require('supermaven-nvim').setup({})
end)
