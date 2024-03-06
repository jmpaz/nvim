return {
  {
    'mrjones2014/smart-splits.nvim',
    event = 'VeryLazy',
    build = './kitty/install-kittens.bash',
    config = function()
      require('smart-splits').setup()
      require('legendary').setup {
        extensions = {
          smart_splits = {
            directions = { 'h', 'j', 'k', 'l' },
            mods = {
              -- for moving cursor between windows
              move = '<C>',
              resize = '<C-M>',
              -- for swapping window buffers
              swap = {
                mod = '<C>',
                prefix = '<C-w>',
              },
            },
          },
        },
      }
    end,
  },
}
