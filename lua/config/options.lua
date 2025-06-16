return function()
  vim.g.mapleader = ' '
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.laststatus = 3
  vim.o.list = true
  vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
  vim.o.autoindent = true
  vim.o.scrolloff = 10
  vim.o.updatetime = 1000
  vim.opt.iskeyword:append('-')
  vim.o.path = vim.o.path .. ',**'
  vim.o.termguicolors = true
  vim.o.hidden = false

  vim.o.mouse = 'a'
  vim.o.mousescroll = 'ver:1,hor:4'
  vim.o.mousemoveevent = true

  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
  vim.o.expandtab = true

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown' },
    callback = function()
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.expandtab = true
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'python' },
    callback = function()
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true
    end,
  })
end
