require 'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "latex" },
  highlight = {
    enable = true,
    disable = { "vim", "markdown", "bibtex", "make" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<cr>',
      scope_incremental = '<cr>',
      node_incremental = '<tab>',
      node_decremental = '<s-tab>',
    },
  },
  matchup = {
    enable = true,
  }
}
