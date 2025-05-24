local M = {}

function M.setup()
  local later = MiniDeps.later
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
end

return M
