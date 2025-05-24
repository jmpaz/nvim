local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'supermaven-inc/supermaven-nvim',
    })
    require('supermaven-nvim').setup({})
  end)
end

return M
