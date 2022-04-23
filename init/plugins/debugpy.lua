local dap = require 'dap'
local debugpy = require 'debugpy'

local default_config = {
  justMyCode = false,
}

debugpy.run = function(config)
  dap.run(vim.tbl_extend('keep', config, default_config))
end
