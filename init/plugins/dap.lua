local dap = require "dap"
local widgets = require "dap.ui.widgets"

-- Load virtual text extension
require "nvim-dap-virtual-text".setup()

-- Define sign symbols
vim.fn.sign_define({
  { text='🡆', texthl='DapSign', name = 'DapStopped', linehl='CursorLine'},
  { text='●', texthl='DapSign', name = 'DapBreakpoint'},
  { text='', texthl='DapSign', name = 'DapBreakpointCondition'},
  { text='▪', texthl='DapSign', name = 'DapBreakpointRejected'},
  { text='◉', texthl='DapSign', name = 'DapLogPoint'},
})

dap.listeners.before['event_terminated']['my-plugin'] = function(session, body)
  print('Session terminated', vim.inspect(session), vim.inspect(body))
end

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
  vim.keymap.set('n', lhs, rhs)
end

-- NOTE: This script defines the global dap configuration. Adapters and
--       configurations are defined either through plugins or under ftplugin.
--       I can easily find the relevant files by searching for e.g.
--       "dap.adapter" or "dap.config".
