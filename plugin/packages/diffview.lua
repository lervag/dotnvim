require("lervag.util").load_delayed(function()
  vim.pack.add { "https://github.com/dlyongemallo/diffview-plus.nvim" }

  local diffview = require "diffview"
  local actions = require "diffview.actions"
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
      cycle_layouts = {
        default = { "diff2_horizontal", "diff1_inline" },
        merge_tool = {
          "diff3_horizontal",
          "diff3_vertical",
          "diff3_mixed",
          "diff4_mixed",
          "diff1_plain",
        },
      },
      inline = {
        deletion_highlight = "full_width",
      },
    },
    -- See defaults here:
    -- ~/.local/share/nvim/site/pack/core/opt/diffview-plus.nvim/lua/diffview/config.lua:120
    keymaps = {
      file_panel = {
        { "n", "<leader>e", false },
        { "n", "g<c-x>", false },
        { "n", "<leader>eq", quit_diffview, { desc = "Exit diffview" } },
        {
          "n",
          "<leader>ec",
          actions.cycle_layout,
          { desc = "Cycle available layouts" },
        },
      },
      file_history_panel = {
        { "n", "<leader>e", false },
        { "n", "g<c-x>", false },
        { "n", "<leader>eq", quit_diffview, { desc = "Exit diffview" } },
        {
          "n",
          "<leader>ec",
          actions.cycle_layout,
          { desc = "Cycle available layouts" },
        },
      },
      view = {
        { "n", "<leader>e", false },
        { "n", "g<c-x>", false },
        { "n", "<leader>eq", quit_diffview, { desc = "Exit diffview" } },
        {
          "n",
          "<leader>ec",
          actions.cycle_layout,
          { desc = "Cycle available layouts" },
        },
        {
          "n",
          "<leader>ee",
          actions.toggle_stage_entry,
          { desc = "Toggle stage entry" },
        },
      },
    },
  }

  vim.keymap.set(
    "n",
    "<leader>gL",
    "<cmd>DiffviewFileHistory %<cr>",
    { silent = true }
  )
  vim.keymap.set(
    "x",
    "<leader>gL",
    ":DiffviewFileHistory<cr>",
    { silent = true }
  )

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

vim.api.nvim_create_user_command("MergeMode", function(opts)
  vim.defer_fn(function()
    vim.g.mergemode = 1
    vim.cmd("DiffviewOpen " .. opts.args)
    vim.cmd "tabonly"
  end, 50)
end, { nargs = "*", desc = "Open diffview after 100ms delay" })
