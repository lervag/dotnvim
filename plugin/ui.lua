vim.ui.input = function(opts, on_confirm)
  local buf = vim.api.nvim_create_buf(false, false)
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].bufhidden = "wipe"

  local mapopts = { silent = true, buffer = buf }
  vim.keymap.set({ "i", "n" }, "<cr>", "<cr><esc><cmd>close!<cr>", mapopts)
  vim.keymap.set("n", "<esc>", "<cmd>close!<cr>", mapopts)
  vim.keymap.set("n", "q", "<cmd>close!<cr>", mapopts)

  local prompt = opts.prompt or ""
  local default_text = opts.default or ""

  -- Set prompt and callback for prompt buffer
  vim.fn.prompt_setprompt(buf, prompt)
  vim.fn.prompt_setcallback(buf, function(input)
    vim.defer_fn(function() on_confirm(input) end, 10)
  end)

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = #default_text + #prompt + 5,
    height = 1,
    focusable = true,
    style = "minimal",
    border = "solid",
  })
  vim.api.nvim_win_set_option(win, "winhighlight", "Search:None")

  -- Set the default text (needs to be deferred after the prompt is drawn)
  vim.cmd("startinsert")
  vim.defer_fn(function()
    vim.api.nvim_buf_set_text(buf, 0, #prompt, 0, #prompt, { default_text })
    vim.cmd("startinsert!") -- bang: go to end of line
  end, 5)
end
