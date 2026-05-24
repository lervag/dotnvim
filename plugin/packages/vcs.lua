-- See also:
-- * ftplugin/fugitive.vim
-- * ftplugin/git.vim
-- * ftplugin/gitcommit.vim
-- * ftplugin/floggraph.vim

vim.g.loaded_rhubarb = 1
vim.g.loaded_fugitive_gitlab = 1
vim.g.fugitive_browse_handlers = {
  vim.fn["rhubarb#FugitiveUrl"],
  vim.fn["gitlab#fugitive#handler"],
}

vim.g.diffs = {
  integrations = {
    fugitive = true,
  },
}
vim.g.flog_enable_dynamic_commit_hl = true
vim.g.flog_enable_extended_chars = true
vim.g.flog_default_opts = {
  format = "%h %cs %s%d",
  date = "format:%Y-%m-%d %H:%M",
}

vim.g.rooter_patterns =
  { ".git", ".hg", ".bzr", ".svn", "build.sbt", "pyproject.toml" }
vim.g.rooter_silent_chdir = 1

require("lervag.util").load_delayed(function()
  vim.pack.add {
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-rhubarb",
    "https://github.com/shumphrey/fugitive-gitlab.vim",
    "https://github.com/barrettruth/diffs.nvim",
    "https://github.com/nvim-mini/mini.diff",
    "https://github.com/rbong/vim-flog",
    "https://github.com/airblade/vim-rooter",
  }

  local group = vim.api.nvim_create_augroup("init_vcs", {})
  local minidiff = require "mini.diff"

  minidiff.setup {
    view = {
      signs = { add = "▕▏", change = "▕▏", delete = "▁▁" },
    },
  }

  vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    pattern = "index",
    desc = "Fugitive: reload status",
    callback = function()
      vim.fn["fugitive#ReloadStatus"](-1, 0)
    end,
  })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    pattern = "fugitive://",
    desc = "Fugitive: hidden fugitive buffers",
    callback = function()
      vim.bo.bufhidden = "delete"
    end,
  })

  vim.keymap.set("n", "<leader>gs", function()
    require("lervag.util.git").toggle_fugitive()
  end)
  vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>")
  vim.keymap.set({ "n", "x" }, "<leader>gb", ":GBrowse<cr>")
  vim.keymap.set("n", "yod", function()
    require("mini.diff").toggle_overlay(0)
  end, { desc = "Toggle diff overlay" })
  vim.keymap.set("n", "<leader>gl", function()
    local branch = vim.fn.FugitiveHead()
    local branch_origin = "origin/" .. branch
    if pcall(vim.fn["fugitive#RevParse"], branch_origin) then
      branch_origin = " " .. branch_origin
    else
      branch_origin = ""
    end
    vim.cmd("Flog -- HEAD " .. branch .. branch_origin)
  end)
end, 50)
