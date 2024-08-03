local ctx = {}

local u = {
  info = function(text)
    return ctx.is_active
      and "%#SLInfo#" .. text .. "%*"
      or text
  end,
  alert = function(text)
    return ctx.is_active
      and "%#SLAlert#" .. text .. "%*"
      or text
  end,
  success = function(text)
    return ctx.is_active
      and "%#SLSuccess#" .. text .. "%*"
      or text
  end,
  highlight = function(text)
    return ctx.is_active
      and "%#SLHighlight#" .. text .. "%*"
      or text
  end
}

local parts = {
  filename = function()
    return u.highlight(" %<%f")
  end,
  common = function()
    return " common"
  end,
  metals = function()
    --   let l:metals_status = trim(get(g:, 'metals_status', ''))
    --   if !empty(l:metals_status) && a:context.active
    --     let l:stat .= '%#SLInfo# ' . l:metals_status . '%*'
    --   endif
    return " metals"
  end,
  textwidth = function()
    local width = vim.fn.virtcol('$') - 1
    if vim.o.textwidth > 0 and width > vim.o.textwidth then
      ---@diagnostic disable-next-line: redundant-parameter
      return u.alert(vim.fn.printf(' [%s > %s &tw]', width, vim.o.textwidth))
    end

    return ""
  end,
  dap = function()
    local ok, dap = pcall(require, "dap")

    if ok then
      local status = dap.status()
      if #status > 0 then
        return u.highlight("  " .. status)
      end
    end

    return ""
  end,
  git = function()
    local ok, head = pcall(vim.fn.FugitiveHead, 7, ctx.active_bufnr)
    if ok and #head > 0 then
      return " ⑂" .. head
    end

    return ""
  end,
}

local function preview(ctx)
  return table.concat {
    parts.filename(),
    ctx.is_active and parts.common() or "",
    "%=",
    parts.metals(),
    u.alert(' [preview] ')
  }
end

local function fallback(ctx)
  return table.concat {
    parts.filename(),
    ctx.is_active and parts.common() or "",
    "%=",
    parts.metals(),
    parts.textwidth(),
    parts.dap(),
    parts.git(),
    " "
  }
end

local buftypes = {
  nofile = function(ctx)
    return " %f%= %l av %L "
  end,
  help = function(ctx)
    return " vimdoc"
  end
}

local schemes = {
  foo = function(ctx)
    return ""
  end
}

local filetypes = {}

local M = {}

---This is the entry point for the statusline function.
---It returns a string that adheres to the docs in :help 'statusline'.
---@return string
function M.main()

  ---@type integer
  ctx.active_winid = vim.g.statusline_winid
  ctx.active_bufnr = vim.api.nvim_win_get_buf(ctx.active_winid)
  ctx.is_active = ctx.active_winid == vim.api.nvim_get_current_win()

  -- Match on buftypes
  local ok, bt = pcall(vim.api.nvim_get_option_value, "buftype", { buf = ctx.active_bufnr })
  if ok and buftypes[bt] then
    return buftypes[bt](ctx)
  end

  -- Match on schemes
  local bufname = vim.api.nvim_buf_get_name(ctx.active_bufnr)
  local match = bufname:match "^%w+://"
  if match and schemes[match] then
    return schemes[match](ctx)
  end

  -- Match on filetypes
  local ok, ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = ctx.active_bufnr })
  if ok and filetypes[ft] then
    return filetypes[ft](ctx)
  end

  local ok, previewwindow = pcall(vim.api.nvim_get_option_value, "previewwindow", { win = ctx.active_winid })
  if ok and previewwindow then
    return preview(ctx)
  end

  return fallback(ctx)
end

return M
