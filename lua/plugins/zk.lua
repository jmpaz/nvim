local M = {}

function M.setup()
  local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add
  now(function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown', 'md' },
      callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, noremap = true, silent = true, desc = 'Go to linked note' }
        vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.opt_local.conceallevel = 2
      end,
    })
  end)

  later(function()
    add({
      source = 'zk-org/zk-nvim',
      checkout = 'v0.3.0',
    })

    require('zk').setup({
      picker = 'fzf_lua',
      lsp = {
        auto_attach = {
          enabled = true,
          filetypes = { 'markdown', 'md' },
        },
      },
    })

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
    end

    map('n', '<leader>z', function() end, 'zk')

    map('n', '<leader>zc', function()
      vim.ui.input({ prompt = 'note title: ' }, function(input)
        if input == nil then return end
        vim.cmd(string.format('ZkNew { title = %q }', input))
      end)
    end, 'create new')

    map('v', '<leader>zc', function() end, 'create from selection')
    map('v', '<leader>zct', ":'<,'>ZkNewFromTitleSelection<CR>", 'title')
    map('v', '<leader>zcc', ":'<,'>ZkNewFromContentSelection<CR>", 'content')

    vim.api.nvim_create_user_command('ZkDaily', function()
      local notebook = vim.env.ZK_NOTEBOOK_DIR
      if not notebook or notebook == '' then
        vim.notify('ZK_NOTEBOOK_DIR is not set', vim.log.levels.ERROR)
        return
      end
      require('zk').new({
        notebook_path = notebook,
        dir = 'journal/daily',
      })
    end, { desc = 'Create daily note' })
    map('n', '<leader>zd', '<Cmd>ZkDaily<CR>', 'daily')

    map('n', '<leader>zD', function()
      local nb = vim.env.ZK_NOTEBOOK_DIR or vim.loop.cwd()
      local file = nb .. '/journal/daily/context.yaml'
      vim.cmd('edit ' .. vim.fn.fnameescape(file))
    end, 'daily: ctx')

    map('n', '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", 'open')
    map('n', '<leader>zt', '<Cmd>ZkTags<CR>', 'tags')

    map('n', '<leader>zs', function()
      local query = vim.fn.input('search: ')
      vim.cmd("ZkNotes { sort = { 'modified' }, match = { '" .. query .. "' } }")
    end, 'search')
    map('v', '<leader>zs', ":'<,'>ZkMatch<CR>", 'search')

    map('n', '<leader>zk', '<Cmd>ZkInsertLink<CR>', 'insert link')
    map('v', '<leader>zk', ":'<,'>ZkInsertLinkAtSelection<CR>", 'insert link')

    map('n', '<leader>zl', '<Cmd>ZkLinks<CR>', 'links out')
    map('n', '<leader>zL', '<Cmd>ZkBacklinks<CR>', 'links in (backlinks)')

    map('n', '<leader>zx', '<Cmd>ZkIndex<CR>', 'index')
  end)
end

return M
