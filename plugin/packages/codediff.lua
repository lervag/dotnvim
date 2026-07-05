require("lervag.util").load_delayed(function()
  vim.pack.add { "https://github.com/esmuellert/codediff.nvim" }

  require("codediff").setup {
    explorer = {
      view_mode = "tree",
    },
    keymaps = {
      view = {
        next_file = "<tab>",
        prev_file = "<s-tab>",
      },
    },
  }

  vim.keymap.set(
    "n",
    "<leader>gL",
    "<cmd>CodeDiff history %<cr>",
    { silent = true }
  )
  vim.keymap.set("x", "<leader>gL", ":CodeDiff history<cr>", { silent = true })
end, 50)

vim.api.nvim_create_user_command("MergeMode", function(opts)
  vim.defer_fn(function()
    vim.g.mergemode = 1
    vim.cmd("CodeDiff merge " .. opts.args)
    vim.defer_fn(function()
      vim.cmd "tabonly"
    end, 50)
  end, 25)
end, { nargs = "*", desc = "Open CodeDiff with a small delay" })
