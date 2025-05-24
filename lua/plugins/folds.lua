local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'kevinhwang91/nvim-ufo',
      depends = { 'kevinhwang91/promise-async' },
    })

    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.opt.fillchars = {
      eob = ' ',
      fold = ' ',
      foldsep = ' ',
      foldopen = '▾',
      foldclose = '▸',
    }
    vim.cmd('highlight! link Folded Comment')

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local fold_icon = vim.opt.fillchars:get().foldclose or '▸'
      local line = vim.fn.getline(lnum)
      line = line:gsub('\t', string.rep(' ', vim.o.tabstop))
      local count = endLnum - lnum + 1
      local suffix = string.format(' ... [%d]', count)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      local newVirtText = {}
      table.insert(newVirtText, { fold_icon .. ' ', 'Normal' })
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
          curWidth = curWidth + chunkWidth
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          table.insert(newVirtText, { chunkText, chunk[2] })
          break
        end
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    require('ufo').setup({
      provider_selector = function() return { 'lsp', 'indent' } end,
      fold_virt_text_handler = handler,
    })

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
    vim.keymap.set('n', 'zm', function() require('ufo').closeFoldsWith(1) end, { desc = 'Close folds with level 1' })

    vim.keymap.set('n', 'K', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then vim.lsp.buf.hover() end
    end, { desc = 'Hover or peek fold' })
  end)
end

return M
