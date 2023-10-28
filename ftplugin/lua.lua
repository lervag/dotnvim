local dap = require "dap"

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = vim.api.nvim_get_current_buf(),
  group = vim.api.nvim_create_augroup("init_lua", {}),
  callback = function(arg)
    if arg.file:sub(1, 10) == "fugitive:/" then
      return
    end

    vim.lsp.buf.format {
      filter = function(client)
        return client.name == "null-ls"
      end,
      bufnr = arg.buf,
    }
  end,
})

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
    port = function()
      local val = tonumber(vim.fn.input "Port: ")
      assert(val, "Please provide a port number")
      return val
    end,
  },
}
