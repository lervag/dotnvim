vim.pack.add { "https://github.com/folke/snacks.nvim" }

---@type snacks.Config
local opts = {

  bigfile = { enabled = true },
  explorer = {
    replace_netrw = true,
  },
  input = {
    expand = false,
    win = {
      style = "input",
      relative = "cursor",
      row = -3,
      col = 0,
      border = require("lervag.const").border,
      keys = {
        i_cu = { "<c-u>", "<c-u>", mode = "i", expr = true },
        i_esc = {
          "<esc>",
          { "cmp_close", "stopinsert", "cancel" },
          mode = "i",
          expr = true,
        },
      },
    },
  },
  picker = {
    layout = {
      preset = "vscode",
      ---@diagnostic disable-next-line: missing-fields
      layout = {
        width = 0.5,
        height = 0.9,
      },
    },
    sources = {
      files = {
        hidden = true,
      },
      explorer = {
        auto_close = true,
        hidden = true,
        ignored = true,
        layout = {
          fullscreen = true,
          preset = "sidebar",
        },
        actions = {
          confirm_fast = function(picker, item, action)
            local Tree = require "snacks.explorer.tree"
            local Actions = require "snacks.explorer.actions"

            if not item then
              return
            elseif item.dir then
              Tree:toggle(item.file)
              Actions.update(picker, { target = item.file })
            elseif picker.input.filter.meta.searching then
              Snacks.picker.actions.confirm(picker, item, action)
            else
              Actions.actions.confirm(picker, item, action)
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<cr>"] = { "confirm_fast", mode = { "i" } },
              ["<s-cr>"] = { "cycle_win", mode = { "i" } },
              ["<tab>"] = { "list_down", mode = { "i" } },
              ["<s-tab>"] = { "list_up", mode = { "i" } },
            },
          },
          list = {
            keys = {
              ["<cr>"] = "confirm_fast",
              ["<s-cr>"] = "cycle_win",
              ["-"] = "explorer_up",
            },
          },
        },
      },
    },
    matcher = {
      fuzzy = false,
      frecency = true,
      cwd_bonus = true,
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<f1>"] = { "toggle_help_input", mode = { "n", "i" } },
          ["<c-u>"] = { "<c-u>", mode = { "i" }, expr = true },
          ["<tab>"] = { "list_down", mode = { "i" } },
          ["<s-tab>"] = { "list_up", mode = { "i" } },
        },
      },
    },
  },
  quickfile = { enabled = true },
}

require("snacks").setup(opts)

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.recent()
end)
vim.keymap.set("n", "<leader>oo", function()
  Snacks.picker.files()
end)
vim.keymap.set("n", "<leader>ob", function()
  Snacks.picker.buffers()
end)
vim.keymap.set("n", "<leader>op", function()
  Snacks.picker.files {
    title = "Neovim plugin files",
    cwd = "~/.local/share/nvim/site/pack/core/opt/",
  }
end)
vim.keymap.set("n", "<leader>ev", function()
  Snacks.picker.files {
    title = "Neovim config",
    cwd = "~/.config/nvim",
  }
end)
vim.keymap.set("n", "<leader>ez", function()
  Snacks.picker.files {
    title = "Dotfiles",
    cwd = "~/.dotfiles",
  }
end)
vim.keymap.set("n", "<leader>ow", function()
  Snacks.picker.files {
    title = " Wiki ",
    cwd = "~/.local/wiki",
    exclude = { ".gitignore" },
    matcher = { sort_empty = true },
    sort = {
      fields = { "score:desc", "#text", "file" },
    },
    confirm = function(picker, item, action)
      if item then
        ---@diagnostic disable-next-line: call-non-callable
        Snacks.picker.actions[action.name](picker, item, action)
      else
        picker:close()
        local new_name = picker.finder.filter.pattern
        if new_name and new_name ~= "" then
          vim.fn["wiki#page#open"](new_name)
        end
      end
    end,
    format = function(item)
      local ret = {}

      local name = item.file
      if name and name:find "%.wiki$" then
        name = name:match "(.+)%.wiki$"
      end
      ret[#ret + 1] = { name, "SnacksPickerFile" }

      return ret
    end,
  }
end)
vim.keymap.set("n", "-", function()
  local root = vim.fn.FindRootDirectory()
  if root == "" then
    root = vim.fn.expand "%:h"
  end
  Snacks.picker.explorer {
    cwd = root,
  }
end)
vim.keymap.set("n", "<c-u>", function()
  Snacks.bufdelete()
end)
