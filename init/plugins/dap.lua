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

local mappings = {
  ['<leader>dd'] = dap.continue,
  ['<leader>dD'] = dap.run_last,
  ['<leader>dc'] = dap.run_to_cursor,
  ['<leader>dx'] = dap.terminate,
  ['<leader>dp'] = dap.step_back,
  ['<leader>dn'] = dap.step_over,
  ['<leader>dj'] = dap.step_into,
  ['<leader>dk'] = dap.step_out,

  ['<leader>dl'] = function()
    dap.list_breakpoints()
    vim.cmd [[ :copen ]]
  end,
  ['<leader>db'] = dap.toggle_breakpoint,
  ['<leader>dB'] = function()
    vim.ui.input({ prompt = "Breakpoint condition: " },
    function(condition)
      dap.set_breakpoint(condition)
    end)
  end,

  ['<leader>dw'] = function()
    vim.ui.input({ prompt = "Watch: " },
    function(watch)
      dap.set_breakpoint(nil, nil, watch)
    end)
  end,
  ['<leader>dW'] = function()
    vim.ui.input({ prompt = "Watch condition: " },
    function(condition)
      vim.ui.input({ prompt = "Watch: " },
      function(watch)
        dap.set_breakpoint(condition, nil, watch)
      end)
    end)
  end,

  ['<leader>dK'] = dap.up,
  ['<leader>dJ'] = dap.down,
  ['<leader>dr'] = dap.repl.toggle,
  ['<leader>dh'] = widgets.hover,
  ['<leader>dH'] = function()
    vim.ui.input({ prompt = "Evaluate: " },
    function(expr)
      widgets.hover(expr)
    end)
  end,
  ['<leader>dF'] = function()
    widgets.centered_float(widgets.frames)
  end,
  ['<leader>dL'] = function()
    widgets.centered_float(widgets.scopes)
  end,
}

for lhs, rhs in pairs(mappings) do
  vim.keymap.set('n', lhs, rhs)
end

-- NOTE: This script defines the global dap configuration. Adapters and
--       configurations are defined elsewhere. Assuming I remember to update
--       the following list, these are the relevant files:
--
--       Python
--         ~/.config/nvim/init/plugins/debugpy.lua
--         ~/.config/nvim/ftplugin/python.lua
--
--       Scala:
--         ~/.config/nvim/ftplugin/scala.lua
--
--       Lua:
--         ~/.config/nvim/ftplugin/lua.lua
