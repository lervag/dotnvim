local ctx = require "lervag.statusline.context"

---@alias Color "gold" | "yellow" | "white" | "red" | "cyan" | "green" | "green_light" | "blue" | "italic"

---@class IconConfig
---@field glyph string
---@field color? Color

---@type table<string, IconConfig>
local icons = {
  newfile = {
    glyph = "  ",
    color = "white",
  },
  locked = {
    glyph = "  ",
    color = "red",
  },
  modified = {
    glyph = "  ",
    color = "green_light",
  },
  lsp = {
    glyph = "  ",
    color = "cyan",
  },
  dap = {
    glyph = "  ",
    color = "blue",
  },
  git = {
    glyph = " 󰊢 ",
    color = "yellow",
  },
  link = {
    glyph = "  ",
    color = "red",
  },
  wiki = {
    glyph = "  ",
    color = "cyan",
  },
  journal = {
    glyph = "  ",
    color = "green",
  },
  tex_off = {
    glyph = " ⏻",
  },
  tex_compiling = {
    glyph = " ",
    color = "cyan",
  },
  tex_ok = {
    glyph = " ",
    color = "green",
  },
  tex_failed = {
    glyph = " ",
    color = "red",
  },
}

local M = {}

---@param name string
---@return string
function M.icon(name)
  local icon = icons[name]
  if icon.color then
    return M.colorize(icon.glyph, icon.color)
  end

  return icon.glyph
end

---@param text string
---@param group string
---@return string
function M.in_group(text, group)
  return "%#" .. group .. "#" .. text .. "%*"
end

---@param text string
---@param color Color
---@return string
function M.colorize(text, color)
  local group = "SL"
    .. color:sub(1, 1):upper()
    .. color:sub(2):gsub("_([a-z])", function(l)
      return l:upper()
    end)

  return M.in_group(text, group)
end

---@param text string
---@param color Color
---@param condition boolean
---@return string
function M.colorize_if(text, color, condition)
  if condition then
    return M.colorize(text, color)
  end

  return text
end

---@param text string
---@param color Color
---@return string
function M.colorize_active(text, color)
  if ctx.is_active then
    return M.colorize(text, color)
  end

  return text
end

return M
