return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      local files = require 'mini.files'
      vim.keymap.set('n', '-', '<cmd>lua require("mini.files").open()<CR>', { desc = 'Files' })
      files.setup {
        mappings = {
          go_in_plus = 'l',
          go_in = 'L',
          synchronize = '<CR>',
          show_help = '?',
        },
        windows = {
          preview = true,
          width_focus = 50,
          width_nofocus = 15,
          width_preview = 70,
        },
      }

      local bracketed = require 'mini.bracketed'
      bracketed.setup {}

      local jump2d = require 'mini.jump2d'
      jump2d.setup {}

      local animate = require 'mini.animate'
      -- don't use animate when scrolling with the mouse (via folke/LazyVim)
      -- -- alternatively set mousescroll, eg vim.o.mousescroll = 'ver:12,hor:6'
      local mouse_scrolled = false
      for _, scroll in ipairs { 'Up', 'Down' } do
        local key = '<ScrollWheel' .. scroll .. '>'
        vim.keymap.set({ '', 'i' }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end
      animate.setup {
        cursor = { enable = true },
        scroll = {
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          },
        },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
      }

      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },
}
