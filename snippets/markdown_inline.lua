local u = require "lervag.util.snippets"

local snippets = {
}

vim.list_extend(snippets, u.require "markdown")

return snippets
