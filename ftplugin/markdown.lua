-- Handle e.g. floating previews from LSPs
if vim.bo.buftype == "nofile" then
  return
end

vim.fn["personal#markdown#color_code_blocks"]()

vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo[0][0].foldmethod = "expr"

vim.keymap.set("n", ")", "<plug>(wiki-link-next)", { buf = 0, remap = true })
vim.keymap.set("n", "(", "<plug>(wiki-link-prev)", { buf = 0, remap = true })
vim.keymap.set(
  { "o", "x" },
  "ac",
  ":<c-u>call personal#markdown#textobj_code_block(0, 0)<cr>",
  { buf = 0 }
)
vim.keymap.set(
  { "o", "x" },
  "ic",
  ":<c-u>call personal#markdown#textobj_code_block(1, 0)<cr>",
  { buf = 0 }
)

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
