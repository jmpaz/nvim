local M = {}

function M.setup()
  local now = MiniDeps.now
  now(function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown', 'md' },
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = ''
      end,
    })
  end)
end

return M
