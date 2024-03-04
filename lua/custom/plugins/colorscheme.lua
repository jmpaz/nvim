return {
  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'tokyonight-storm'
  --   end,
  -- },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        variant = 'auto',
        dark_variant = 'moon',
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
      }
      vim.cmd.colorscheme 'rose-pine'
    end,
  },
  -- {
  --   "oncomouse/lushwal.nvim",
  --   cmd = { "LushwalCompile" },
  --   dependencies = {
  --     { "rktjmp/lush.nvim" },
  --     { "rktjmp/shipwright.nvim" },
  --   },
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'lushwal'
  --   end,
  -- },
}
-- vim: ts=2 sts=2 sw=2 et
