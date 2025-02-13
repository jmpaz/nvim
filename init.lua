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
  require('mini.starter').setup({
    footer = '',
  })

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
  require('mini.hipatterns').setup()
  require('mini.operators').setup()
end)

--
-- mappings
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
  vim.keymap.set('n', '<localleader><C-q>', ':q!<CR>', { noremap = true, silent = true, desc = 'quit without saving' })
  vim.keymap.set('n', '<localleader><M-q>', ':qa<CR>', { noremap = true, silent = true, desc = 'quit all' })
  vim.keymap.set('n', '<localleader><S-q>', ':wq<CR>', { noremap = true, silent = true, desc = 'write + quit' })

  vim.keymap.set(
    'n',
    '<localleader><C-M-q>',
    ':qa!<CR>',
    { noremap = true, silent = true, desc = 'quit all without saving' }
  )
  vim.keymap.set('n', '<localleader><S-M-q>', ':wqa<CR>', { noremap = true, silent = true, desc = 'write + quit all' })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function() vim.cmd('redraw') end, -- Just do something trivial but non-empty
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

--
-- files
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
    -- Figure out directory of current buffer
    local file_path = vim.fn.expand('%:p')
    if file_path == '' then
      -- Buffer is empty (like a new unsaved file)
      file_path = vim.loop.cwd() -- fallback to current working dir
    end
    local dir = file_path
    if vim.fn.isdirectory(file_path) == 0 then
      dir = vim.fn.fnamemodify(file_path, ':h')
    end

    require('mini.files').open(dir)
  end)
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

--
-- pickers
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

later(function()
  add({
    source = 'danielfalk/smart-open.nvim',
    checkout = '0.2.x',
    hooks = {
      post_install = function() require('telescope').load_extension('smart_open') end,
    },
    depends = {
      'kkharji/sqlite.lua',
      {
        source = 'nvim-telescope/telescope-fzf-native.nvim',
        hooks = { post_install = function() vim.cmd('make') end },
      },
      'nvim-telescope/telescope-fzy-native.nvim',
    },
  })

  vim.keymap.set(
    'n',
    '<leader><leader>',
    function() require('telescope').extensions.smart_open.smart_open() end,
    { noremap = true, silent = true }
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
      { mode = 'n', keys = '<localleader>' },

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

      -- text objects
      { mode = 'n', keys = 'v' },
      { mode = 'x', keys = 'a' },
      { mode = 'x', keys = 'i' },
      { mode = 'o', keys = 'a' },
      { mode = 'o', keys = 'i' },
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

      -- text objects
      { mode = 'x', keys = 'af', desc = 'around function' },
      { mode = 'x', keys = 'if', desc = 'inside function' },
      { mode = 'o', keys = 'af', desc = 'around function' },
      { mode = 'o', keys = 'if', desc = 'inside function' },
      { mode = 'n', keys = 'vaf', desc = 'select around function' },
      { mode = 'n', keys = 'vif', desc = 'select inside function' },

      -- Add class text objects clues too since we have them
      { mode = 'x', keys = 'ac', desc = 'around class' },
      { mode = 'x', keys = 'ic', desc = 'inside class' },
      { mode = 'o', keys = 'ac', desc = 'around class' },
      { mode = 'o', keys = 'ic', desc = 'inside class' },
      { mode = 'n', keys = 'vac', desc = 'select around class' },
      { mode = 'n', keys = 'vic', desc = 'select inside class' },

      -- Group-level clues
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
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
  vim.o.expandtab = true
  vim.o.scrolloff = 10
  vim.o.updatetime = 1000
  vim.opt.iskeyword:append('-')
  vim.o.path = vim.o.path .. ',**'
  vim.o.termguicolors = true
  vim.o.hidden = false
end)

-- indent
now(function()
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "python" },
    callback = function(args)
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true
    end,
  })
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
-- tabs/buffers
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

later(function()
  add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  })

  local telescope = require('telescope.builtin')

  vim.keymap.set(
    'n',
    '<leader>o',
    telescope.lsp_document_symbols,
    { noremap = true, silent = true, desc = 'buffer symbols' }
  )

  vim.keymap.set(
    'n',
    '<leader>p',
    telescope.lsp_dynamic_workspace_symbols,
    { noremap = true, silent = true, desc = 'project symbols' }
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
-- treesitter
now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
  })

  local treesitter = require('nvim-treesitter.configs')
  treesitter.setup({
    ensure_installed = {
      'lua',
      'python',
      'rust',
      'javascript',
      'typescript',
      'tsx',
      'html',
      'css',
      'jsdoc',
      'vimdoc',

      -- markup/config
      'yaml',
      'toml',
      'json',
      'dockerfile',
      'hcl',
      'bash',
      'markdown',

      -- git
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',

      -- other common formats
      'regex',
      'sql',
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
        selection_modes = {
          ['@function.outer'] = 'V', -- linewise
          ['@function.inner'] = 'V', -- linewise
          ['@class.outer'] = 'V', -- linewise
          ['@class.inner'] = 'V', -- linewise
        },
        include_surrounding_whitespace = true,
      },
    },
  })

  later(function()
    local spec = MiniAi.gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    })

    -- Setup mini.ai with the spec
    require('mini.ai').setup({
      custom_textobjects = {
        f = spec,
      },
    })
  end)
end)

