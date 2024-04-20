return {
  {
    'sourcegraph/sg.nvim',
    -- branch = 'update-cody-agent-03-12',
    -- build = 'nvim -l build/init.lua',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('sg').setup()
      -- nnoremap { '<space>ss', "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>" }
      vim.keymap.set('n', '<space>sS', function()
        require('sg.extensions.telescope').fuzzy_search_results()
      end, { desc = '[S]earch [S]ourcegraph' })
    end,
  },
}
