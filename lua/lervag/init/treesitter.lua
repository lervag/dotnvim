local function start(buf, lang)
  local ok = pcall(vim.treesitter.start, buf, lang)
  if ok then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  else
    vim.notify("Could not start treesitter for: " .. lang, vim.log.levels.WARN)
  end
  return ok
end

local M = {}

---Initialize nvim-treesitter
---@param core_parsers string[]
---@param ignored_filetypes string[]
M.init = function(core_parsers, ignored_filetypes)
  local treesitter = require "nvim-treesitter"
  local namespace = vim.api.nvim_create_namespace "treesitter.async"

  -- Decoration provider for async parser loading
  local parsers_loaded = {}
  local parsers_pending = {}
  local parsers_failed = {}
  vim.api.nvim_set_decoration_provider(namespace, {
    on_start = vim.schedule_wrap(function()
      if #parsers_pending == 0 then
        return false
      end
      for _, data in ipairs(parsers_pending) do
        if vim.api.nvim_buf_is_valid(data.buf) then
          if start(data.buf, data.lang) then
            parsers_loaded[data.lang] = true
          else
            parsers_failed[data.lang] = true
          end
        end
      end
      parsers_pending = {}
    end),
  })

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

      local lang = vim.treesitter.language.get_lang(event.match)

      if parsers_failed[lang] then
        return
      end

      if parsers_loaded[lang] then
        start(event.buf, lang)
      else
        table.insert(parsers_pending, { buf = event.buf, lang = lang })
      end

      treesitter.install { lang }
    end,
  })
end

return M
