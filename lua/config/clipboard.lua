return function()
  local is_ssh = vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT
  if not is_ssh then return end

  local has_osc52, osc52 = pcall(require, 'vim.ui.clipboard.osc52')
  if not has_osc52 then return end

  local has = function(cmd) return vim.fn.executable(cmd) == 1 end

  local fallback = nil
  if vim.fn.has('mac') == 1 and has('pbcopy') and has('pbpaste') then
    fallback = {
      name = 'pbcopy',
      copy = { ['+'] = { 'pbcopy' }, ['*'] = { 'pbcopy' } },
      paste = { ['+'] = { 'pbpaste' }, ['*'] = { 'pbpaste' } },
    }
  elseif vim.env.WAYLAND_DISPLAY and has('wl-copy') and has('wl-paste') then
    fallback = {
      name = 'wl-copy',
      copy = {
        ['+'] = { 'wl-copy', '--type', 'text/plain' },
        ['*'] = { 'wl-copy', '--primary', '--type', 'text/plain' },
      },
      paste = {
        ['+'] = { 'wl-paste', '--no-newline' },
        ['*'] = { 'wl-paste', '--no-newline', '--primary' },
      },
    }
  elseif vim.env.DISPLAY and has('xclip') then
    fallback = {
      name = 'xclip',
      copy = {
        ['+'] = { 'xclip', '-quiet', '-i', '-selection', 'clipboard' },
        ['*'] = { 'xclip', '-quiet', '-i', '-selection', 'primary' },
      },
      paste = {
        ['+'] = { 'xclip', '-o', '-selection', 'clipboard' },
        ['*'] = { 'xclip', '-o', '-selection', 'primary' },
      },
    }
  elseif vim.env.DISPLAY and has('xsel') then
    fallback = {
      name = 'xsel',
      copy = {
        ['+'] = { 'xsel', '-i', '-b' },
        ['*'] = { 'xsel', '-i', '-p' },
      },
      paste = {
        ['+'] = { 'xsel', '-o', '-b' },
        ['*'] = { 'xsel', '-o', '-p' },
      },
    }
  elseif vim.env.TMUX and has('tmux') then
    fallback = {
      name = 'tmux',
      copy = { ['+'] = { 'tmux', 'load-buffer', '-' }, ['*'] = { 'tmux', 'load-buffer', '-' } },
      paste = { ['+'] = { 'tmux', 'save-buffer', '-' }, ['*'] = { 'tmux', 'save-buffer', '-' } },
    }
  end

  local function copy(reg)
    local osc52_copy = osc52.copy(reg)
    local fallback_copy = fallback and fallback.copy[reg]
    return function(lines, regtype)
      pcall(osc52_copy, lines, regtype)
      if fallback_copy then pcall(vim.fn.system, fallback_copy, lines) end
    end
  end

  local function paste(reg)
    local osc52_paste = osc52.paste(reg)
    local fallback_paste = fallback and fallback.paste[reg]
    return function()
      if fallback_paste then
        local ok, out = pcall(vim.fn.systemlist, fallback_paste)
        if ok and vim.v.shell_error == 0 then return out end
      end

      local ok, out = pcall(osc52_paste)
      if ok then return out end
      return {}
    end
  end

  vim.g.clipboard = {
    name = fallback and ('osc52+' .. fallback.name) or 'osc52',
    copy = { ['+'] = copy('+'), ['*'] = copy('*') },
    paste = { ['+'] = paste('+'), ['*'] = paste('*') },
    cache_enabled = 0,
  }
end
