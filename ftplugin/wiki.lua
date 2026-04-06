vim.wo[0][0].conceallevel = 2
vim.wo[0][0].foldexpr = "v:lua.require('lervag.util.wiki').foldexpr(v:lnum)"
vim.wo[0][0].foldmethod = "expr"

vim.opt_local.isfname:remove ","

vim.fn["personal#markdown#color_code_blocks"]()

-- Disable minidiff for wiki buffers
vim.b.minidiff_disable = true

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

vim.keymap.set("i", "<c-l>", function()
  require("lervag.util.links").create_link()
end, { buffer = true })
vim.keymap.set("i", "LLW", function()
  require("lervag.util.links").create_link()
end, { buffer = true })
vim.keymap.set("i", "<c-e>", function()
  MiniSnippets.session.stop()
  vim.cmd [[ normal "o<cr>"]]
end, { buffer = true })

vim.keymap.set("i", "LLM", function()
  require("lervag.util.links").create_link_from_clipboard()
end, { buffer = true })
