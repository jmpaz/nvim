local M = {}

function M.setup()
  local later = MiniDeps.later
  later(function()
    require('mini.basics').setup({
      options = {
        extra_ui = true,
        win_borders = 'double',
      },
    })

    local function generate_basics_clues(prefix, modes)
      local clues = {}
      local options = {
        b = "Toggle 'background'",
        c = "Toggle 'cursorline'",
        C = "Toggle 'cursorcolumn'",
        d = 'Toggle diagnostic',
        h = "Toggle 'hlsearch'",
        i = "Toggle 'ignorecase'",
        l = "Toggle 'list'",
        n = "Toggle 'number'",
        r = "Toggle 'relativenumber'",
        s = "Toggle 'spell'",
        w = "Toggle 'wrap'",
      }
      for _, mode in ipairs(modes) do
        for key, desc in pairs(options) do
          table.insert(clues, { mode = mode, keys = prefix .. key, desc = desc })
        end
      end
      return clues
    end

    local miniclue = require('mini.clue')
    miniclue.setup({
      triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = '<localleader>' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
        { mode = 'n', keys = '\\' },
        { mode = 'x', keys = '\\' },
        { mode = 'n', keys = 'v' },
        { mode = 'x', keys = 'a' },
        { mode = 'x', keys = 'i' },
        { mode = 'o', keys = 'a' },
        { mode = 'o', keys = 'i' },
      },
      clues = {
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
        unpack(generate_basics_clues('\\', { 'n', 'x' })),
        { mode = 'n', keys = '<Leader>s', desc = 'search' },
        { mode = 'n', keys = '<Leader>b', desc = 'buffer' },
        { mode = 'n', keys = '<Leader>t', desc = 'tab' },
        { mode = 'n', keys = '<Leader>d', desc = 'diagnostics' },
        { mode = 'n', keys = '<Leader>f', desc = 'files' },
        { mode = 'n', keys = '<Leader>n', desc = 'notifications' },
        { mode = 'x', keys = 'af', desc = 'around function' },
        { mode = 'x', keys = 'if', desc = 'inside function' },
        { mode = 'o', keys = 'af', desc = 'around function' },
        { mode = 'o', keys = 'if', desc = 'inside function' },
        { mode = 'n', keys = 'vaf', desc = 'select around function' },
        { mode = 'n', keys = 'vif', desc = 'select inside function' },
        { mode = 'x', keys = 'ac', desc = 'around class' },
        { mode = 'x', keys = 'ic', desc = 'inside class' },
        { mode = 'o', keys = 'ac', desc = 'around class' },
        { mode = 'o', keys = 'ic', desc = 'inside class' },
        { mode = 'n', keys = 'vac', desc = 'select around class' },
        { mode = 'n', keys = 'vic', desc = 'select inside class' },
        { mode = 'x', keys = 'a', desc = 'around text object' },
        { mode = 'x', keys = 'i', desc = 'inside text object' },
        { mode = 'o', keys = 'a', desc = 'around text object' },
        { mode = 'o', keys = 'i', desc = 'inside text object' },
        { mode = 'n', keys = 'v', desc = 'select text object' },
      },
      window = {
        delay = 200,
        config = {
          width = 'auto',
          border = 'single',
          anchor = 'SE',
        },
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
    })
  end)
end

return M
