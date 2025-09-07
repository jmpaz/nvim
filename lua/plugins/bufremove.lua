local M = {}

local function replace_windows_with_scratch(buf)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      vim.cmd('enew')
      local b = vim.api.nvim_get_current_buf()
      vim.bo[b].buftype, vim.bo[b].bufhidden = 'nofile', 'wipe'
      vim.bo[b].swapfile, vim.bo[b].buflisted = false, false
      vim.api.nvim_buf_set_lines(b, 0, -1, false, { '' })
    end)
  end
end

local function with_scratch(fn, ...)
  local buf = select(1, ...) or 0
  replace_windows_with_scratch(buf)
  local ok, err = pcall(fn, ...)
  if not ok then vim.schedule(function() vim.notify('[bufremove] ' .. tostring(err), vim.log.levels.DEBUG) end) end
end

function M.setup()
  MiniDeps.later(function()
    require('mini.bufremove').setup()
    local map = function(lhs, fn, desc) vim.keymap.set('n', lhs, fn, { noremap = true, silent = true, desc = desc }) end
    map('<Space>bd', function() with_scratch(MiniBufremove.delete, 0) end, 'delete (safe)')
    map('<Space>bu', function() with_scratch(MiniBufremove.unshow, 0) end, 'unshow (safe)')
    map('<Space>bw', function() with_scratch(MiniBufremove.wipeout, 0, true) end, 'wipeout (safe)')
  end)
end

return M
