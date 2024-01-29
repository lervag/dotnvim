local M = {}

function M.layout(picker)
  local Layout = require "telescope.pickers.layout"
  local function create_window(enter, width, height, row, col, title)
    local config = {
      style = "minimal",
      relative = "win",
      width = width,
      height = height,
      row = row,
      col = col,
      border = require("lervag.const").border,
    }

    if title then
      config.title = " " .. title .. " "
      config.title_pos = "left"
    end

    local bufnr = vim.api.nvim_create_buf(false, true)
    local winid = vim.api.nvim_open_win(bufnr, enter, config)

    return Layout.Window {
      bufnr = bufnr,
      winid = winid,
    }
  end

  local function destory_window(window)
    if window then
      if vim.api.nvim_win_is_valid(window.winid) then
        vim.api.nvim_win_close(window.winid, true)
      end
      if vim.api.nvim_buf_is_valid(window.bufnr) then
        vim.api.nvim_buf_delete(window.bufnr, { force = true })
      end
    end
  end

  return Layout {
    picker = picker,
    mount = function(self)
      local width = vim.fn.winwidth(0) - 2
      local height = vim.fn.winheight(0) - 4
      self.prompt = create_window(true, width, 1, 0, 0, picker.prompt_title)
      self.results = create_window(false, width, height, 2, 0)
    end,
    unmount = function(self)
      destory_window(self.results)
      destory_window(self.prompt)
    end,
    update = function() end,
  }
end

return M
