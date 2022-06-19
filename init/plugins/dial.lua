local dial = require "dial.map"

vim.keymap.set("n", "<C-a>", dial.inc_normal())
vim.keymap.set("n", "<C-x>", dial.dec_normal())
vim.keymap.set("v", "<C-a>", dial.inc_visual())
vim.keymap.set("v", "<C-x>", dial.dec_visual())
vim.keymap.set("v", "g<C-a>", dial.inc_gvisual())
vim.keymap.set("v", "g<C-x>", dial.dec_gvisual())

local augend = require("dial.augend")
require("dial.config").augends:register_group {
  default = {
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%d/%m/%Y"],
    augend.date.alias["%H:%M:%S"],
    augend.semver.alias.semver,
    augend.hexcolor.new {
      case = "lower",
    },
    augend.constant.alias.bool,
    augend.constant.new {
      elements = {"yes", "no"},
      word = true,
      cyclic = true,
    },
    augend.constant.new {
      elements = {"and", "or"},
      word = true,
      cyclic = true,
    },
    augend.case.new {
      types = {"camelCase", "snake_case"},
      cyclic = true,
    },
  },
}
