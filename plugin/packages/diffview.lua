require("lervag.util").load_delayed(function()
  vim.pack.add { "https://github.com/sindrets/diffview.nvim" }

  local diffview = require "diffview"
  local group = vim.api.nvim_create_augroup("init_diffview", {})
  local my_border = require("lervag.const").border

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
end, 25)
