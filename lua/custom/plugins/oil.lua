return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {},
  init = function()
    vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })

    -- Open preview automatically (via oil.nvim#87)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OilEnter',
      callback = vim.schedule_wrap(function(args)
        local oil = require 'oil'
        if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
          oil.select { preview = true }
        end
      end),
    })
  end,
}
