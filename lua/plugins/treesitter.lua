local M = {}

function M.setup()
  local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add
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
        'yaml',
        'toml',
        'json',
        'dockerfile',
        'hcl',
        'bash',
        'markdown',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'regex',
        'sql',
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
          selection_modes = {
            ['@function.outer'] = 'V',
            ['@function.inner'] = 'V',
            ['@class.outer'] = 'V',
            ['@class.inner'] = 'V',
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

      require('mini.ai').setup({
        custom_textobjects = {
          f = spec,
        },
      })
    end)
  end)
end

return M
