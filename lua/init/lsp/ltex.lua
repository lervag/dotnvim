-- https://valentjn.github.io/ltex/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ltex

-- local path = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'
-- local words = {}

-- for word in io.open(path, 'r'):lines() do
--   table.insert(words, word)
-- end

return {
  settings = {
    ltex = {
      enabled = { "latex" },
      checkFrequency="save",
      language = "en-GB",
      disabledRules = {
        ["en-US"] = { "PROFANITY" },
        ["en-GB"] = { "PROFANITY" },
      },
      -- dictionary = {
      --   ["en-US"] = words,
      --   ["en-GB"] = words,
      -- },
    },
  },
}
