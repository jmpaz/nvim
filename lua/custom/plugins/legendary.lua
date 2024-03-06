return {
  {
    'mrjones2014/legendary.nvim',
    config = function()
      vim.keymap.set('n', '<leader>sK', '<cmd>Legendary<cr>', { desc = 'Legendary keymaps' })
    end,
    keys = { '<leader>sK' },
  },
}