-- none-ls
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

-- LSP
now(function()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
  })
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { 'ruff', 'pyright' },
    automatic_installation = true,
  })

  local ruff_client_id = nil
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp_attach_config', { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

      if client.name == 'ruff' then
        ruff_client_id = client.id
        -- disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      elseif client.name == 'pyright' then
        -- disable Pyright diagnostics
        client.server_capabilities.diagnosticProvider = false
        client.server_capabilities.publishDiagnostics = false
      end
    end,
  })

  require('lspconfig').ruff.setup({
    on_attach = function(client) client.server_capabilities.diagnosticProvider = true end,
    init_options = {
      settings = {
        organizeImports = true,
        fixAll = false,
        lint = {
          enable = true,
        },
      },
    },
  })

  -- use Pyright for intellisense
  require('lspconfig').pyright.setup({
    on_attach = function(client)
      client.server_capabilities.diagnosticProvider = false
      client.server_capabilities.publishDiagnostics = false
    end,
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          ignore = { '*' }, -- ignore all files
        },
      },
    },
  })

  -- format on save
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.py',
    callback = function(args)
      -- organize imports
      vim.lsp.buf.code_action({
        context = {
          only = { 'source.organizeImports' },
          diagnostics = {},
        },
        apply = true,
      })
      -- format
      if ruff_client_id then
        vim.lsp.buf.format({
          async = false,
          filter = function(client) return client.id == ruff_client_id end,
        })
      end
    end,
  })
end)

-- LSP rename
later(function()
  add({
    source = 'smjonas/inc-rename.nvim',
  })

  require('inc_rename').setup({
    show_message = true,
    save_in_cmdline_history = false,
  })

  vim.keymap.set(
    'n',
    '<localleader>r',
    function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
    { expr = true, desc = 'inc. rename' }
  )
  vim.o.inccommand = 'split'
end)

--
-- noice
later(function()
  add({
    source = 'folke/noice.nvim',
    depends = {
      'MunifTanjim/nui.nvim',
      -- 'rcarriga/nvim-notify',
    },
  })

  require('noice').setup({
    notify = { enabled = false },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    routes = {
      {
        view = 'notify',
        filter = { event = 'msg_showmode' },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
      },
      popupmenu = {
        border = 'none',
        win_options = {
          winhighlight = 'Normal:Pmenu,FloatBorder:PmenuBorder',
        },
      },
    },
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
-- fzf
now(function()
  add({
    source = "ibhagwan/fzf-lua",
  })

  require("fzf-lua").setup()
end)

--
-- zk
--
now(function()
  -- set buffer-local mapping for going to link definition in Markdown files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "md" },
    callback = function(args)
      local bufnr = args.buf
      local opts = { buffer = bufnr, noremap = true, silent = true, desc = "Go to linked note" }
      vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
      vim.opt_local.conceallevel = 2
    end,
  })
end)

later(function()
  add({
    source = 'zk-org/zk-nvim',
  })

  require('zk').setup({
    picker = "fzf_lua",
    lsp = {
      auto_attach = {
        enabled = true,
        filetypes = { "markdown", "md" },
      },
    },
  })

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
  end

  map("n", "<leader>z", "<Nop>", "zk")

  -- create note
  map("n", "<leader>zc", function()
    vim.ui.input({ prompt = "note title: " }, function(input)
      if input == nil then
        return
      end
      vim.cmd(string.format("ZkNew { title = %q }", input))
    end)
  end, "create new")

  map("v", "<leader>zc", "<Nop>", "create from selection")
  map("v", "<leader>zct", ":'<,'>ZkNewFromTitleSelection<CR>", "title")
  map("v", "<leader>zcc", ":'<,'>ZkNewFromContentSelection<CR>", "content")

  -- create/open daily note
  vim.api.nvim_create_user_command("ZkDaily", function()
    local notebook = vim.env.ZK_NOTEBOOK_DIR
    if not notebook or notebook == "" then
      vim.notify("ZK_NOTEBOOK_DIR is not set", vim.log.levels.ERROR)
      return
    end
    require("zk").new({
      notebook_path = notebook,
      dir = "journal/daily",
    })
  end, { desc = "Create daily note" })
  map("n", "<leader>zd", "<Cmd>ZkDaily<CR>", "daily")

  -- open notes by recency or via tag
  map("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "open")
  map("n", "<leader>zt", "<Cmd>ZkTags<CR>", "tags")

  -- search
  map("n", "<leader>zs", function()
    local query = vim.fn.input("search: ")
    vim.cmd("ZkNotes { sort = { 'modified' }, match = { '" .. query .. "' } }")
  end, "search")
  map("v", "<leader>zs", ":'<,'>ZkMatch<CR>", "search")

  -- insert link
  map("n", "<leader>zk", "<Cmd>ZkInsertLink<CR>", "insert link")
  map("v", "<leader>zk", ":'<,'>ZkInsertLinkAtSelection<CR>", "insert link")

  -- open notes linking to/from the current buffer
  map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", "links out")
  map("n", "<leader>zL", "<Cmd>ZkBacklinks<CR>", "links in (backlinks)")

  -- index notebook
  map("n", "<leader>zx", "<Cmd>ZkIndex<CR>", "index")
end)


-- kdl
now(function()
  add({
    source = 'imsnif/kdl.vim',
  })
end)
