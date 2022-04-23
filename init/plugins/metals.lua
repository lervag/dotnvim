metals = require "metals"

--  Define configuration
metals_config = metals.bare_config()
metals_config.init_options.statusBarProvider = "on"
metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
  decorationColor = "MetalsStatus",
  -- excludedPackages = {
  --   "akka.actor.typed.javadsl",
  --   "com.github.swagger.akka.javadsl"
  -- },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end


-- Autocommand for scala files
local group_id = vim.api.nvim_create_augroup("init_metals", {})
vim.api.nvim_create_autocmd("FileType", {
  group = group_id,
  pattern = "scala",
  desc = "Set omnifunction",
  callback = function() vim.bo.omnifunc = vim.lsp.omnifunc end
})
vim.api.nvim_create_autocmd("FileType", {
  group = group_id,
  pattern = "scala,sbt",
  desc = "Initialize or attach metals",
  callback = function()
    metals.initialize_or_attach(metals_config)
  end
})


-- Specify keymaps
vim.keymap.set('n', '<leader>mi', metals.info)
vim.keymap.set('n', '<leader>mK', metals.hover_worksheet)
