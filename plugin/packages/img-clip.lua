vim.pack.add { "https://github.com/HakonHarnes/img-clip.nvim" }

require("img-clip").setup {
  filetypes = {
    wiki = {
      template = "![$CURSOR]($FILE_PATH)",
      dir_path = "aux",
    },
  },
  files = {
    ["/home/lervag/notes.md"] = {
      dir_path = "/home/lervag/documents/anki/lervag/collection.media/",
      template = "![$FILE_NAME_NO_EXT]($FILE_NAME)",
    },
  },
  custom = {
    {
      -- For apy edit notes
      trigger = function() -- returns true to enable
        return vim.fn.bufname():match "^edit_node_.+%.md"
      end,
      dir_path = "/home/lervag/documents/anki/lervag/collection.media/",
      template = "![$FILE_NAME_NO_EXT]($FILE_NAME)",
    },
  },
}

vim.keymap.set("n", "<leader>ep", "<cmd>PasteImage<cr>")
