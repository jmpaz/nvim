local M = {}

function M.setup()
  local now = MiniDeps.now
  now(function()
    require('mini.files').setup({
      options = {
        use_as_default_explorer = true,
      },
      mappings = {
        go_in_plus = 'l',
        go_in = 'L',
        synchronize = '<CR>',
        show_help = '?',
      },
      windows = {
        preview = true,
        width_focus = 40,
        width_preview = 40,
        width_nofocus = 20,
      },
    })

    vim.keymap.set('n', '-', function()
      local file_path = vim.fn.expand('%:p')
      if file_path == '' then file_path = vim.loop.cwd() end
      local dir = file_path
      if vim.fn.isdirectory(file_path) == 0 then dir = vim.fn.fnamemodify(file_path, ':h') end
      require('mini.files').open(dir)
    end)
  end)
end

return M
