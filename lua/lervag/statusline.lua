local ctx = {}

local u = {
  info = function(text)
    return ctx.is_active and "%#SLInfo#" .. text .. "%*" or text
  end,
  alert = function(text)
    return ctx.is_active and "%#SLAlert#" .. text .. "%*" or text
  end,
  success = function(text)
    return ctx.is_active and "%#SLSuccess#" .. text .. "%*" or text
  end,
  highlight = function(text)
    return ctx.is_active and "%#SLHighlight#" .. text .. "%*" or text
  end,
}

local parts = {}

---Get filename
---@return string
function parts.filename()
  return u.highlight " %<%f"
end

---Get commonly shared stuff
---@return string
function parts.common()
  local locked = ""
  if
    not vim.api.nvim_get_option_value("modifiable", { buf = ctx.active_bufnr })
    or vim.api.nvim_get_option_value("readonly", { buf = ctx.active_bufnr })
  then
    locked = u.alert " "
  end

  local modified = ""
  if vim.api.nvim_get_option_value("modified", { buf = ctx.active_bufnr }) then
    modified = u.info " "
  end

  local diagnostics = {}
  if #locked == 0 then
    for _, cfg in ipairs {
      {
        severity = vim.diagnostic.severity.ERROR,
        method = "alert",
        symbol = "",
      },
      {
        severity = vim.diagnostic.severity.WARN,
        method = "highlight",
        symbol = "",
      },
      {
        severity = vim.diagnostic.severity.INFO,
        method = "info",
        symbol = "",
      },
    } do
      local n = #vim.diagnostic.get(ctx.bufnr, { severity = cfg.severity })
      if n > 0 then
        table.insert(diagnostics, u[cfg.method](" " .. cfg.symbol .. " " .. n))
      end
    end
  end

  local snippet = ""
  local us_ok, us_canjump = pcall(vim.fn["UltiSnips#CanJumpForwards"])
  if us_ok and us_canjump > 0 then
    local trigger =
      vim.fn.pyeval "UltiSnips_Manager._active_snippets[0].snippet.trigger"
    snippet = u.info("  " .. trigger)
  end

  local stl = table.concat {
    locked,
    modified,
    table.concat(diagnostics),
    snippet,
  }

  if #stl > 0 then
    return " " .. stl
  end

  return ""
end

---Get stuff from Metals LSP
---@return string
function parts.metals()
  ---@type string?
  local status = vim.g.metals_status
  if status then
    status = vim.fn.trim(status)
    return u.info("  " .. status)
  end

  return ""
end

---Get textwidth if text is too wide
---@return string
function parts.textwidth()
  local width = vim.fn.virtcol "$" - 1
  if vim.o.textwidth > 0 and width > vim.o.textwidth then
    ---@diagnostic disable-next-line: redundant-parameter
    return u.alert(vim.fn.printf(" [%s > %s &tw]", width, vim.o.textwidth))
  end

  return ""
end

---Get stuff from DAP
---@return string
function parts.dap()
  local ok, dap = pcall(require, "dap")

  if ok then
    local status = dap.status()
    if #status > 0 then
      return u.highlight("  " .. status)
    end
  end

  return ""
end

---Get stuff from fugitive
---@return string
function parts.git()
  local ok, head = pcall(vim.fn.FugitiveHead, 7, ctx.active_bufnr)
  if ok and #head > 0 then
    return " ⑂" .. head
  end

  return ""
end

local buftypes = {
  help = function()
    local bufname = vim.api.nvim_buf_get_name(ctx.active_bufnr)
    local name = vim.fn.fnamemodify(bufname, ":t:r")
    return u.info " vimdoc: " .. u.highlight(name)
  end,
  nofile = function()
    return u.info " %f" .. "%= %l av %L "
  end,
  prompt = function()
    return u.info " %f" .. "%= %l av %L "
  end,
  quickfix = function()
    local winnr = vim.api.nvim_win_get_number(ctx.active_winid)

    local qf_nr_stl = ""
    local qf_last = vim.fn["personal#qf#get_prop"]("nr", "$", winnr)
    if qf_last > 1 then
      local qf_nr = vim.fn["personal#qf#get_prop"]("nr", 0, winnr)
      qf_nr_stl = " " .. qf_nr .. "/" .. qf_last
    end

    return u.highlight(table.concat {
      " [",
      vim.fn["personal#qf#is_loc"](winnr) and "Loclist" or "Quickfix",
      qf_nr_stl,
      "]",
      " (",
      vim.fn["personal#qf#length"](winnr),
      ") ",
      vim.fn["personal#qf#get_prop"]("title", 0, winnr),
    })
  end,
}

---Statusline for buftypes
---@return string | nil
local function stl_from_buftype()
  local ok, bt =
    pcall(vim.api.nvim_get_option_value, "buftype", { buf = ctx.active_bufnr })
  if ok and buftypes[bt] then
    return buftypes[bt]()
  end
end

local schemes = {}

