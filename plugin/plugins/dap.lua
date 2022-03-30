local dap = require "dap"
local widgets = require "dap.ui.widgets"

-- Load virtual text extension
require "nvim-dap-virtual-text".setup()

-- Define sign symbols
vim.fn.sign_define('DapStopped',             {text='🡆', texthl='DapSign', linehl='CursorLine', numhl=''})
vim.fn.sign_define('DapBreakpoint',          {text='●', texthl='DapSign', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='DapSign', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected',  {text='▪', texthl='DapSign', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint',            {text='◉', texthl='DapSign', linehl='', numhl=''})

-- Define mappings
local mappings = {
  ['<leader>dd'] = dap.continue,
  ['<leader>dD'] = dap.run_last,
  ['<leader>dc'] = dap.run_to_cursor,
  ['<leader>dx'] = dap.terminate,
  ['<leader>db'] = dap.toggle_breakpoint,
  ['<leader>dB'] = function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end,
  ['<leader>dl'] = dap.list_breakpoints,
  ['<leader>dw'] = function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Watch: "))
  end,
  ['<leader>dW'] = function()
    dap.set_breakpoint(vim.fn.input("Watch condition: "), nil, vim.fn.input("Watch: "))
  end,
  ['<leader>dp'] = dap.step_back,
  ['<leader>dn'] = dap.step_over,
  ['<leader>dj'] = dap.step_into,
  ['<leader>dk'] = dap.step_out,
  ['<leader>dK'] = dap.up,
  ['<leader>dJ'] = dap.down,
  ['<leader>dr'] = dap.repl.toggle,
  ['<leader>dh'] = widgets.hover,
  ['<leader>dF'] = function()
    widgets.centered_float(widgets.frames)
  end,
  ['<leader>dL'] = function()
    widgets.centered_float(widgets.scopes)
  end,
  ['<leader>dR'] = function()
    local filename = debug.getinfo(1, 'S').source:sub(2)
    vim.cmd("luafile " .. filename)
  end,
}

for lhs, rhs in pairs(mappings) do
  vim.keymap.set('n', lhs, rhs, { noremap=true, silent=true })
end

dap.listeners.before['event_terminated']['my-plugin'] = function(session, body)
  print('Session terminated', vim.inspect(session), vim.inspect(body))
end


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
