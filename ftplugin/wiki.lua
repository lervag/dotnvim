vim.fn["personal#markdown#init"]()

-- Disable minidiff for wiki buffers
vim.b.minidiff_disable = true

vim.opt_local.isfname:remove ","

local function create_link()
  local insert = MiniSnippets.config.expand.insert
    or MiniSnippets.default_insert

  insert { body = vim.b.wiki.in_journal == 1 and "[[/$1]]$0" or "[[$1]]$0" }
end

vim.keymap.set("i", "<c-l>", create_link, { buffer = true })
vim.keymap.set("i", "LLW", create_link, { buffer = true })
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
