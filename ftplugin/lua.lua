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



if vim.fn.expand("%:p"):match "init/packages%.lua$" then
  vim.wo.foldlevel = 1
  vim.wo.foldtext = 'v:lua.require("lervag.init.ftlua").foldtext_packages()'
end
