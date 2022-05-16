local dap = require "dap"

-- Adapters
dap.adapters.nlua = function(callback, config)
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = config.port
  })
end

-- Configurations
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, "Please provide a port number")
      return val
    end,
  }
}
