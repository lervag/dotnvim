vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd "nvim-treesitter"
      end
      vim.cmd "TSUpdate"
    end
  end,
})
vim.pack.add {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/LiadOz/nvim-dap-repl-highlights",
}

vim.treesitter.language.register("markdown", "mdx")

-- This must be done before we configure treesitter
require('nvim-dap-repl-highlights').setup()

local treesitter = require "nvim-treesitter"

---@alias TSFiletypeOptions table<string, TSOptionsSpec>

---@class TSOptionsSpec1
---@field enabled boolean
---@field indent? boolean

---@class TSOptionsSpec2
---@field enabled? boolean
---@field indent boolean

---@alias TSOptionsSpec TSOptionsSpec1|TSOptionsSpec2

---@class TSOptions
---@field enabled boolean
---@field indent boolean

---@class InstallStates
---@field [string] InstallState

---@class InstallState
---@field waiting_buffers table<integer, boolean>
---@field is_installing boolean

---Enable treesitter for buffer
---@param buf integer
---@param lang string
---@param options TSOptions
---@return boolean Enabled successfully
local function enable_treesitter(buf, lang, options)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  local ok = pcall(vim.treesitter.start, buf, lang)
  if ok and options.indent then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return ok
end

---@type InstallStates
local state_enabling = {}

---@type string[]
local core_parsers = {
  "bash",
  "css",
  "dap_repl",
  "diff",
  "html",
  "html_tags",
  "json",
  "jsx",
  "kotlin",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

---@type TSFiletypeOptions
local filetype_options = {
  -- checkhealth = { enabled = false },
  tex = {
    enabled = false,
  },
  vim = {
    indent = false,
  },
  zsh = {
    enabled = false,
  },
}

require("lervag.util").load_delayed(function()
  treesitter.install(core_parsers, { max_jobs = 8 })
end)

-- Auto-install parsers and start highlighting and indentation
local group = vim.api.nvim_create_augroup("init_treesitter", {})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Enable treesitter highlighting and indentation (non-blocking)",
  callback = function(event)
    ---@type TSOptions
    local defaults = {
      enabled = true,
      indent = true,
    }

    ---@type TSOptions
    local options =
      vim.tbl_extend("keep", filetype_options[event.match] or {}, defaults)

    if not options.enabled then
      return
    end
    local lang = vim.treesitter.language.get_lang(event.match) or event.match

    if not enable_treesitter(event.buf, lang, options) then
      if not vim.list_contains(treesitter.get_available(), lang) then
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
                enable_treesitter(b, lang, options)
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

-- Clean up treesitter enabling states
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
