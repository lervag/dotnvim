vim.g.lists_filetypes = { "md", "wiki", "txt" }

vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_follow_anchor = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_toml_frontmatter = 1
vim.g.vim_markdown_new_list_item_indent = 2
vim.g.vim_markdown_no_extensions_in_markdown = 1
vim.g.vim_markdown_no_default_key_mappings = 1
vim.g.vim_markdown_conceal = 2
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_strikethrough = 1

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "tree-sitter-d2" and ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd "tree-sitter-d2"
      end
      vim.system({ "make", "nvim-install" }, { cwd = ev.data.path })
    end
  end,
})

vim.pack.add {
  "https://github.com/chunkhang/vim-mbsync",
  "https://github.com/darvelo/vim-systemd",
  "https://github.com/hat0uma/csvview.nvim",
  "https://github.com/lervag/lists.vim",
  "https://github.com/preservim/vim-markdown",
  "https://github.com/ravsii/tree-sitter-d2",
  "https://github.com/scalameta/nvim-metals",
  "https://github.com/terrastruct/d2-vim",
  "https://github.com/tpope/vim-apathy",
  "https://github.com/tridactyl/vim-tridactyl",
  "https://github.com/yorickpeterse/nvim-pqf",
}

require("pqf").setup {
  show_multiple_lines = true,
  signs = {
    error = { text = "", hl = "DiagnosticSignError" },
    warning = { text = "", hl = "DiagnosticSignWarn" },
    info = { text = "", hl = "DiagnosticSignInfo" },
    hint = { text = "", hl = "DiagnosticSignHint" },
  },
}

require("csvview").setup {
  parser = { comments = { "#", "//" } },
  keymaps = {
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
  },
  view = {
    display_mode = "border",
  },
}
