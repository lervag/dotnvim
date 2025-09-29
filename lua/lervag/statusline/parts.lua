local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

---Shorten path
---@param name string
---@return string
local function shorten(name)
  local path = vim.fn.fnamemodify(name, ":~:.")

  local max_length = vim.fn.winwidth(0) - 40
  local length = #path
  if length <= max_length then
    return path
  end

  local segments = vim.split(path, "/")
  for idx, segment in ipairs(segments) do
    if idx == #segments or length <= max_length then
      break
    end

    local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
    segments[idx] = shortened
    length = length - (#segment - #shortened)
  end

  return table.concat(segments, "/")
end

local M = {}

---Filename cache
local _cache_filename = { name = nil, short = nil, cwd = nil }

---@return string
function M.filename()
  if #ctx.active_name == 0 then
    return " [No file]"
  end

  local cwd = vim.fn.getcwd()
  if _cache_filename.name ~= ctx.active_name or _cache_filename.cwd ~= cwd then
    _cache_filename.name = ctx.active_name
    _cache_filename.cwd = cwd
    _cache_filename.short = shorten(ctx.active_name)
  end

  if vim.fn.filereadable(ctx.active_name) == 0 then
    return ui.icon "newfile" .. " " .. ui.italic(_cache_filename.short)
  end

  return " " .. ui.gold(_cache_filename.short)
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

  local stl = table.concat {
    locked,
    modified,
  }

  if #stl > 0 then
    return stl
  end

  return ""
end

---LSP cache per buffer
local _cache_lsp = {}

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  group = vim.api.nvim_create_augroup("statusline_lsp_cache", {}),
  callback = function(args)
    _cache_lsp[args.buf] = nil
  end,
})

---@return string
function M.lsp()
  if _cache_lsp[ctx.active_bufnr] ~= nil then
    return _cache_lsp[ctx.active_bufnr]
  end

  local clients = vim.lsp.get_clients {
    bufnr = ctx.active_bufnr,
  }

  local result = ""
  if #clients > 0 then
    result = ui.icon "lsp"
      .. table.concat(
        vim.tbl_map(function(c)
          return c.name
        end, clients),
        ", "
      )
  end

  _cache_lsp[ctx.active_bufnr] = result
  return result
end

---@return string
function M.dap()
  if not package.loaded.dap then
    return ""
  end

  local status = require("dap").status()
  if #status > 0 then
    return ui.icon "dap" .. "debugging"
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

---Wiki broken links cache
local _cache_wiki_broken_links = {}

-- Cache invalidation for wiki broken links
vim.api.nvim_create_autocmd({ "BufWritePost", "BufDelete" }, {
  group = vim.api.nvim_create_augroup("statusline_wiki_cache", {}),
  pattern = "*.wiki",
  callback = function()
    -- Clear entire cache when any wiki file changes
    _cache_wiki_broken_links = {}
  end,
})

---@return string
function M.wiki_broken_links()
  local path = vim.fn.fnamemodify(ctx.active_name, ":p")

  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= "file" then
    return ""
  end

  local cached = _cache_wiki_broken_links[path]

  -- Check if we have a valid cached result
  local file_mtime = stat.mtime.sec
  ---@diagnostic disable-next-line: unnecessary-if
  if cached and cached.mtime == file_mtime then
    return cached.result
  end

  -- Compute expensive result
  ---@type integer
  local broken_links = vim.api.nvim_call_function(
    "wiki#graph#get_number_of_broken_links",
    { path }
  )

  local result = ""
  if broken_links > 0 then
    result = ui.icon "link" .. ui.red(broken_links)
  end

  -- Cache the result
  _cache_wiki_broken_links[path] = {
    mtime = file_mtime,
    result = result,
  }

  return result
end

return M
