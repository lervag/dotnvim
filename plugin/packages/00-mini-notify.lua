vim.pack.add { "https://github.com/nvim-mini/mini.notify" }

local mininotify = require "mini.notify"

mininotify.setup {
  content = {
    format = function(notif)
      return " " .. notif.msg
    end,
    sort = function(notif_arr)
      local res, present_msg = {}, {}
      for _, notif in ipairs(notif_arr) do
        if not present_msg[notif.msg] then
          table.insert(res, notif)
          present_msg[notif.msg] = true
        end
      end
      return mininotify.default_sort(res)
    end,
  },

  lsp_progress = {
    enable = true,
    duration_last = 3000,
  },

  window = {
    config = function(buf_id)
      local line_widths = vim.tbl_map(
        vim.fn.strdisplaywidth,
        vim.api.nvim_buf_get_lines(buf_id, 0, -1, true)
      )
      local width = 15
      for _, l_w in ipairs(line_widths) do
        width = math.max(width, l_w)
      end

      local height = 0
      for _, l_w in ipairs(line_widths) do
        height = height + math.floor(math.max(l_w - 1, 0) / width) + 1
      end

      return {
        row = 1,
        width = math.min(width + 1, math.floor(0.8 * vim.o.columns)),
        height = height,
        border = { "┏", " ", " ", " ", " ", " ", "┗", "┃" },
        title = "NOTIFICATIONS",
        title_pos = "right",
      }
    end,
    winblend = 0,
  },
}

vim.keymap.set("n", "<leader>n", mininotify.show_history)

vim.notify = mininotify.make_notify()
