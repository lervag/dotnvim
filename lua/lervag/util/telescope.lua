local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local action_state = require "telescope.actions.state"

local M = {}

function M.files()
  local dir = vim.fn.FindRootDirectory()
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  builtin.find_files({
    prompt_title = "Find Files: " .. dir,
    cwd = dir,
  })
end

function M.files_nvim()
  builtin.git_files({
    prompt_title = "Find Files: ~/.config/nvim",
    cwd = '~/.config/nvim',
  })
end

function M.files_dotfiles()
  builtin.git_files({
    prompt_title = "Find Files: ~/.dotfiles",
    cwd = '~/.dotfiles',
  })
end

function M.files_plugged()
  builtin.find_files({
    prompt_title = "Find Files: ~/.local/plugged",
    cwd = '~/.local/plugged',
  })
end

-- local sorters = require("telescope.sorters")
function M.files_wiki()
  builtin.find_files({
    prompt_title = "Wiki files",
    cwd = '~/.local/wiki',
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
  })
end

function M.files_zotero()
  local path = '~/.local/zotero/storage'
  builtin.find_files({
    prompt_title = "Zotero",
    cwd = path,
    disable_devicons = true,
    path_display = { "tail" },
    find_command = { "fd", "--type", "f", "-e", "pdf", "--strip-cwd-prefix" },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        vim.fn.jobstart({'sioyek', '--fork', path .. "/" .. selection})
      end)
      return true
    end,
  })
end

return M
