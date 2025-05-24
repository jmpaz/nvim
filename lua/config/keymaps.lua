return function()
  local now, later = MiniDeps.now, MiniDeps.later

  now(function()
    vim.keymap.set('n', ',', '<Nop>', { noremap = true, buffer = false })
    vim.g.maplocalleader = ','

    vim.keymap.set('n', '<BS>', 'b', { noremap = true, desc = 'back one word' })
    vim.keymap.set('n', '<S-BS>', 'B', { noremap = true, desc = 'back one WORD' })

    vim.keymap.set('n', '<localleader>w', ':w<CR>', { noremap = true, silent = true, desc = 'write' })
    vim.keymap.set(
      'n',
      '<localleader><M-w>',
      ':noautocmd w<CR>',
      { noremap = true, silent = true, desc = 'write (skip format)' }
    )

    vim.keymap.set('n', '<localleader>q', ':q<CR>', { noremap = true, silent = true, desc = 'quit' })
    vim.keymap.set(
      'n',
      '<localleader><C-q>',
      ':q!<CR>',
      { noremap = true, silent = true, desc = 'quit without saving' }
    )
    vim.keymap.set('n', '<localleader><M-q>', ':qa<CR>', { noremap = true, silent = true, desc = 'quit all' })
    vim.keymap.set('n', '<localleader><S-q>', ':wq<CR>', { noremap = true, silent = true, desc = 'write + quit' })

    vim.keymap.set(
      'n',
      '<localleader><C-M-q>',
      ':qa!<CR>',
      { noremap = true, silent = true, desc = 'quit all without saving' }
    )
    vim.keymap.set(
      'n',
      '<localleader><S-M-q>',
      ':wqa<CR>',
      { noremap = true, silent = true, desc = 'write + quit all' }
    )

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      callback = function() vim.cmd('redraw') end,
    })

    vim.keymap.set('n', '\\H', function()
      if vim.g.minitrailspace_disable then
        vim.g.minitrailspace_disable = false
        require('mini.trailspace').highlight()
      else
        vim.g.minitrailspace_disable = true
        require('mini.trailspace').unhighlight()
      end
    end, { desc = 'Toggle trailing whitespace highlight' })
  end)

  later(function()
    vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'previous' })
    vim.keymap.set('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true, desc = 'next' })

    vim.keymap.set('n', '<Space>tn', ':tabnext<CR>', { noremap = true, silent = true, desc = 'next' })
    vim.keymap.set('n', '<Space>tp', ':tabprevious<CR>', { noremap = true, silent = true, desc = 'prev' })
    vim.keymap.set('n', '<Space>tc', ':tabnew<CR>', { noremap = true, silent = true, desc = 'create' })
    vim.keymap.set('n', '<Space>tx', ':tabclose<CR>', { noremap = true, silent = true, desc = 'close' })

    vim.keymap.set('n', '<Space>tH', ':tabmove -1<CR>', { noremap = true, silent = true, desc = 'move left' })
    vim.keymap.set('n', '<Space>tL', ':tabmove +1<CR>', { noremap = true, silent = true, desc = 'move right' })
    vim.keymap.set('n', '<Space>t1', '1gt', { noremap = true, silent = true, desc = 'goto 1' })
    vim.keymap.set('n', '<Space>t2', '2gt', { noremap = true, silent = true, desc = 'goto 2' })
    vim.keymap.set('n', '<Space>t3', '3gt', { noremap = true, silent = true, desc = 'goto 3' })
    vim.keymap.set('n', '<Space>t4', '4gt', { noremap = true, silent = true, desc = 'goto 4' })
    vim.keymap.set('n', '<Space>t5', '5gt', { noremap = true, silent = true, desc = 'goto 5' })
    vim.keymap.set('n', '<Space>tl', 'g$', { noremap = true, silent = true, desc = 'last' })
    vim.keymap.set('n', '<Space>tf', ':tabfirst<CR>', { noremap = true, silent = true, desc = 'first' })
  end)
end
