-- NOTE: This script defines the global dap configuration. Adapters and
-- configurations are defined elsewhere. Assuming I remember to update the
-- following list, these are the relevant files:
--
-- Java:
--   ~/.config/nvim/ftplugin/java.lua
--
-- Scala:
--   ~/.config/nvim/ftplugin/scala.lua
--
-- Lua:
--   ~/.config/nvim/ftplugin/lua.lua

vim.pack.add {
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/igorlfs/nvim-dap-view",
}

local dap = require "dap"
local widgets = require "dap.ui.widgets"
local my_border = require("lervag.const").border

dap.set_log_level "INFO"

-- Define sign symbols
vim.fn.sign_define {
        -- stylua: ignore start
        { text = "🡆", texthl = "DapSign", name = "DapStopped", linehl = "CursorLine" },
        { text = "●", texthl = "DapSign", name = "DapBreakpoint" },
        { text = "", texthl = "DapSign", name = "DapBreakpointCondition" },
        { text = "▪", texthl = "DapSign", name = "DapBreakpointRejected" },
        { text = "◉", texthl = "DapSign", name = "DapLogPoint" },
  -- stylua: ignore end
}

---@diagnostic disable: missing-fields
local mappings = {
  ["<leader>dd"] = dap.continue,
  ["<leader>dD"] = dap.run_last,
  ["<leader>dc"] = dap.run_to_cursor,
  ["<leader>dx"] = dap.terminate,
  ["<leader>dp"] = dap.step_back,
  ["<leader>dn"] = dap.step_over,
  ["<leader>dj"] = dap.step_into,
  ["<leader>dk"] = dap.step_out,
  ["<leader>dK"] = dap.up,
  ["<leader>dJ"] = dap.down,
  ["<leader>db"] = dap.toggle_breakpoint,
  ["<leader>d<c-b>"] = dap.clear_breakpoints,
  ["<leader>dB"] = function()
    vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
      dap.set_breakpoint(condition)
    end)
  end,
  ["<leader>dh"] = function()
    widgets.hover("<cexpr>", {
      border = my_border,
      title = " hover ",
    })
  end,
  ["<leader>dE"] = function()
    vim.ui.input({
      prompt = " evaluate ",
      border = my_border,
    }, function(expr)
      widgets.hover(expr, {
        border = my_border,
        title = " evaluated: " .. expr .. " ",
      })
    end)
  end,
}

for lhs, rhs in pairs(mappings) do
  vim.keymap.set("n", lhs, rhs)
end

-- DAP VIEW

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dap-view", "dap-view-term" },
  callback = function()
    vim.wo.list = false
  end,
})

vim.keymap.set("n", "<leader>dw", "<cmd>DapViewWatch<cr>")
vim.keymap.set("n", "<leader>dW", ":DapViewWatch ")

-- https://igorlfs.github.io/nvim-dap-view/configuration
require("dap-view").setup {
  auto_toggle = true,
  winbar = {
    sections = {
      "scopes",
      "repl",
      "threads",
      "watches",
      "breakpoints",
      "exceptions",
    },
    default_section = "scopes",
  },
  windows = {
    size = 0.4,
    position = "right",
    terminal = {
      size = 0.5,
      position = "below",
    },
  },
  icons = {
    collapsed = " ",
    expanded = " ",
  },
}
