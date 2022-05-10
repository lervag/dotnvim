require('dressing').setup({
  input = {
    prompt_align = "center",
    anchor = "NW",
    relative = "editor",
    prefer_width = 80,
    max_width = nil,
    min_width = nil,
  },
  select = {
    fzf = {
      window = {
        width = 0.9,
        height = 0.85,
      },
    },
    format_item_override = {
      codeaction = function(action_tuple)
        local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
        local client = vim.lsp.get_client_by_id(action_tuple[1])
        return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
      end,
    }
  },
})
