vim.fn["personal#markdown#init"]()

-- Handle e.g. floating previews from LSPs
if vim.bo.buftype == "nofile" then
  vim.wo.foldlevel = 99

  -- This is a minor hack to fix a glitch where treesitter didn't start
  -- properly for small hovers
  vim.defer_fn(function()
    vim.treesitter.start()
  end, 50)
  return
end

vim.bo.indentexpr = "personal#markdown#indentexpr(v:lnum)"
vim.wo.conceallevel = 0

vim.keymap.set(
  "n",
  "<leader>aa",
  "<cmd>call personal#markdown#create_notes()<cr>",
  { buffer = true }
)
vim.keymap.set("n", "<leader>ai", function()
  require("img-clip").pasteImage {
    dir_path = "/home/lervag/documents/anki/lervag/collection.media",
    template = "![$FILE_NAME_NO_EXT]($FILE_NAME)",
  }
end, { buffer = true })
vim.keymap.set(
  "n",
  "<leader>a<c-i>",
  "<cmd>call personal#markdown#prepare_image()<cr>",
  { buffer = true }
)
vim.keymap.set(
  "n",
  "<leader>aI",
  "<cmd>call personal#markdown#view_image()<cr>",
  { buffer = true }
)

vim.keymap.set("i", "LLM", function()
  require("lervag.util.links").create_link_from_clipboard()
end, { buffer = true })
