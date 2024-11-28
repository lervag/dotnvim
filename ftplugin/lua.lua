vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

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
