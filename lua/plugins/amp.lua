local M = {}

function M.setup()
  local now, add = MiniDeps.now, MiniDeps.add
  now(function()
    add({
      source = 'sourcegraph/amp.nvim',
    })

    require('amp').setup({
      auto_start = true,
      log_level = 'info',
    })

    vim.api.nvim_create_user_command('AmpSend', function(opts)
      local message = opts.args
      if message == '' then
        print('Please provide a message to send')
        return
      end

      local amp_message = require('amp.message')
      amp_message.send_message(message)
    end, {
      nargs = '*',
      desc = 'Send a message to Amp',
    })

    vim.api.nvim_create_user_command('AmpSendBuffer', function()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local content = table.concat(lines, '\n')

      local amp_message = require('amp.message')
      amp_message.send_message(content)
    end, {
      nargs = '?',
      desc = 'Send current buffer contents to Amp',
    })

    vim.api.nvim_create_user_command('AmpPromptSelection', function(opts)
      local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
      local text = table.concat(lines, '\n')

      local amp_message = require('amp.message')
      amp_message.send_to_prompt(text)
    end, {
      range = true,
      desc = 'Add selected text to Amp prompt',
    })

    vim.api.nvim_create_user_command('AmpPromptRef', function(opts)
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == '' then
        print('Current buffer has no filename')
        return
      end

      local relative_path = vim.fn.fnamemodify(bufname, ':.')
      local ref = '@' .. relative_path
      if opts.line1 ~= opts.line2 then
        ref = ref .. '#L' .. opts.line1 .. '-' .. opts.line2
      elseif opts.line1 > 1 then
        ref = ref .. '#L' .. opts.line1
      end

      local amp_message = require('amp.message')
      amp_message.send_to_prompt(ref)
    end, {
      range = true,
      desc = 'Add file reference (with selection) to Amp prompt',
    })

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
    end

    map('n', '<leader>a', function() end, 'amp')

    map('n', '<leader>as', function()
      vim.ui.input({ prompt = 'amp: ' }, function(input)
        if input == nil or input == '' then return end
        require('amp.message').send_message(input)
      end)
    end, 'send message')

    map('n', '<leader>ab', '<Cmd>AmpSendBuffer<CR>', 'send buffer')

    map('v', '<leader>ap', ":'<,'>AmpPromptSelection<CR>", 'prompt selection')

    map('n', '<leader>ar', '<Cmd>AmpPromptRef<CR>', 'prompt ref')
    map('v', '<leader>ar', ":'<,'>AmpPromptRef<CR>", 'prompt ref')
  end)
end

return M
