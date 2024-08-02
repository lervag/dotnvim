local M = {}

---This is the entry point for the statusline function.
---It returns a string that adheres to the docs in :help 'statusline'.
---@return string
function M.main()

  ---@type integer
  M.active_winid = vim.g.statusline_winid
  M.active_bufnr = vim.api.nvim_win_get_buf(M.active_winid)
  M.is_active = M.active_winid == vim.api.nvim_get_current_win()

  -- Match on buftypes
  -- local ok, buftype = pcall(vim.api.nvim_get_option_value, "buftype", { buf = M.active_bufnr })
  -- if ok and false then
  --   -- return buftype statusline
  -- end

  -- Match on schemes
  local bufname = vim.api.nvim_buf_get_name(M.active_bufnr)
  local match = bufname:match "^%w+://"
  if match and #match > 0 then
    return " -- " .. bufname
  end

  -- Match on filetypes
  -- local ok, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = M.active_bufnr })
  -- if ok and false then
  --   -- return filetype statusline
  -- end

  local ok, previewwindow = pcall(vim.api.nvim_get_option_value, "previewwindow", { win = M.active_winid })
  if ok and previewwindow then
    return M.preview()
  end

  return M.fallback()
end

function M.info(text)
  return M.is_active
    and "%#SLInfo#" .. text .. "%*"
    or text
end

function M.alert(text)
  return M.is_active
    and "%#SLAlert#" .. text .. "%*"
    or text
end

function M.success(text)
  return M.is_active
    and "%#SLSuccess#" .. text .. "%*"
    or text
end

function M.highlight(text)
  return M.is_active
    and "%#SLHighlight#" .. text .. "%*"
    or text
end

function M.preview()
  return table.concat {
    M.filename(),
    M.is_active and M.common() or "",
    "%=",
    M.metals(),
    M.alert(' [preview] ')
  }
end

function M.fallback()
  return table.concat {
    M.filename(),
    M.is_active and M.common() or "",
    "%=",
    M.metals(),
    M.textwidth(),
    M.dap(),
    M.git(),
    " "
  }
end

function M.filename()
  return M.highlight(" %<%f")
end

function M.common()
  return " common"
end

function M.metals()
  --   let l:metals_status = trim(get(g:, 'metals_status', ''))
  --   if !empty(l:metals_status) && a:context.active
  --     let l:stat .= '%#SLInfo# ' . l:metals_status . '%*'
  --   endif
  return " metals"
end

function M.textwidth()
  local width = vim.fn.virtcol('$') - 1
  if vim.o.textwidth > 0 and width > vim.o.textwidth then
    ---@diagnostic disable-next-line: redundant-parameter
    return M.alert(vim.fn.printf(' [%s > %s &tw]', width, vim.o.textwidth))
  end

  return ""
end

function M.dap()
  local ok, dap = pcall(require, "dap")

  if ok then
    local status = dap.status()
    if #status > 0 then
      return M.highlight("  " .. status)
    end
  end

  return ""
end

function M.git()
  local ok, head = pcall(vim.fn.FugitiveHead, 7, M.active_bufnr)
  if ok and #head > 0 then
    return " ⑂" .. head
  end

  return ""
end

return M
