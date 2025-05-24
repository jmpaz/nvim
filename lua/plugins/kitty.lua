local M = {}

function M.setup()
  local now, add = MiniDeps.now, MiniDeps.add
  now(function()
    add({
      source = 'fladson/vim-kitty',
    })
  end)
end

return M
