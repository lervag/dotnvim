metals = require "metals"

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

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>mi', metals.info, opts)
vim.keymap.set('n', '<leader>mK', metals.hover_worksheet, opts)


-- Autocommand for scala files
vim.cmd([[
  augroup init_metals
    au!
    autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd FileType scala,sbt
          \ lua require('metals').initialize_or_attach(metals_config)
  augroup end
]])

-- local group = vim.api.nvim_create_augroup("init_metals", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = group,
--   pattern = "scala",
--   command = "setlocal omnifunc=v:lua.vim.lsp.omnifunc",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = group,
--   pattern = "scala,sbt,java",
--   callback = function() metals.initialize_or_attach(metals_config) end;
-- })
