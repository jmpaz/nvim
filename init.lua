-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch',
    'stable',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()

  require('mini.icons').setup()
  require('mini.tabline').setup()
  require('mini.statusline').setup()
end)

later(function()
  require('mini.ai').setup()
  require('mini.bracketed').setup()
  require('mini.comment').setup()
  require('mini.completion').setup()
  require('mini.indentscope').setup()
  require('mini.cursorword').setup()
  require('mini.map').setup()
  require('mini.git').setup()
  require('mini.diff').setup()
  require('mini.pick').setup()
  require('mini.jump2d').setup()
  require('mini.surround').setup()
  require('mini.trailspace').setup()
end)

--
-- files
now(function()
  require('mini.files').setup({
    options = {
      use_as_default_explorer = true,
    },
  })

  vim.keymap.set('n', '-', function() require('mini.files').open() end)
end)

--
-- move
later(
  function()
    require('mini.move').setup({
      mappings = {
        left = '<S-Left>',
        right = '<S-Right>',
        down = '<S-Down>',
        up = '<S-Up>',

        line_left = '<S-Left>',
        line_right = '<S-Right>',
        line_down = '<S-Down>',
        line_up = '<S-Up>',
      },
    })
  end
)

-- file picker
later(function()
  local window_config = function()
    local height = math.max(math.floor(0.7 * 0.618 * vim.o.lines), 10)
    local width = math.max(math.floor(0.9 * 0.4 * vim.o.columns), 40)
    return {
      anchor = 'NW',
      height = height,
      width = width,
      border = 'double',
      -- Adjust the row to position the window higher up on the screen
      row = math.floor(0.2 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end

  require('mini.pick').setup({
    mappings = {
      choose_in_vsplit = '<C-CR>',
    },
    options = {
      use_cache = true,
    },
    window = {
      config = window_config,
    },
  })
  vim.ui.select = MiniPick.ui_select

  vim.keymap.set(
    'n',
    '<Space><Space>',
    function() vim.cmd('Pick files') end,
    { noremap = true, silent = true, desc = 'project search' }
  )
  vim.keymap.set(
    'n',
    '<Space><S-Space>',
    function() vim.cmd('Pick buffers') end,
    { noremap = true, silent = true, desc = 'open buffers' }
  )
  vim.keymap.set(
    'n',
    '<Space>sg',
    function() vim.cmd('Pick grep_live') end,
    { noremap = true, silent = true, desc = 'grep' }
  )
  vim.keymap.set(
    'n',
    '<Space>sc',
    function() vim.cmd('Pick resume') end,
    { noremap = true, silent = true, desc = 'continue' }
  )
  vim.keymap.set(
    'n',
    '<Space>sh',
    function() vim.cmd('Pick help') end,
    { noremap = true, silent = true, desc = 'help' }
  )
end)

--
-- basics, key hints
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
      -- leader
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },

      -- basics
      { mode = 'n', keys = '\\' },
      { mode = 'x', keys = '\\' },
    },

    clues = {
      -- built-ins
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),

      -- custom
      unpack(generate_basics_clues('\\', { 'n', 'x' })),

      -- Group-level clues
      { mode = 'n', keys = '<Leader>s', desc = 'search' },
      { mode = 'n', keys = '<Leader>b', desc = 'buffer' },
      { mode = 'n', keys = '<Leader>t', desc = 'tab' },
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

--
-- nvim
now(function()
  vim.g.mapleader = ' '
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.laststatus = 2
  vim.o.list = true
  vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
  vim.o.autoindent = true
  vim.o.shiftwidth = 4
  vim.o.tabstop = 4
  vim.o.expandtab = true
  vim.o.scrolloff = 10
  vim.o.updatetime = 1000
  vim.opt.iskeyword:append('-')
  vim.o.path = vim.o.path .. ',**'
  vim.o.termguicolors = true
end)

--
-- colorscheme
now(function()
  add({
    source = 'RedsXDD/neopywal.nvim',
    name = 'neopywal',
  })

  require('neopywal').setup({
    use_wallust = true,
  })
  vim.o.background = 'dark'
  vim.cmd.colorscheme('neopywal')
end)

