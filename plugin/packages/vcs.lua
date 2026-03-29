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

vim.pack.add {
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
  "https://github.com/shumphrey/fugitive-gitlab.vim",
  "https://github.com/barrettruth/diffs.nvim",
  "https://github.com/nvim-mini/mini.diff",
  "https://github.com/rbong/vim-flog",
  "https://github.com/airblade/vim-rooter",
  "https://github.com/sindrets/diffview.nvim",
}

local my_border = require("lervag.const").border
local minidiff = require "mini.diff"
local diffview = require "diffview"

minidiff.setup {
  view = {
    signs = { add = "▕▏", change = "▕▏", delete = "▁▁" },
  },
}

local quit_diffview = function()
  if vim.g.mergemode then
    vim.cmd "quitall!"
  else
    diffview.close()
  end
end

diffview.setup {
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
    file_history = {
      disable_diagnostics = true,
    },
  },
  -- See defaults here:
  -- ~/.local/share/nvim/site/pack/core/opt/diffview.nvim/lua/diffview/config.lua:120
  keymaps = {
    file_panel = {
      ["<leader>e"] = false,
      ["<leader>eq"] = quit_diffview,
    },
    file_history_panel = {
      ["<leader>e"] = false,
      ["<leader>eq"] = quit_diffview,
    },
    view = {
      ["<leader>e"] = false,
      ["<leader>eq"] = quit_diffview,
      ["<leader>ee"] = function()
        diffview.emit "toggle_stage_entry"
      end,
    },
  },
}

local group = vim.api.nvim_create_augroup("init_git", {})

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

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = group,
  pattern = "diffview:///panels/*",
  callback = function()
    if vim.api.nvim_win_get_config(0).zindex then
      vim.api.nvim_win_set_config(0, {
        border = my_border,
      })
    end
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
vim.keymap.set(
  "n",
  "<leader>gL",
  "<cmd>DiffviewFileHistory %<cr>",
  { silent = true }
)
vim.keymap.set("x", "<leader>gL", ":DiffviewFileHistory<cr>", { silent = true })
