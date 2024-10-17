-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        -- Uncomment next line to use 'stable' branch
        '--branch', 'stable',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- nvim
now(function()
    require('mini.basics').setup()
    vim.g.mapleader = " "
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.laststatus = 2
    vim.o.list = true
    vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
    vim.o.autoindent = true
    vim.o.shiftwidth = 4
    vim.o.tabstop = 4
    vim.o.expandtab = true
    vim.o.scrolloff = 10
    vim.o.updatetime = 1000
    vim.opt.iskeyword:append("-")
    vim.o.path = vim.o.path .. ",**"

    local theme_path = vim.fn.stdpath('config') .. '/lua/theme.lua'
    if vim.loop.fs_stat(theme_path) then
        require('theme')
    end
    vim.o.termguicolors = true
end)


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


now(function()
    -- lsp
    add({
      source = 'neovim/nvim-lspconfig',
      depends = { 'williamboman/mason.nvim' },
    })
end)

-- nvim-treesitter
later(function()
    add({
      source = 'nvim-treesitter/nvim-treesitter',
      checkout = 'master',
      monitor = 'main',
      hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'lua', 'vimdoc' },
      highlight = { enable = true },
    })
end)





