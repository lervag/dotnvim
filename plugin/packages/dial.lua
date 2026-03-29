vim.pack.add { "https://github.com/monaqa/dial.nvim" }

local augend = require "dial.augend"
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
      elements = { "yes", "no" },
      word = true,
      cyclic = true,
    },
    augend.constant.new {
      elements = { "and", "or" },
      word = true,
      cyclic = true,
    },
    augend.case.new {
      types = { "camelCase", "snake_case" },
      cyclic = true,
    },
  },
}

vim.keymap.set("n", "<c-a>", function()
  return require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<c-x>", function()
  return require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("x", "<c-a>", function()
  return require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("x", "<c-x>", function()
  return require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("n", "g<c-a>", function()
  return require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<c-x>", function()
  return require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("x", "g<c-a>", function()
  return require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("x", "g<c-x>", function()
  return require("dial.map").manipulate("decrement", "gvisual")
end)
