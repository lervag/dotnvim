-- See also ~/.config/nvim/ftplugin/tex.lua

vim.g.vimtex_compiler_silent = 1
vim.g.vimtex_complete_bib = {
  simple = 1,
  menu_fmt = "@year, @author_short, @title",
}
vim.g.vimtex_context_pdf_viewer = "zathura"
vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }
vim.g.vimtex_fold_types = {
  markers = { enabled = 0 },
  sections = { parse_levels = 1 },
}
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_imaps_leader = "¨"
vim.g.vimtex_imaps_list = {
  {
    lhs = "ii",
    rhs = "\\item ",
    leader = "",
    wrapper = "vimtex#imaps#wrap_environment",
    context = { "itemize", "enumerate", "description" },
  },
  { lhs = ".", rhs = "\\cdot" },
  { lhs = "*", rhs = "\\times" },
  { lhs = "a", rhs = "\\alpha" },
  { lhs = "r", rhs = "\\rho" },
  { lhs = "p", rhs = "\\varphi" },
}
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_quickfix_ignore_filters = { "Generic hook" }
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.vimtex_toc_config = {
  split_pos = "full",
  mode = 2,
  fold_enable = 1,
  show_help = 0,
  hotkeys_enabled = 1,
  hotkeys_leader = "",
  refresh_always = 0,
}
vim.g.vimtex_view_automatic = 0
vim.g.vimtex_view_forward_search_on_start = 0
vim.g.vimtex_view_method = "zathura"

vim.g.vimtex_grammar_vlty = {
  lt_command = "languagetool",
  show_suggestions = 1,
}

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("init_vimtex", {}),
  pattern = "VimtexEventViewReverse",
  desc = "VimTeX: Center view on inverse search",
  command = [[ normal! zMzvzz ]],
})

vim.pack.add { "https://github.com/lervag/vimtex" }
