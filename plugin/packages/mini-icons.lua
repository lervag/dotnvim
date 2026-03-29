vim.pack.add { "https://github.com/nvim-mini/mini.icons" }

require("mini.icons").setup {
  lsp = {
    snippet = {
      glyph = "",
    },
  },
}

package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end
