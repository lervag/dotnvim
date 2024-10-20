local dap = require "dap"

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run or test",
    metals = {
      runType = "runOrTestFile",
      -- Andre mulige opsjoner:
      -- args = { "foo", "bar" },
      -- jvmOptions = { "-Dpropert=123" },
      -- env = { "RETRY" = "TRUE" },
      -- envFile = ".env"
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Run or test with input",
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
