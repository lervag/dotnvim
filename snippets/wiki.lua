local u = require "lervag.util.snippets"

local snippets = {
  {
    prefix = "journal",
    desc = "Create journal link",
    body = "journal:$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE",
  },
}

vim.list_extend(snippets, u.require "markdown")

return snippets
