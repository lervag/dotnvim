vim.pack.add { "https://github.com/nvim-mini/mini.snippets" }

local ms = require "mini.snippets"

ms.setup {
  snippets = {
    ms.gen_loader.from_file "~/.config/nvim/snippets/global.lua",
    ms.gen_loader.from_lang(),
  },
  mappings = {
    expand = "<c-u>",
    jump_next = "<c-j>",
    jump_prev = "<c-k>",
    stop = "<c-c>",
  },
}

ms.start_lsp_server { match = false }

vim.keymap.set("n", "<leader>es", function()
  local _, ctx = ms.default_prepare {}

  if #ctx.lang > 0 then
    vim.cmd.edit(string.format("~/.config/nvim/snippets/%s.lua", ctx.lang))
  else
    vim.cmd.edit "~/.config/nvim/snippets/global.lua"
  end
end)
