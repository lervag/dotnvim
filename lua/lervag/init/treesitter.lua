---Enable treesitter for buffer
---@param buf integer
---@param lang string
---@return boolean Enabled successfully
local function enable_treesitter(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  local ok = pcall(vim.treesitter.start, buf, lang)
  if ok then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return ok
end

---@class InstallState
---@field waiting_buffers table<integer, boolean>
---@field is_installing boolean

---@type table<string, InstallState>
local state_enabling = {}

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
      if vim.list_contains(ignored_filetypes, event.match) then
        return
      end
      local lang = vim.treesitter.language.get_lang(event.match) or event.match

      if not enable_treesitter(event.buf, lang) then
        if not vim.list_contains(treesitter.get_available(), lang) then
          vim.notify(
            "Treesitter parser is not available for " .. lang .. "!",
            vim.log.levels.WARN
          )
          return
        end

        local state = state_enabling[lang]
          or {
            waiting_buffers = {},
            installing = false,
          }
        state_enabling[lang] = state
        state.waiting_buffers[event.buf] = true

        -- Only start install if not already in progress
        if not state.is_installing then
          state.is_installing = true

          local task = treesitter.install(lang)
          if task and task.await then
            task:await(function()
              vim.schedule(function()
                state.is_installing = false

                -- Enable treesitter on all waiting buffers for this language
                for b in pairs(state.waiting_buffers) do
                  enable_treesitter(b, lang)
                end
                state_enabling[lang] = nil
              end)
            end)
          else
            state_enabling[lang] = nil
          end
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    desc = "Clean up treesitter enabling states",
    callback = function(event)
      for lang, state in pairs(state_enabling) do
        state.waiting_buffers[event.buf] = nil
        if vim.tbl_isempty(state.waiting_buffers) then
          state_enabling[lang] = nil
        end
      end
    end,
  })
end

return M
