local M = {}

function M.setup()
  local later = MiniDeps.later
  later(function()
    local window_config = function()
      local height = math.max(math.floor(0.7 * 0.618 * vim.o.lines), 10)
      local width = math.max(math.floor(0.9 * 0.4 * vim.o.columns), 40)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        border = 'double',
        row = math.floor(0.2 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end

    require('mini.pick').setup({
      mappings = { choose_in_vsplit = '<C-CR>' },
      options = { use_cache = true },
      window = { config = window_config },
    })
    vim.ui.select = MiniPick.ui_select

    vim.keymap.set(
      'n',
      '<Space>sg',
      function() require('telescope.builtin').live_grep() end,
      { noremap = true, silent = true, desc = 'grep (telescope)' }
    )
    vim.keymap.set(
      'n',
      '<Space>sc',
      function() vim.cmd('Pick resume') end,
      { noremap = true, silent = true, desc = 'continue' }
    )
    vim.keymap.set(
      'n',
      '<Space>sh',
      function() vim.cmd('Pick help') end,
      { noremap = true, silent = true, desc = 'help' }
    )
  end)
end

return M
