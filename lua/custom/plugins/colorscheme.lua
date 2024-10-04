return {
  {
    'RedsXDD/neopywal.nvim',
    name = 'neopywal',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('neopywal').setup {
        use_wallust = true,
      }
      vim.o.background = 'dark'
      vim.cmd.colorscheme 'neopywal'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
