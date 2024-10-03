vim.fn["personal#markdown#init"]()

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

vim.keymap.set(
  "n",
  "<leader>ar",
  "<cmd>call medieval#eval('', #{ after: { _, _ -> personal#markdown#place_signs() } })",
  { buffer = true }
)
