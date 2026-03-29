vim.pack.add {
  { src = "https://github.com/mistweaverco/kulala.nvim", version = "develop" },
}

require("kulala").setup {
  global_keymaps = true,
  ui = {
    win_opts = {
      wo = {
        foldmethod = "expr",
        foldexpr = "v:lua.vim.treesitter.foldexpr()",
        foldlevel = 99,
      },
    },
  },
}

-- Disable matchup in Kulala UI, because matchup glitches the UI and
-- closes it.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("init_kulala", {}),
  pattern = "json.kulala_ui",
  callback = function()
    vim.fn["matchup#matchparen#toggle"](0)
  end,
})
