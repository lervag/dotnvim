local root = vim.env.HOME .. "/.local/plugged"

local lazypath = root .. "/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  root = root,
  spec = { { import = "lervag.init.packages" } },
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
  install = {
    colorscheme = { "solarized_custom" },
  },
  dev = {
    path = root,
    fallback = true,
  },
  git = {
    log = { "--since=7 days ago" },
  },
  ui = {
    size = { width = 1.0, height = 0.95 },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

require("lazy.view.config").keys.profile_filter = "F"

vim.keymap.set("n", "<leader>pp", "<cmd>Lazy<cr>")
vim.keymap.set("n", "<leader>pu", "<cmd>Lazy sync<cr>")
