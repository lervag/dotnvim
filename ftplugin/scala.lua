local dap = require "dap"

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- For more info, see
-- :help metals-nvim-dap
dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run the main method",
    metals = {
      runType = "run",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Run or test current file",
    metals = {
      runType = "runOrTestFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test current target",
    metals = {
      runType = "testTarget",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Run or test current file with input",
    metals = {
      runType = "runOrTestFile",
      args = function()
        local args_string = vim.fn.input "Arguments: "
        return vim.split(args_string, " +")
      end,
    },
  },
}

dap.listeners.after["event_terminated"]["nvim-metals"] = function(_, _)
  dap.repl.open()
end
