local M = {}

function M.init_metals()
  metals = require "metals"

  --  Define configuration
  metals_config = metals.bare_config()
  metals_config.tvp = {
    icons = { enabled = true },
  }
  metals_config.init_options.statusBarProvider = "on"
  metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    decorationColor = "DiagnosticVirtualTextHint",
    -- excludedPackages = {
    --   "akka.actor.typed.javadsl",
    --   "com.github.swagger.akka.javadsl"
    -- },
  }

  metals_config.on_attach = function(_, _)
    metals.setup_dap()

    vim.keymap.set("v", "K", require("metals").type_of_range)
    vim.keymap.set("n", "<leader>mm", metals.commands)
    vim.keymap.set("n", "<leader>mk", metals.hover_worksheet)
    vim.keymap.set("n", "<leader>mt", require("metals.tvp").toggle_tree_view)
  end

  metals.initialize_or_attach(metals_config)
end

return M
