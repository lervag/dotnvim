local notify = require("notify")
notify.setup {
  stages = "fade",
  timeout = 4000
}

vim.notify = notify
