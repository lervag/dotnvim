local M = {}

---Create documentation
---
---  This is my own custom implementation of
---  ~/.local/plugged/nvim-cmp/lua/cmp/entry.lua:491
---
---@return string[]
M.get_documentation = function(self)
  local item = self.completion_item

  local documents = {}

  if type(item.documentation) == "string" then
    local value = vim.trim(item.documentation)
    if value ~= "" then
      table.insert(documents, {
        kind = "markdown",
        value = ("## %s\n---\n"):format(value),
      })
    end
  end

  if item.detail and item.detail ~= "" then
    local ft = self.context.filetype
    local dot_index = string.find(ft, "%.")
    if dot_index ~= nil then
      ft = string.sub(ft, 0, dot_index - 1)
    end
    if ft == "wiki" or ft == "markdown" then
      table.insert(documents, {
        kind = "plaintext",
        value = vim.trim(item.detail),
      })
    else
      table.insert(documents, {
        kind = "markdown",
        value = ("```%s\n%s\n```\n"):format(ft, vim.trim(item.detail)),
      })
    end
  end

  if
    type(item.documentation) == "table"
    and type(item.documentation.value) == "string"
    and item.documentation.value ~= ""
  then
    local value = vim.trim(item.documentation.value)
    if value ~= "" then
      table.insert(documents, item.documentation)
    end
  end

  return vim.lsp.util.convert_input_to_markdown_lines(documents)
end

return M
