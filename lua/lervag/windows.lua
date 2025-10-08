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

return M
