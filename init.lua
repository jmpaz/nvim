-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
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

require('config.options')()
require('config.keymaps')()
require('config.lsp_patch').setup()

now(function()
  require('mini.starter').setup({ footer = '' })
  require('mini.icons').setup()
  require('mini.tabline').setup()
  require('mini.statusline').setup()
end)

later(function()
  require('mini.ai').setup()
  require('mini.bracketed').setup()
  require('mini.comment').setup()
  require('mini.indentscope').setup()
  require('mini.cursorword').setup()
  require('mini.map').setup()
  require('mini.git').setup()
  require('mini.diff').setup()
  require('mini.pick').setup()
  require('mini.jump2d').setup()
  require('mini.surround').setup()
  require('mini.trailspace').setup()
  require('mini.hipatterns').setup()
  require('mini.operators').setup()
end)

-- Load all plugins
for name, type in vim.fs.dir('/home/josh/.config/nvim/lua/plugins') do
  if type == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
    local module = name:gsub('%.lua$', '')
    require('plugins.' .. module).setup()
  end
end
