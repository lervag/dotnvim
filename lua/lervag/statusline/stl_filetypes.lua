local parts = require "lervag.statusline.parts"
local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

local filetypes = {}

---@return string
function filetypes.tex()
  local vimtex = vim.api.nvim_buf_get_var(ctx.active_bufnr, "vimtex")

  local statuses = {
    { symbol = " ⏻" },
    { symbol = " ⏻" },
    { symbol = " ", color = "cyan" },
    { symbol = " ", color = "success" },
    { symbol = " ", color = "alert" },
  }

  local status = ""
  if vimtex.compiler.status and statuses[vimtex.compiler.status + 2] then
    local x = statuses[vimtex.compiler.status + 2]
    status = x.color and ui[x.color](x.symbol) or x.symbol
  end

  return table.concat {
    status,
    parts.filename(),
    parts.common(),
    "%=",
    parts.git(),
    " ",
  }
end

---@return string
function filetypes.scala()
  return table.concat {
    parts.filename(),
    parts.common(),
    "%=",
    parts.metals(),
    "%=",
    parts.dap(),
    parts.git(),
    " ",
  }
end
filetypes.sbt = filetypes.scala

function filetypes.wiki()
  local name = vim.fn.fnamemodify(ctx.active_name, ":t:r")
  local _, wiki = pcall(vim.api.nvim_buf_get_var, ctx.active_bufnr, "wiki")

  return table.concat {
    ui.cyan(wiki and wiki.in_journal == 1 and "   " or "   "),
    ui.highlight(name),
    parts.wiki_broken_links(),
    parts.common(),
  }
end

local M = {}

---@return string | nil
function M.parse()
  local ok, ft =
    pcall(vim.api.nvim_get_option_value, "filetype", { buf = ctx.active_bufnr })
  if ok and filetypes[ft] then
    return filetypes[ft](ctx)
  end
end

return M
