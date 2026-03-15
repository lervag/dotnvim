vim.fn["personal#markdown#init"]()

-- Disable minidiff for wiki buffers
vim.b.minidiff_disable = true

vim.opt_local.isfname:remove ","

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

vim.keymap.set(
  "n",
  "<leader>ar",
  "<cmd>call medieval#eval()<cr>",
  { buffer = true }
)

vim.keymap.set("i", "LLM", function()
  require("lervag.util.links").create_link_from_clipboard()
end, { buffer = true })
