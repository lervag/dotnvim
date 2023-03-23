-- https://valentjn.github.io/ltex/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ltex

return {
  autostart = false,
  on_attach = function(_, _)
    require("ltex_extra").setup {
      load_langs = { "en-GB" },
      path = vim.fn.stdpath "config" .. "/spell",
    }
  end,
  settings = {
    ltex = {
      checkFrequency = "save",
      language = "en-GB",
      -- language = os.getenv 'PROJECT_LANG' or 'en-GB',
    },
  },
}
