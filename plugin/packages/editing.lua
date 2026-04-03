vim.g.inline_edit_proxy_type = "tempfile"
vim.g.inline_edit_modify_statusline = 0
vim.g.inline_edit_patterns = {
  {
    main_filetype = "wiki",
    callback = "inline_edit#MarkdownFencedCode",
  },
  {
    main_filetype = "hurl",
    callback = "inline_edit#MarkdownFencedCode",
  },
  {
    main_filetype = "scala",
    sub_filetype = "sql",
    indent_adjustment = 1,
    include_margins = 1,
    start = [[\(sql\|SQL\)"""]],
    ["end"] = [["""]],
  },
}

vim.pack.add {
  "https://github.com/AndrewRadev/inline_edit.vim",
  "https://github.com/AndrewRadev/linediff.vim",
  "https://github.com/Wansmer/treesj",
  "https://github.com/dhruvasagar/vim-table-mode",
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-mini/mini.operators",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/sQVe/sort.nvim",
  "https://github.com/tpope/vim-repeat",
}

vim.g.table_mode_auto_align = 0
vim.g.table_mode_corner = "|"

require("mini.ai").setup()

require("mini.operators").setup {
  exchange = { prefix = "ge" },
  multiply = { prefix = "" },
  replace = { prefix = "" },
  sort = { prefix = "" },
}

---@diagnostic disable-next-line: undefined-field
require("sort").setup()

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("init_linediff", {}),
  pattern = "LinediffBufferReady",
  desc = "Linediff buffer ready",
  command = [[ nnoremap <buffer> <leader>eq :LinediffReset<cr> ]],
})

vim.keymap.set("n", "sas", "saiW", { remap = true })

vim.keymap.set("n", "gS", function()
  require("treesj").toggle()
end)

vim.keymap.set("n", "<leader>ee", "<cmd>InlineEdit<cr>")
vim.keymap.set("x", "<leader>ee", ":InlineEdit ")

vim.keymap.set("x", "<leader>ed", ":Linediff<cr> ")
vim.keymap.set("n", "<leader>ed", "<plug>(linediff-operator)")

require("lervag.util").load_delayed(function()
  local catchall = {
    { "%b()", "^.().*().$" },
    { "%b[]", "^.().*().$" },
    { "%b{}", "^.().*().$" },
    { "'.-'", "^.().*().$" },
    { '".-"', "^.().*().$" },
    { "`.-`", "^.().*().$" },
  }

  require("mini.surround").setup {
    custom_surroundings = {
      d = { input = catchall },
      r = { input = catchall },
    },
    n_lines = 50,
  }

  require("treesj").setup {
    use_default_keymaps = false,
  }
end)
