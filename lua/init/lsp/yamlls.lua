-- https://github.com/redhat-developer/yaml-language-server
-- This may be useful:
--   https://github.com/someone-stole-my-name/yaml-companion.nvim
--   https://www.reddit.com/r/neovim/comments/ur6u3g/yamlcompanionnvim_get_set_and_autodetect_yaml/
return {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      validate = true,
      format = { enable = true },
      hover = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemaDownload = { enable = true },
      schemas = {},
      trace = { server = "debug" },
    },
  },
}
