local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'bassamsdata/namu.nvim',
    })

    require('namu').setup({
      namu_symbols = {
        enable = true,
        options = {
          actions = {
            close_on_yank = true,
          },
        },
      },
      ui_select = { enable = true },
    })

    vim.keymap.set('n', '<leader>so', require('namu.namu_symbols').show, {
      desc = 'local symbols',
      silent = true,
    })
  end)
end

return M