---@return string
function schemes.fugitive()
  return ""
  -- let l:bufname = bufname(a:context.bufnr)
  --
  -- let l:fname = matchstr(l:bufname, '\.git\/\/\x*\/\zs.*')
  -- if empty(l:fname)
  --   let l:fname = matchstr(l:bufname, '\.git\/\/\zs\x*')
  -- endif
  --
  -- if empty(l:fname)
  --   return s:_info(a:context, ' fugitive: ')
  --         \ . s:_highlight(a:context, 'Git status')
  -- endif
  --
  -- let l:stat = s:_info(a:context, ' fugitive: %<')
  -- let l:stat .= s:_highlight(a:context, l:fname)
  -- let l:stat .= s:status_common(a:context)
  --
  -- let l:commit = matchstr(l:bufname, '\.git\/\/\zs\x\{7}')
  -- let l:stat .= '%= ⑂' . (empty(l:commit) ? 'HEAD' : l:commit) . ' '
  --
  -- return l:stat
end

---@return string
function schemes.diffview()
  return ""
  -- let l:bufname = bufname(a:context.bufnr)
  --
  -- let l:fname = matchstr(l:bufname, '\.git\/[0-9a-z:]*\/\zs.*')
  -- if empty(l:fname)
  --   let l:fname = matchstr(l:bufname, '\.git\/\zs[0-9a-z:]*')
  -- endif
  --
  -- if empty(l:fname)
  --   let l:name = matchstr(l:bufname, 'panels\/\d\+\/\zs.*')
  --   return s:_info(a:context, ' diffview: ') . s:_highlight(a:context, l:name)
  -- endif
  --
  -- let l:stat = s:_info(a:context, ' diffview: %<')
  -- let l:stat .= s:_highlight(a:context, l:fname)
  -- let l:stat .= s:status_common(a:context)
  --
  -- let l:commit = matchstr(l:bufname, '\.git\/\zs[0-9a-z:]\{7}')
  -- let l:stat .= '%= ⑂' . (empty(l:commit) ? 'HEAD' : l:commit) . ' '
  --
  -- return l:stat
end

---Statusline for schemes
---@return string | nil
local function stl_from_scheme()
  local buffer_name = vim.api.nvim_buf_get_name(ctx.active_bufnr)
  local matched = buffer_name:match "^%w+://"
  if matched then
    local scheme = matched:match "^%w+"
    if schemes[scheme] then
      return schemes[scheme]()
    end
  end
end

local filetypes = {}

---Statusline for tex files
---@return string
function filetypes.tex()
  local vimtex = vim.api.nvim_buf_get_var(ctx.active_bufnr, "vimtex")

  local statuses = {
    { symbol = " [⏻]" },
    { symbol = " [⏻]" },
    { symbol = " [⟳]" },
    { symbol = " [✔︎]", color = "success" },
    { symbol = " [✖]", color = "alert" },
  }

  local status = ""
  if vimtex.compiler.status and statuses[vimtex.compiler.status + 2] then
    local x = statuses[vimtex.compiler.status + 2]
    status = x.color and u[x.color](x.symbol) or x.symbol
  end

  return table.concat {
    status,
    parts.filename(),
    parts.common(),
    "%=",
    parts.textwidth(),
    parts.git(),
    " ",
  }
end

---Statusline for Scala files
---@return string
function filetypes.scala()
  return table.concat {
    parts.filename(),
    parts.common(),
    "%=",
    parts.metals(),
    "%=",
    parts.textwidth(),
    parts.dap(),
    parts.git(),
    " ",
  }
end
filetypes.sbt = filetypes.scala

---Statusline for filetype
---@return string | nil
local function stl_from_filetype()
  local ok, ft =
    pcall(vim.api.nvim_get_option_value, "filetype", { buf = ctx.active_bufnr })
  if ok and filetypes[ft] then
    return filetypes[ft](ctx)
  end
end

---Statusline for preview windows
---@return string | nil
local function stl_preview()
  local ok, previewwindow = pcall(
    vim.api.nvim_get_option_value,
    "previewwindow",
    { win = ctx.active_winid }
  )
  if ok and previewwindow then
    return table.concat {
      parts.filename(),
      parts.common(),
      "%=",
      u.alert " [preview] ",
    }
  end
end

---Statusline for normal windows
---@return string
local function stl_normal()
  return table.concat {
    parts.filename(),
    parts.common(),
    "%=",
    parts.textwidth(),
    parts.dap(),
    parts.git(),
    " ",
  }
end

local M = {}

---This is the entry point for the statusline function.
---It returns a string that adheres to the docs in :help 'statusline'.
---@return string
function M.main()
  ---@type integer
  ctx.active_winid = vim.g.statusline_winid
  ctx.active_bufnr = vim.api.nvim_win_get_buf(ctx.active_winid)
  ctx.is_active = ctx.active_winid == vim.api.nvim_get_current_win()

  local stl_bt = stl_from_buftype()
  if stl_bt then
    return stl_bt
  end

  local stl_scheme = stl_from_scheme()
  if stl_scheme then
    return stl_scheme
  end

  local stl_ft = stl_from_filetype()
  if stl_ft then
    return stl_ft
  end

  local stl_p = stl_preview()
  if stl_p then
    return stl_p
  end

  return stl_normal()
end

return M
