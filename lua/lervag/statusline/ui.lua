local ctx = require "lervag.statusline.context"

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

function M.icon(name)
  local icon = icons[name]
  if icon.color then
    return M[icon.color](icon.glyph)
  end

  return icon.glyph
end

---@param text string
---@param group string
---@return string
function M.colorize(text, group)
  return "%#" .. group .. "#" .. text .. "%*"
end

---@param text string
---@param group string
---@param condition boolean
---@return string
function M.colorize_if(text, group, condition)
  if condition then
    return M.colorize(text, group)
  end

  return text
end

setmetatable(M, {
  ---@param key string
  __index = function(_, key)
    local color = "SL" .. key:sub(1, 1):upper()
      .. key:sub(2):gsub("_([a-z])", function(l)
        return l:upper()
      end)

    return function(text)
      return M.colorize_if(text, color, ctx.is_active)
    end
  end,
})

return M
