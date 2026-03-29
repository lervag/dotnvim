vim.pack.add { "https://github.com/b0o/incline.nvim" }

require("incline").setup {
  render = function(props)
    local diagnostics = {}
    for _, cfg in ipairs {
      {
        severity = vim.diagnostic.severity.ERROR,
        group = "DiagnosticVirtualTextError",
        symbol = " ",
      },
      {
        severity = vim.diagnostic.severity.WARN,
        group = "DiagnosticVirtualTextWarn",
        symbol = " ",
      },
      {
        severity = vim.diagnostic.severity.INFO,
        group = "DiagnosticVirtualTextInfo",
        symbol = " ",
      },
      {
        severity = vim.diagnostic.severity.HINT,
        group = "DiagnosticVirtualTextHint",
        symbol = " ",
      },
    } do
      local n = #vim.diagnostic.get(props.buf, { severity = cfg.severity })
      if n > 0 and vim.diagnostic.is_enabled() then
        local label = (#diagnostics > 0 and " " or "") .. cfg.symbol .. n
        table.insert(diagnostics, { label, group = cfg.group })
      end
    end

    local width_warning = {}
    if
      props.focused
      and vim.o.modifiable
      and not vim.o.readonly
      and vim.fn.line "." > 1
    then
      local textwidth = vim.o.textwidth
      local width = vim.fn.charcol "$" - 1
      if textwidth > 0 and width > textwidth then
        width_warning = {
          ("  %s > %s"):format(width, textwidth),
          group = "DiagnosticVirtualTextError",
        }
      end
    end

    ---@param left integer
    ---@param right integer
    ---@return string | table
    local function separator(left, right)
      if left > 0 and right > 0 then
        return { " │ ", group = "MatchWord" }
      end
      return ""
    end

    return {
      diagnostics,
      separator(#diagnostics, #width_warning),
      width_warning,
    }
  end,
}
