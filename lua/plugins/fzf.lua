local M = {}

function M.setup()
  local now, add = MiniDeps.now, MiniDeps.add
  now(function()
    add({
      source = 'ibhagwan/fzf-lua',
    })
    require('fzf-lua').setup()
  end)
end

return M
