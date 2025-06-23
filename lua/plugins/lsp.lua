local M = {}

function M.setup()
  local now, add = MiniDeps.now, MiniDeps.add
  now(function()
    add({
      source = 'neovim/nvim-lspconfig',
      depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
    })
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'ruff', 'pyright', 'gopls' },
      automatic_installation = true,
    })

    local ruff_client_id = nil
    local ruff_attached_buffers = {}
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp_attach_config', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        if client.name == 'ruff' then
          -- prevent duplicate instances
          if ruff_attached_buffers[args.buf] then
            vim.lsp.stop_client(client.id, true)
            return
          end
          ruff_attached_buffers[args.buf] = true
          ruff_client_id = client.id
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.documentFormattingProvider = true
        elseif client.name == 'pyright' then
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

    require('lspconfig').pyright.setup({
      on_attach = function(client, bufnr)
        client.server_capabilities.diagnosticProvider = false
        client.server_capabilities.publishDiagnostics = false

        local opts = { noremap = true, silent = true }
        local patch = require('config.lsp_patch')
        vim.keymap.set(
          'n',
          'gd',
          function() patch.goto_definition(false) end,
          vim.tbl_extend('force', opts, { buffer = bufnr })
        )
        vim.keymap.set(
          'n',
          'g ',
          function() patch.goto_definition(true) end,
          vim.tbl_extend('force', opts, { buffer = bufnr })
        )
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      end,
      settings = {
        pyright = {
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            ignore = { '*' },
          },
        },
      },
    })

    require('lspconfig').gopls.setup({
      on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true }
        local patch = require('config.lsp_patch')
        vim.keymap.set(
          'n',
          'gd',
          function() patch.goto_definition(false) end,
          vim.tbl_extend('force', opts, { buffer = bufnr })
        )
        vim.keymap.set(
          'n',
          'g ',
          function() patch.goto_definition(true) end,
          vim.tbl_extend('force', opts, { buffer = bufnr })
        )
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      end,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { 'source.organizeImports' } }
        local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
        if result then
          for _, res in pairs(result) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
              else
                vim.lsp.buf.execute_command(r.command)
              end
            end
          end
        end
        vim.lsp.buf.format({ async = false })
      end,
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.py',
      callback = function()
        -- organize imports
        local ok = pcall(
          function()
            vim.lsp.buf.code_action({
              context = {
                only = { 'source.organizeImports' },
                diagnostics = {},
              },
              apply = true,
            })
          end
        )

        -- format buffer
        local format_ok = false
        if ruff_client_id then
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client.id == ruff_client_id and client.server_capabilities.documentFormattingProvider then
              vim.lsp.buf.format({
                async = false,
                bufnr = 0,
                filter = function(c) return c.id == ruff_client_id end,
              })
              format_ok = true
              break
            end
          end
        end

        if not format_ok then pcall(vim.lsp.buf.format, { async = false, bufnr = 0 }) end
      end,
    })
  end)
end

return M
