local notify = require("notify")

vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
  pattern = "nvim-notify.lua",
  group = vim.api.nvim_create_augroup("init_plugins", {}),
  desc = "Reload nvim-notify when config is changed",
  callback = function()
    if vim.o.modified then
      vim.cmd [[ silent update ]]
      vim.cmd [[ Runtime! init/plugins/nvim-notify.lua ]]
      vim.notify('Updated nvim-notify', 'warn', {title = 'nvim-notify.lua'})
    end
  end
})

notify.setup {
  timeout = 3000,
  stages = {
    function(state)
      local stages_util = require("notify.stages.util")
      local next_height = state.message.height
      local next_row = stages_util.available_slot(
        state.open_windows,
        next_height,
        stages_util.DIRECTION.TOP_DOWN
      )
      if not next_row then
        return nil
      end
      return {
        relative = "editor",
        anchor = "NE",
        focusable = false,
        width = state.message.width,
        height = state.message.height,
        col = vim.opt.columns:get() - 1,
        row = next_row,
        border = { "", "" ,"", " ", " ", " ", " ", " " },
        style = "minimal",
        opacity = 0,
        noautocmd = true,
      }
    end,
    function()
      return {
        opacity = { 100 },
        col = { vim.opt.columns:get() - 1 },
      }
    end,
    function()
      return {
        col = { vim.opt.columns:get() - 1},
        time = true,
      }
    end,
    function()
      return {
        opacity = {
          0,
          frequency = 2,
          complete = function(cur_opacity)
            return cur_opacity <= 4
          end,
        },
        col = { vim.opt.columns:get() - 1 },
      }
    end,
  },
  render = function(bufnr, notif, highlights, config)
    local base = require("notify.render.base")
    local left_icon = notif.icon .. " "
    local max_message_width = math.max(unpack(vim.tbl_map(function(line)
        return vim.fn.strchars(line)
      end, notif.message)))

    local right_title = notif.title[2]
    local left_title = notif.title[1]
    local title_accum = vim.str_utfindex(left_icon)
    + vim.str_utfindex(right_title)
    + vim.str_utfindex(left_title)

    local left_buffer = string.rep(" ", math.max(0, max_message_width - title_accum))

    local namespace = base.namespace()
    vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
    vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
      virt_text = {
        { left_icon, highlights.icon },
        { left_title .. left_buffer, highlights.title },
      },
      virt_text_win_col = 0,
      priority = 10,
    })
    vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
      virt_text = { { " " }, { right_title, highlights.title } },
      virt_text_pos = "right_align",
      priority = 10,
    })
    vim.api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
      virt_text = {
        {
          string.rep(
          "─",
          math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())
          ),
          highlights.border,
        },
      },
      virt_text_win_col = 0,
      priority = 10,
    })
    vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, notif.message)

    vim.api.nvim_buf_set_extmark(bufnr, namespace, 2, 0, {
      hl_group = highlights.body,
      end_line = 1 + #notif.message,
      end_col = #notif.message[#notif.message],
      priority = 50, -- Allow treesitter to override
    })
  end
}

vim.notify = notify
