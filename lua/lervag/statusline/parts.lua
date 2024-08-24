local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

local function shorten(path)
  local max_length = vim.fn.winwidth(0) - 40
  local length = #path
  if length <= max_length then
    return path
  end

  local segments = vim.split(path, "/")
  for idx = 1, #segments - 1 do
    if length <= max_length then
      break
    end

    local segment = segments[idx]
    local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
    segments[idx] = shortened
    length = length - (#segment - #shortened)
  end

  return table.concat(segments, "/")
end

local M = {}

---@return string
function M.filename()
  local filename = vim.fn.expand "%:~:."
  if #filename == 0 then
    return " [No file]"
  end

  if vim.fn.filereadable(filename) == 0 then
    return " " .. ui.italic(shorten(filename)) .. ui.icon "newfile"
  end

  return " " .. ui.gold(shorten(filename))
end

---@return string
function M.common()
  local locked = ""
  if
    not vim.api.nvim_get_option_value("modifiable", { buf = ctx.active_bufnr })
    or vim.api.nvim_get_option_value("readonly", { buf = ctx.active_bufnr })
  then
    locked = ui.icon "locked"
  end

  local modified = ""
  if vim.api.nvim_get_option_value("modified", { buf = ctx.active_bufnr }) then
    modified = ui.icon "modified"
  end

  local snippet = ""
  local us_ok, us_canjump = pcall(vim.fn["UltiSnips#CanJumpForwards"])
  if us_ok and us_canjump > 0 then
    local trigger =
      vim.fn.pyeval "UltiSnips_Manager._active_snippets[0].snippet.trigger"
    snippet = ui.icon "snippet" .. ui.cyan(trigger)
  end

  local stl = table.concat {
    locked,
    modified,
    snippet,
  }

  if #stl > 0 then
    return stl
  end

  return ""
end

---@return string
function M.lsp()
  local clients = vim.lsp.get_clients {
    bufnr = ctx.active_bufnr,
  }

  if #clients > 0 then
    return ui.icon "lsp" .. clients[1].name
  end

  return ""
end

---@return string
function M.dap()
  local ok, dap = pcall(require, "dap")

  if ok then
    local status = dap.status()
    if #status > 0 then
      return ui.icon "dap" .. "debugging"
    end
  end

  return ""
end

---@return string
function M.git()
  local ok, head = pcall(vim.fn.FugitiveHead, 7, ctx.active_bufnr)
  if ok and #head > 0 then
    return ui.icon "git" .. head
  end

  return ""
end

---@param ref string
---@param path string
---@return string
function M.gitfile(ref, path)
  return table.concat {
    ui.red(" " .. ref),
    ui.icon "git",
    ui.gold(path),
    M.common(),
  }
end

---@return string
function M.wiki_broken_links()
  local path = vim.fn.fnamemodify(ctx.active_name, ":p")
  if vim.fn.filereadable(path) then
    ---@type integer
    local broken_links = vim.api.nvim_call_function(
      "wiki#graph#get_number_of_broken_links",
      { path }
    )
    if broken_links > 0 then
      return ui.icon "link" .. ui.red(broken_links)
    end
  end

  return ""
end

return M
