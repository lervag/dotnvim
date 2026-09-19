vim.pack.add { "https://github.com/mfussenegger/nvim-dap-python" }

vim.bo.define = [[^\s*\(def\|class\)]]
vim.bo.includeexpr = function()
  local line = vim.api.nvim_get_current_line()
  local fname = (vim.v.fname:gsub("%.", "/"))

  -- findfile() is typed `string|string[]`, but only returns a list with {count}
  ---@param name string
  ---@return string
  local function find(name)
    local found = vim.fn.findfile(name)
    if type(found) == "string" then
      return found
    end
    return ""
  end

  local pre = line:match "^%s*from%s+(%S+)"
  if not pre then
    local mod = line:match "^%s*import%s+(%S+)"
    return mod and (mod:gsub("%.", "/")) or ""
  end

  -- Relative imports: ".." is the parent package, "." is the current one
  if pre:match "^%.%." then
    pre = "../" .. pre:sub(3)
  elseif pre:match "^%." then
    pre = pre:sub(2)
  end
  pre = (pre:gsub("(%w)%.", "%1/"))

  for _, cand in ipairs {
    find(pre .. "/" .. fname),
    find(pre),
    find(pre .. "/__init__.py"),
    pre,
  } do
    if vim.fn.filereadable(cand) == 1 then
      return cand
    end
  end

  return ""
end
vim.bo.textwidth = 0

vim.wo.colorcolumn = "+1"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = vim.treesitter.foldexpr

require("dap-python").setup "/home/lervag/.local/venvs/nvim/bin/python"
