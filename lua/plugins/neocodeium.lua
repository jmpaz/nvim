local M = {}

function M.setup()
  local later, add = MiniDeps.later, MiniDeps.add
  later(function()
    add({
      source = 'monkoose/neocodeium',
    })

    local neocodeium = require('neocodeium')
    local ok_blink, blink = pcall(require, 'blink.cmp')

    local function is_tmp_markdown(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      return name:match('^/tmp/claude%-.*%.md$')
        or name:match('^/tmp/%.tmp.*%.md$')
        or name:match('^/private/tmp/claude%-.*%.md$')
        or name:match('^/private/tmp/%.tmp.*%.md$')
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function()
        if ok_blink then
          neocodeium.clear()
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      callback = function()
        if vim.api.nvim_get_mode().mode:sub(1, 1) ~= 'i' then
          return
        end

        local state = require('neocodeium.state')
        local STATUS = require('neocodeium.enums').STATUS
        if state:get_status() ~= STATUS.enabled then
          return
        end

        state.active = true
        require('neocodeium.completer'):initiate(true)
      end,
    })

    neocodeium.setup({
      filter = function(bufnr)
        if is_tmp_markdown(bufnr or 0) then
          return true
        end

        return not (ok_blink and blink.is_visible())
      end,
      show_label = true,
      silent = true,
      filetypes = {
        ['.'] = true,
      },
    })

    vim.schedule(function()
      if vim.api.nvim_get_mode().mode:sub(1, 1) ~= 'i' then
        return
      end

      local state = require('neocodeium.state')
      local STATUS = require('neocodeium.enums').STATUS
      if state:get_status() ~= STATUS.enabled then
        return
      end

      state.active = true
      require('neocodeium.completer'):initiate(true)
    end)

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
