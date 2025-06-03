local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'Bekaboo/dropbar.nvim',
      depends = {
        { source = 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
    })

    require('dropbar').setup({
      bar = {
        pick = {
          pivots = 'qwertyuiopasdfghjklzxcvbnm',
        },
      },
      sources = {
        path = { max_depth = 6 },
        lsp = { max_depth = 6 },
        treesitter = { max_depth = 6 },
      },
    })
    local api = require('dropbar.api')

    vim.keymap.set('n', '<leader>;', api.pick, { desc = 'pick symbol' })
    vim.keymap.set('n', '[-', api.goto_context_start, { desc = 'go to context start' })
    vim.keymap.set('n', ']-', api.select_next_context, { desc = 'select next context' })
  end)
end

return M
