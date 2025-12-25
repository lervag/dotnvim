local pending_buffers = {}

---Start treesitter for buffer
---@param buf integer
---@param lang string
---@param attempts integer
---@return boolean Started successfully?
local function start_with_retry(buf, lang, attempts)
  local pending_key = buf .. ":" .. lang

  -- Clean up pending retries for invalid buffers
  if not vim.api.nvim_buf_is_valid(buf) then
    pending_buffers[pending_key] = nil
    return false
  end

  -- Avoid duplicate start loops
  if pending_buffers[pending_key] then
    return false
  end

  local ok = pcall(vim.treesitter.start, buf, lang)
  if ok and vim.api.nvim_buf_is_valid(buf) then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    pending_buffers[pending_key] = nil
  elseif attempts > 0 then
    pending_buffers[pending_key] = true
    vim.defer_fn(function()
      start_with_retry(buf, lang, attempts - 1)
    end, 500)
  else
    vim.notify("Could not start treesitter for: " .. lang, vim.log.levels.WARN)
    pending_buffers[pending_key] = nil
  end

  return ok
end

local M = {}

---Initialize nvim-treesitter
---@param core_parsers string[]
---@param ignored_filetypes string[]
M.init = function(core_parsers, ignored_filetypes)
  local treesitter = require "nvim-treesitter"

  -- Install core parsers after lazy.nvim finishes loading all plugins
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    once = true,
    callback = function()
      treesitter.install(core_parsers, { max_jobs = 8 })
    end,
  })

  -- Auto-install parsers and start highlighting and indentation
  local group = vim.api.nvim_create_augroup("TreesitterSetup", {})
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    desc = "Enable treesitter highlighting and indentation (non-blocking)",
    callback = function(event)
      if vim.tbl_contains(ignored_filetypes, event.match) then
        return
      end

      local lang = vim.treesitter.language.get_lang(event.match) or event.match
      treesitter.install { lang }
      start_with_retry(event.buf, lang, 10)
    end,
  })
end

return M
