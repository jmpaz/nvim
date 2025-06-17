local M = {}

function M.setup()
  local later = MiniDeps.later

  later(function()
    local win_config = function()
      local has_statusline = vim.o.laststatus > 0
      local pad_h = vim.o.cmdheight + (has_statusline and 1 or 0) + 1
      return { anchor = 'SE', col = vim.o.columns - 1, row = vim.o.lines - pad_h }
    end

    require('mini.notify').setup({
      lsp_progress = {
        enable = false,
      },
      window = {
        config = win_config,
        max_width_share = 0.5,
      },
    })

    vim.keymap.set('n', '<leader>nc', MiniNotify.clear, { desc = 'clear' })
    vim.keymap.set('n', '<leader>nh', MiniNotify.show_history, { desc = 'history' })

    vim.notify = require('mini.notify').make_notify()
  end)
end

return M
