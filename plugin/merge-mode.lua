local function setup(this, all)
  if not vim.wo.diff then return end

  vim.keymap.set("n", "[[", "[c", { buffer = true })
  vim.keymap.set("n", "]]", "]c", { buffer = true })
  vim.keymap.set("n", "Q", "<cmd>xa!<cr>", { buffer = true, silent = true, nowait = true })
  vim.keymap.set("n", "<c-q>", "<cmd>xa!<cr>", { buffer = true, silent = true, nowait = true })

  if this.version == "current" then
    vim.keymap.set("n", "do", "", { buffer = true })

    local get_mine = ":diffget " .. all.mine.bufid .. "<cr>"
    vim.keymap.set({"n", "x"}, "dol", get_mine, { buffer = true, silent = true })
    vim.keymap.set({"n", "x"}, "do1", get_mine, { buffer = true, silent = true })

    local get_other = ":diffget " .. all.other.bufid .. "<cr>"
    vim.keymap.set({"n", "x"}, "dor", get_other, { buffer = true, silent = true })
    vim.keymap.set({"n", "x"}, "do3", get_other, { buffer = true, silent = true })
  else
    vim.bo.swapfile = false
    vim.bo.modifiable = false

    vim.keymap.set("n", "u", function()
      vim.api.nvim_win_call(all.current.winid, function() vim.cmd.normal { "u", bang = true } end)
    end, { buffer = true })
    vim.keymap.set("n", "<c-r>", function()
      local keys = vim.api.nvim_replace_termcodes("<c-r>", true, false, true)
      vim.api.nvim_win_call(all.current.winid, function() vim.cmd.normal { keys, bang = true } end)
    end, { buffer = true })

    local cmd = ":diffput " .. all.current.bufid .. "<cr>"
    vim.keymap.set({"n", "x"}, "dp", cmd, { buffer = true, silent = true })
  end
end

local function setup_merge_mode()
  local winids = vim.api.nvim_list_wins()

  local all = {}
  local windows = {}

  for _, winid in ipairs(winids) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    local name = vim.api.nvim_buf_get_name(bufid)
    local object = {
      winid = winid,
      bufid = bufid,
      bufname = name
    }

    if name:match('_LOCAL_') then
      object.version = "mine"
    elseif name:match('_REMOTE_') then
      object.version = "other"
    else
      object.version = "current"
    end

    windows[winid] = object
    all[object.version] = object
  end

  for _, winid in ipairs(winids) do
    vim.api.nvim_win_call(winid, function() setup(windows[winid], all) end)
  end

  vim.api.nvim_set_current_win(all.current.winid)
  vim.api.nvim_win_set_cursor(all.current.winid, { 1, 1 })
  vim.cmd.wincmd "J"
  vim.cmd.normal { "]c[c", bang = true }
end

vim.api.nvim_create_user_command("MergeMode", setup_merge_mode, {})
