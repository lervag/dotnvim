local parts = require "lervag.statusline.parts"
local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

local filetypes = {}

---@class VimtexCompiler
---@field status? int

---@class Vimtex
---@field compiler VimtexCompiler

---@return string
function filetypes.tex()
  ---@diagnostic disable-next-line: assign-type-mismatch
  ---@type boolean, Vimtex
  local ok, vimtex = pcall(vim.api.nvim_buf_get_var, ctx.active_bufnr, "vimtex")
  if not ok then
    return ""
  end

  local statuses = {
    "tex_off",
    "tex_off",
    "tex_compiling",
    "tex_ok",
    "tex_failed",
  }

  local status = ""
  if vimtex.compiler.status and statuses[vimtex.compiler.status + 2] then
    status = ui.icon(statuses[vimtex.compiler.status + 2])
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

function filetypes.wiki()
  local name = vim.fn.fnamemodify(ctx.active_name, ":t:r")
  local _, wiki = pcall(vim.api.nvim_buf_get_var, ctx.active_bufnr, "wiki")

  return table.concat {
    ui.icon(wiki and wiki.in_journal == 1 and "journal" or "wiki"),
    ui.gold(name),
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
    return filetypes[ft]()
  end
end

return M
