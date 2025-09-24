--- Calculate the target width
---@return int
local function get_target_width()
  local heights = vim.iter(vim.split(vim.fn.winrestcmd(), "|"))
  heights:filter(function(part)
    return part:match "^:?%d"
  end)
  heights:map(function(part)
    return tonumber(part:match "%d+$") or 0
  end)

  local total_height = heights:fold(0, function(acc, v)
    return acc + v
  end) / 2

  local count = math.ceil(total_height / vim.o.lines)
  return count * 82 + count - 1
end

--- Convert a buffer name to the corresponding bufnr
---@param buffer_name string
---@return integer
local function str2bufnr(buffer_name)
  if buffer_name == "" then
    return vim.fn.bufnr "%"
  elseif buffer_name:match "^%d+$" then
    return vim.fn.bufnr(math.floor(tonumber(buffer_name) or 0))
  else
    return vim.fn.bufnr(buffer_name)
  end
end

---@class WindowsModule
---Window management utilities
local M = {}

--- Remove all windows except current and wipe hidden unchanged buffers
function M.only()
  vim.cmd "silent! wincmd o"

  for _, buf_info in ipairs(vim.fn.getbufinfo()) do
    if buf_info.hidden == 1 and buf_info.changed == 0 then
      vim.cmd("bwipeout " .. buf_info.bufnr)
    end
  end
end

--- Resize windows based on available width
function M.resize()
  local target_width = get_target_width()
  if target_width == vim.o.columns then
    return
  end

  local tmux = vim.env.TMUX or ""
  local sty = vim.env.STY or ""
  local wezterm = vim.env.WEZTERM_UNIX_SOCKET or ""

  if vim.env.KITTY_PID then
    local winid = vim.fn.systemlist("xdotool getactivewindow")[1]
    vim.fn.system(
      string.format("kitten @ resize-os-window --self --width %d", target_width)
    )
    vim.fn.system(string.format('xdotool key --window %s "super+c"', winid))
    vim.cmd "sleep 100m"
  elseif tmux == "" and sty == "" and wezterm == "" then
    vim.o.columns = target_width
    vim.fn.system 'xdotool key "super+c"'
  else
    local winid = vim.fn.systemlist("xdotool getactivewindow")[1]
    vim.fn.system(
      string.format(
        "xdotool windowsize --usehints %s %d %d",
        winid,
        target_width,
        vim.o.lines + 1
      )
    )
    vim.fn.system(string.format('xdotool key --window %s "super+c"', winid))
    vim.cmd "sleep 100m"
  end

  vim.cmd "wincmd ="
  -- vim.cmd "redraw!"
end

--- Smart buffer delete that does not close any windows
---
---@param is_bang? boolean
---@param buffer_name? string
function M.buf_delete(is_bang, buffer_name)
  vim.w.buf_delete_marked = 1

  local bang = is_bang and "!" or ""
  local bufnr = str2bufnr(buffer_name or "")

  if bufnr < 0 then
    vim.notify(
      "No buffers were deleted. No match for " .. (buffer_name or "N/A"),
      vim.log.levels.WARN
    )
    return
  end

  if vim.bo[bufnr].modified then
    if is_bang then
      -- If the buffer is set to delete and it contains changes, we can't
      -- switch away from it. Hide it before eventual deleting:
      vim.bo[bufnr].bufhidden = "hide"
    else
      vim.notify(
        "E89: No write since last change for buffer "
          .. bufnr
          .. " (add ! to override)",
        vim.log.levels.WARN
      )
      return
    end
  end

  -- Process all windows containing this buffer
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
   if vim.api.nvim_win_get_buf(winid) == bufnr then
      vim.api.nvim_set_current_win(winid)

      -- Try to switch to alternate buffer or previous buffer
      local alt_buf = vim.fn.bufnr "#"
      if alt_buf > 0 and vim.bo[alt_buf].buflisted then
        vim.cmd "buffer #"
      else
        vim.cmd "bprevious"
      end

      -- Create new buffer if still on the same buffer
      if vim.fn.bufnr "%" == bufnr then
        vim.cmd("enew" .. bang)
        vim.bo.swapfile = false
        vim.bo.bufhidden = "wipe"
        vim.bo.buftype = ""
        vim.bo.buflisted = false
      end
    end
  end

  ---@type int?
  local winnr_back = nil
  for i = 1, vim.fn.winnr "$" do
    if vim.fn.getwinvar(i, "buf_delete_marked") ~= "" then
      winnr_back = i
      break
    end
  end

  if winnr_back then
    vim.cmd(winnr_back .. "wincmd w")
    vim.w.buf_delete_marked = nil
  end

  -- Delete the buffer if it still exists
  if
    vim.api.nvim_buf_is_valid(bufnr)
    and bufnr ~= vim.api.nvim_get_current_buf()
  then
    vim.cmd("bdelete" .. bang .. " " .. bufnr)
  end
end

return M
