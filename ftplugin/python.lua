vim.bo.define = [[^\s*\(def\|class\)]]
vim.bo.includeexpr = "personal#python#includexpr()"

vim.wo.colorcolumn = "+1"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.fn["personal#python#set_path"]()

vim.keymap.set("n", "<leader>lo", function()
  local params = {
    command = "pyright.organizeimports",
    arguments = { vim.uri_from_bufnr(0) },
  }

  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  }
  for _, client in ipairs(clients) do
    client:request("workspace/executeCommand", params, nil, 0)
  end
end)
