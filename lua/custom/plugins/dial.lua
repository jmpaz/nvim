return {
  {
    'monaqa/dial.nvim',
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.date.alias['%H:%M'],
          augend.date.alias['%H:%M:%S'],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new { elements = { 'let', 'const' } },
        },
      }
    end,
  },
}
