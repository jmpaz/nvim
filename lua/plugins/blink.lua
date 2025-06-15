local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'Saghen/blink.cmp',
    })
    require('blink.cmp').setup({
      fuzzy = { implementation = 'lua' },
      sources = {
        default = { 'lsp', 'path', 'buffer' },
      },
      completion = {
        menu = {
          auto_show = function(ctx) return ctx.mode ~= 'default' end,
        },
      },
      keymap = {
        preset = 'default',
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      },
      cmdline = {
        keymap = {
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
        },
      },
    })
  end)
end

return M
