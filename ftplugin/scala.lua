require("lervag.util.metals").init_metals()

require("dap").configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run or test",
    metals = {
      runType = "runOrTestFile",
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
