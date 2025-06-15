local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'monkoose/neocodeium',
    })

    local neocodeium = require('neocodeium')
    local blink = require('blink.cmp')

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function() neocodeium.clear() end,
    })

    neocodeium.setup({
      filter = function() return not blink.is_visible() end,
      show_label = true,
      silent = true,
      filetypes = {},
    })

    vim.keymap.set('i', '<A-CR>', neocodeium.accept)

    vim.keymap.set('i', '<A-w>', neocodeium.accept_word)
    vim.keymap.set('i', '<A-e>', neocodeium.accept_line)

    vim.keymap.set('i', '<A-r>', function() neocodeium.cycle_or_complete() end)
    vim.keymap.set('i', '<A-t>', function() neocodeium.cycle_or_complete(-1) end)

    vim.keymap.set('i', '<A-c>', neocodeium.clear)

    vim.keymap.set('i', '<Tab>', function()
      if neocodeium.visible() then
        neocodeium.accept()
      else
        return '<Tab>'
      end
    end, { expr = true })
  end)
end

return M