--
-- splits
later(function()
  vim.keymap.set('n', '<C-w>-', '<C-w>s', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>|', '<C-w>v', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>m-', '<C-w>t<C-w>K', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-w>m|', '<C-w>t<C-w>H', { noremap = true, silent = true })
end)

later(function()
  add({
    source = 'mrjones2014/smart-splits.nvim',
  })

  -- Set up smart-splits after loading the plugin
  local smart_splits = require('smart-splits')

  vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous)
  vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
  vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
  vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
  vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)

  vim.keymap.set('n', '<C-M-h>', function() smart_splits.swap_buf_left({ move_cursor = true }) end)
  vim.keymap.set('n', '<C-M-j>', function() smart_splits.swap_buf_down({ move_cursor = true }) end)
  vim.keymap.set('n', '<C-M-k>', function() smart_splits.swap_buf_up({ move_cursor = true }) end)
  vim.keymap.set('n', '<C-M-l>', function() smart_splits.swap_buf_right({ move_cursor = true }) end)

  vim.keymap.set('n', '<C-w>r', smart_splits.start_resize_mode)

  smart_splits.setup({
    resize_mode = {
      quit_key = '<ESC>',
      resize_keys = { 'h', 'j', 'k', 'l' },
      silent = true,
    },
  })
end)

--
-- tabs
later(function()
  -- Move between buffers
  vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'previous' })
  vim.keymap.set('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true, desc = 'next' })

  -- Leader key bindings for tab management
  vim.keymap.set('n', '<Space>tn', ':tabnext<CR>', { noremap = true, silent = true, desc = 'next' })
  vim.keymap.set('n', '<Space>tp', ':tabprevious<CR>', { noremap = true, silent = true, desc = 'prev' })
  vim.keymap.set('n', '<Space>tc', ':tabnew<CR>', { noremap = true, silent = true, desc = 'create' })
  vim.keymap.set('n', '<Space>tx', ':tabclose<CR>', { noremap = true, silent = true, desc = 'close' })
end)

--
-- buffers
later(function()
  require('mini.bufremove').setup()

  vim.keymap.set(
    'n',
    '<Space>bd',
    '<cmd>lua MiniBufremove.delete()<CR>',
    { noremap = true, silent = true, desc = 'delete' }
  )
  vim.keymap.set(
    'n',
    '<Space>bu',
    '<cmd>lua MiniBufremove.unshow()<CR>',
    { noremap = true, silent = true, desc = 'unshow' }
  )
  vim.keymap.set(
    'n',
    '<Space>bw',
    '<cmd>lua MiniBufremove.wipeout()<CR>',
    { noremap = true, silent = true, desc = 'wipeout' }
  )
end)

--
-- kitty
now(function()
  add({
    source = 'fladson/vim-kitty',
  })
end)

--
-- lsp/treesitter/none-ls
now(function()
  -- lsp
  add({
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason.nvim' },
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

later(function()
  add({
    source = 'nvimtools/none-ls.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  })

  local null_ls = require('null-ls')
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua,
    },
  })

  -- format on save
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.lua',
    callback = function() vim.lsp.buf.format({ async = false }) end,
  })
end)

--
-- code completion
later(function()
  add({
    source = 'supermaven-inc/supermaven-nvim',
  })
  require('supermaven-nvim').setup({})
end)

--
-- code assistant
later(function()
  add({
    source = 'olimorris/codecompanion.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
      { source = 'stevearc/dressing.nvim' },
    },
  })

  require('codecompanion').setup({
    strategies = {
      chat = {
        adapter = 'litellm',
      },
      inline = {
        adapter = 'litellm',
      },
      agent = {
        adapter = 'litellm',
      },
    },
    adapters = {
      litellm = function()
        local adapter = require('codecompanion.adapters').extend('openai_compatible', {
          env = {
            url = function() return os.getenv('LITELLM_URL') end,
            api_key = function() return os.getenv('LITELLM_API_KEY') end,
          },
          schema = {
            model = {
              default = 'claude-sonnet',
              choices = {
                'claude-sonnet',
                'claude-haiku',
              },
              order = 1,
            },
            temperature = {
              default = 1,
              validate = function(n) return n >= 0 and n <= 2, 'Must be between 0 and 2' end,
              type = 'number',
              optional = true,
              order = 2,
            },
          },
        })

        -- fix for litellm
        adapter.env_replaced = {
          url = adapter.env.url(),
          api_key = adapter.env.api_key(),
        }
        adapter.handlers.form_parameters = function(self, params, messages)
          params.options = nil
          return params
        end

        return adapter
      end,
      copilot = false,
    },
  })
end)
