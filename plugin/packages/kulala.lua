require("lervag.util").load_on_ft(
  { "http", "rest", "javascript", "lua" },
  function()
    vim.pack.add { "https://github.com/mistweaverco/kulala.nvim" }

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
  end
)
