local M = {}

function M.setup()
  local now, add = MiniDeps.now, MiniDeps.add
  now(function()
    add({
      source = 'imsnif/kdl.vim',
    })
  end)
end

return M
