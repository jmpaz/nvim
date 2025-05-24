local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'smjonas/inc-rename.nvim',
    })

    require('inc_rename').setup({
      show_message = true,
      save_in_cmdline_history = false,
    })

    vim.keymap.set(
      'n',
      '<localleader>r',
      function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
      { expr = true, desc = 'inc. rename' }
    )
    vim.o.inccommand = 'split'
  end)
end

return M
