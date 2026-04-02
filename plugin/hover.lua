vim.keymap.set("n", "K", function()
  local const = require "lervag.const"

  local line_number = vim.fn.line "."
  for _, pattern in ipairs {
    [[wiki:\zs[^ ]\+]],
    [[<wiki:\zs[^>]\+>]],
    [=[\[wiki:\zs[^]]\+\]]=],
  } do
    local matches = vim.fn.matchbufline(
      "%",
      [[\%<.c]] .. pattern .. [[\%>.c]],
      line_number,
      line_number
    )
    if #matches > 0 then
      vim.cmd.WikiOpen(matches[1].text) ---@diagnostic disable-line: undefined-field
      return
    end
  end

  local cword = vim.fn.expand "<cword>"
  if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
    vim.cmd.help(cword)
    return
  end

  if vim.bo.filetype == "neomuttrc" then
    vim.cmd.Man "neomuttrc"
    vim.fn.search(cword)
    return
  end

  if not vim.tbl_isempty(vim.lsp.get_clients()) then
    vim.lsp.buf.hover { border = const.border }
  end
end)

-- Monkey patch the markdown converter to replace &npbs
local convert_to_md_orig = vim.lsp.util.convert_input_to_markdown_lines

---@param input lsp.MarkedString|lsp.MarkedString[]|lsp.MarkupContent
---@param contents string[]?
---@return string[]
vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
  contents = convert_to_md_orig(input, contents)
  return vim.tbl_map(function(line)
    local sub = line:gsub("&[^ ;]+;", {
      ["&nbsp;"] = " ",
    })
    local result = sub:gsub("\\_", "_")
    return result
  end, contents)
end
