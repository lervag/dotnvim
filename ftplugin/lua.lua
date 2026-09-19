vim.keymap.set("n", "<leader>dl", function()
  vim.pack.add { "https://github.com/jbyuki/one-small-step-for-vimkind" }
  require("osv").launch { port = 8086 }
end, { desc = "Launch OSV server" })

local dap = require "dap"

-- Adapters
dap.adapters.nlua = function(callback, config)
  callback {
    type = "server",
    host = "127.0.0.1",
    port = config.port,
  }
end

-- Configurations
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    port = 8086,
  },
}

if not vim.wo.diff then
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = vim.treesitter.foldexpr
end
