local M = {}

function M.files(opts)
  local builtin = require "telescope.builtin"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local dir = vim.fn.FindRootDirectory()
  if dir == "" then
    dir = vim.fn.getcwd()
  end

  opts = opts
    or {
      prompt_title = "Find Files: " .. dir,
      cwd = dir,
      no_ignore = false,
    }

  opts.attach_mappings = function(_, map)
    map({ "n", "i" }, "<C-i>", function(prompt_bufnr)
      opts.default_text = action_state.get_current_line()
      opts.no_ignore = not opts.no_ignore
      actions.close(prompt_bufnr)
      M.files(opts)
    end)
    return true
  end

  builtin.find_files(opts)
end

function M.files_nvim()
  local builtin = require "telescope.builtin"
  builtin.git_files {
    prompt_title = "Find Files: ~/.config/nvim",
    cwd = "~/.config/nvim",
  }
end

function M.files_dotfiles()
  local builtin = require "telescope.builtin"
  builtin.git_files {
    prompt_title = "Find Files: ~/.dotfiles",
    cwd = "~/.dotfiles",
  }
end

function M.files_plugged()
  local builtin = require "telescope.builtin"
  builtin.find_files {
    prompt_title = "Find Files: ~/.local/plugged",
    cwd = "~/.local/plugged",
  }
end

-- local sorters = require("telescope.sorters")
function M.files_wiki()
  local builtin = require "telescope.builtin"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  builtin.find_files {
    prompt_title = "Wiki files",
    cwd = "~/.local/wiki",
    disable_devicons = true,
    find_command = { "rg", "--files", "--sort", "path" },
    file_ignore_patterns = {
      "%.stversions/",
      "%.git/",
    },
    path_display = function(_, path)
      local name = path:match "(.+)%.[^.]+$"
      return name or path
    end,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace_if(function()
        return action_state.get_selected_entry() == nil
      end, function()
        actions.close(prompt_bufnr)

        local new_name = action_state.get_current_line()
        if new_name == nil or new_name == "" then
          return
        end

        vim.fn["wiki#page#open"](new_name)
      end)

      return true
    end,
  }
end

function M.files_zotero()
  local builtin = require "telescope.builtin"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local path = "~/.local/zotero/storage"
  builtin.find_files {
    prompt_title = "Zotero",
    cwd = path,
    disable_devicons = true,
    path_display = { "tail" },
    find_command = { "fd", "--type", "f", "-e", "pdf", "--strip-cwd-prefix" },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        -- vim.fn.jobstart { "sioyek", "--fork", path .. "/" .. selection }
        vim.fn.jobstart { "zathura", path .. "/" .. selection }
      end)
      return true
    end,
  }
end

return M
